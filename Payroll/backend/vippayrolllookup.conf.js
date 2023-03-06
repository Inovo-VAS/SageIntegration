<@  
	request.DBMS().RegisterDbConnection("payrollvip","SqlServer","Data Source=vip-crm-sql;Initial Catalog=VIPCRM;User Id=Presence;Password=1novo123;MultipleActiveResultSets=true;");
	request.DBMS().RegisterDbConnection("presence","SqlServer","Server=SOFJHBCLSQL13\\SOFJHBCLSQL11;Initial Catalog=SQLPR1;User Id=PTOOLS;Password=PTOOLS;MultipleActiveResultSets=true;");
	request.Listen("2000");
 @>