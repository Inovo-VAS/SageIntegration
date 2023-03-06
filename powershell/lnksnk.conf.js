session.fs.mkdir("/sivr", "./sivr");
session.dbms.register("payrollvip","sqlserver","Data Source=vip-crm-sql;Initial Catalog=VIPCRM;User Id=Presence;Password=1novo123;MultipleActiveResultSets=true;");
session.dbms.register("presence","sqlserver",'server=10.14.236.68\SOFJHBCLSQL11;database=SQLPR1;User Id=PTOOLS;Password=PTOOLS;Integrated Security=False;');
var rec=session.dbms.query({"alias":"presence","query":"select getdate() as d","error":function(err){
	print(err.toString());
}});
	if (rec!==undefined && rec!==null && rec.next()){
		print(rec.data()[0]);
	}
session.listening.listen(":1040");