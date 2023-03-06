session.fs.mkdir("/sivr", "./sivr");
session.dbms.register("payrollvip","sqlserver","Data Source=vip-crm-sql;Initial Catalog=VIPCRM;User Id=Presence;Password=1novo123;MultipleActiveResultSets=true;");
session.dbms.register("presence","sqlserver","server=SOFJHBCLSQL13\\SOFJHBCLSQL11;database=SQLPR1;User Id=PTOOLS;Password=PTOOLS;Integrated Security=False;");

session.listening.listen(":1040");