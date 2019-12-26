

Is there a way of creating a function while without bother creating sql function system object? Yes. 
with the sp_executesql command, we can do it.

In the following code snippet for a trigger, I want to get the old value and the new value of a column 
which is a variable. so I need to use dynamic sql. and further more, I need to pass parameters to the 
code block and I expect the result passed back through output parameters. I first tried to exec a dynamic 
sql string, it doesn't work since I can't use parameters. but with sp_executesql, it works out.


```

  -- sp_executesql

	declare @ov varchar(1000) 
	declare @nv varchar(1000)
	declare @fn varchar(128)
	set @fn = @colNames
	declare @cmd nvarchar(4000)
	declare @pm nvarchar(128)
	set @pm = N'@ov varchar(1000) output, @nv varchar(1000) output'

	set @cmd = N'select  @nv = i.' + @fn + N', @ov = d.'+ @fn + N' from #ins i join #del d on i.Id = d.Id' 

	exec sp_executesql @cmd, @pm, @ov output, @nv output 

	print(@ov)
	print (@nv)
	
```
