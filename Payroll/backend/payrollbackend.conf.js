session.fs.mkdir("/sivr", "C:/Inovo/Payroll/backend/sivr");
session.dbms.register("payrollvip","sqlserver","Data Source=vip-crm-sql;Initial Catalog=VIPCRM;User Id=Presence;Password=1novo123;MultipleActiveResultSets=true;");
session.dbms.register("pastel","sqlserver","Server=SOFJHBCLSQL01\\PASJHBCLSQL01;User Id=Presence;Password=1novo123;MultipleActiveResultSets=true;");
session.dbms.register("presence","sqlserver",'server=tcp:SOFJHBCLSQL13\\SOFJHBCLSQL11;database=SQLPR1;User Id=PTOOLS;Password=PTOOLS;MultipleActiveResultSets=true;');
var rec=session.dbms.query({"alias":"presence","query":"select getdate() as d","error":function(err){
	print(err.toString());
}});
	if (rec!==undefined && rec!==null && rec.next()){
		print(rec.data()[0]);
	}
session.listening.listen(":1040");