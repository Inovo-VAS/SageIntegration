<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="webpopup.aspx.cs" Inherits="payrolllpopup.WebForm1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Web pop-up</title>
    <style>
        body {
            font-family: Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        table {
            border-collapse: collapse;
            margin-left: auto;
            margin-right: auto;
            border-radius: 6px;
        }

        tbody tr:nth-child(odd) {
            background: #eee;
        }

        td, th {
            border: 1px solid #999;
            padding: 0.5rem;
            text-align: left;
            width: 300px;
        }
    </style>
</head>
<body >
     <p style="text-align: center;">
        <img src="http://root.pastel.co.za/ClientZone/Images/Sage_logo.png?v=2" alt="Banner" width="100" style="border: 0px; display: block;margin: auto;" />
    </p>
   <% 
       var ucid = Request.Params.Get("UCID");
       var login = Request.Params.Get("LOGIN");
       if (ucid!=null && ucid != "" && login !=null && login != "") {
           var cnstrng = System.Configuration.ConfigurationManager.AppSettings.Get("presencedb");
           var sqlcn = new System.Data.SqlClient.SqlConnection(cnstrng);
           sqlcn.Open();
           var sqlcmd = sqlcn.CreateCommand();
		   sqlcmd.Parameters.Add("@UCID", System.Data.SqlDbType.NVarChar);
           sqlcmd.Parameters["@UCID"].Value = ucid;
           sqlcmd.Parameters.Add("@LOGIN", System.Data.SqlDbType.NVarChar);
           sqlcmd.Parameters["@LOGIN"].Value = login;
           sqlcmd.CommandText = "EXECUTE PTOOLS.spSYNCPAYROLLLOGINTOUCID @UCID,@LOGIN";
           var sqlrdr = sqlcmd.ExecuteReader();
           %><table><%
           while (sqlrdr.Read())
           {
           %><tr>
               <td><% Response.Write(sqlrdr[1]); %></td><td><% Response.Write(sqlrdr[2]); %></td>
              </tr><%
            }
            %></table><%
            sqlrdr.Close();
            sqlcmd.Dispose();
            sqlcn.Close();
           }
       %>
</body>
</html>
