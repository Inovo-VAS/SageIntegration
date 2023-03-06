Function Start-TaggingRecordings
{
    $dataSourcePresence = "SOFJHBCLSQL13\SOFJHBCLSQL11"
    $userPresence = "PREP"
    $pwdPresence = "PREP"
    $databasePresence = "SQLPR1"
    $connectionStringPresence = "Server=$dataSourcePresence;uid=$userPresence; pwd=$pwdPresence;Database=$databasePresence;Integrated Security=False;"

    $conPresence = New-Object System.Data.SqlClient.SqlConnection
    $conPresence.ConnectionString = $connectionStringPresence

    $dataSourcePastel = "SOFJHBCLSQL01\PASJHBCLSQL01"
    $userPastel = "Presence"
    $pwdPastel = "1novo123"
    $databasePastel = "Pastel"
    $connectionStringPastel = "Server=$dataSourcePastel;uid=$userPastel; pwd=$pwdPastel;Database=$databasePastel;Integrated Security=False;"

    $conPastel = New-Object System.Data.SqlClient.SqlConnection
    $conPastel.ConnectionString = $connectionStringPastel

    Try{
        $conPastel.Open()
        echo "connected to Pastel Db Server - Pastel"
    
        $conPresence.Open()
	    echo "connected to Presence DB Server - PREP"
    
        while($true){

            $commandPresence=$conPresence.createCommand()
            $queryPresence="SELECT RDATE,LOGIN,ID AS RECID,NAME AS AGENTNAME,UCID,QCODE,SERVICEID FROM (SELECT rec.RDATE,rec.LOGIN,rec.ID,agent.NAME,inbound.UCID,inbound.QCODE,inbound.SERVICEID FROM PREP.PREC_RECORDING rec INNER JOIN PREP.PCO_INBOUNDLOG inbound ON rec.CONTACTID=inbound.ID LEFT JOIN PREP.PCO_LOGINAGENT loginagent ON loginagent.LOGIN=inbound.LOGIN INNER JOIN PREP.PCO_AGENT agent ON agent.ID=loginagent.AGENTID where rec.APPDATA='' UNION SELECT rec.RDATE,rec.LOGIN, rec.ID,agent.NAME,outbound.UCID,outbound.QCODE,outbound.SERVICEID FROM PREP.PREC_RECORDING rec INNER JOIN PREP.PCO_OUTBOUNDLOG outbound ON rec.CONTACTID=outbound.ID LEFT JOIN PREP.PCO_LOGINAGENT loginagent ON loginagent.LOGIN=outbound.LOGIN INNER JOIN PREP.PCO_AGENT agent ON agent.ID=loginagent.AGENTID where rec.APPDATA='') LOGGEDRECORDINGS WHERE LOGGEDRECORDINGS.RDATE<=DATEADD(MINUTE,-30,GETDATE()) AND UCID<>''"
            $commandPresence.CommandText=$queryPresence
            $adapterPresence = New-Object System.Data.SqlClient.SqlDataAdapter $commandPresence
            $datasetPresence = New-Object System.Data.DataSet
            $adapterPresence.Fill($datasetPresence)
            $tableUntaggedRecordings=$datasetPresence.Tables[0]

            $tableUntaggedRecordings | foreach {
               # write-host "$($_.RDATE) $($_.LOGIN) $($_.RECID) $($_.AGENTNAME) $($_.UCID) $($_.QCODE) $($_.SERVICEID)"
               $commandPastelClients=$conPastel.CreateCommand()


               $queryStringPastel="SELECT UPPER(ClientId) AS ClientId FROM Pastel.dbo.tPresenceLog WHERE ClientId>0 and UCID='$($_.UCID)'"
               # write-host "$queryStringPastel"

               $commandPastelClients.CommandText=$queryStringPastel

               $adapterPastel = New-Object System.Data.SqlClient.SqlDataAdapter $commandPastelClients
               $dataSetPastel = New-Object System.Data.DataSet
               $adapterPastel.Fill($dataSetPastel)
               $recappdata="N/A"
               $dataSetPastel.Tables[0] | foreach{
                   if($_.ClientId -eq 0){
                    $recappdata="N/A"
                   }
                   else{
                    $recappdata="$($_.ClientId)"
                    echo "FOUND CLIENT $($_.ClientId)"
                   }
               }

               $recappdata="$($_.AGENTNAME) - $recappdata"
               try{
               $commandUpdateRecordingData=$conPresence.CreateCommand()
               $queryUpdateRecordingData="UPDATE PREP.PREC_RECORDING SET APPDATA='$recappdata' WHERE ID=$($_.RECID)"
               $commandUpdateRecordingData.CommandText=$queryUpdateRecordingData

               # echo "upate recording [$queryUpdateRecordingData]"

               $commandUpdateRecordingData.ExecuteNonQuery()
               }
               Catch{
                echo "FAILED upate recording [$queryUpdateRecordingData] $_.Exception.Message"  
               }
               # echo $recappdata

            }

            GET-DATE
            Start-Sleep -Seconds 30
            GET-DATE

        }

	    $conPresence.Close() 
	    echo "connection to Presence DB Server - PREP [closed]"
        $conPastel.Close() 
	    echo "connection to Pastel DB Server - Presence [closed]"
    }
    Catch{
        echo "Failed"+$_.Exception.Message
    }
}

# Start-TaggingRecordings