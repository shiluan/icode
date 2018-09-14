var str = `
Set Up External Web Servers (OIDWB86AV and BV).


[[#server. OIDWB86AV]]
[[#server. OIDWB86BV]]

1.	Send request to network analyst to add both servers to be able to listen to port 5505 (Devl) and 5503 (Syst) on INT server. (VI 79339 done by Haoran Yang). Check the ports as they might change back to 5501 [[EnableTcpPort]]

2.	Make sure in C:\Security\Server.Inf.Bat the SvrName is set to your current server name.[[SetSvrName]]


a.	 SET SvrName=<current server name>

3.	Copy files in side D:\SECURITY\ from Old server to the new server. [[CopyFiles]]

4.	Run script to create directory structure for ETS and to assign permissions. Different directory structure is created on each server thus each has its own script (FTPRoot does not exist on B). The file location is D:\SECURITY\ETS.BAT
5.	Change the D:\APPCTN\ETS\FTPROOT folder to a share (Server A) and change FTPROOT share permissions to full control for everyone. [[SetFolderPermission]]

6.	Give DEVDMZ\ETS_DEVL Change permissions on the Program Files\Web\Log folder  [[SetFolderPermission]]
7.	Give DEVDMZ\ETS_DEVL Change permissions on the C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files [[SetFolderPermission]]


[[#folder.ETS]]
8.	Make ETS folder to be a shareable folder and grant full access to everyone [[SetFolderPermission]]
9.	Grant ETS_DEVL user Read access to ETS folder [[SetFolderPermission]]
10.	Grant ETS_DEVL user Modify Access to DEVL branch [[SetFolderPermission]]

IIS
11.	On IIS stop Default Website [[stopWebsite]]
12.	On IIS Setup ETSDevlAppPool [[setupWebsiteAppPool]]
 
13.	Make sure to use ETS_ENV user as Identity [[?]]

[[#website.ETS]]
14.	Create ETS web site on oidwb86av and oidwb86bv with its own IP address and attach server certificate.

Make sure to connect as doedmz\ets_devl account.  
15.	Edit the bindings to like the following on OIDWB86AV
  
16.	Edit the bindings to like the following on OIDWB86BV

17.	Enable Anonymous Authentication and ASP.Net Impersonation on both servers for ETS web site.
 
18.	Go to HTTP Headers tab and add the X-Frame-Options with a value of SAMEORIGIN (this is done because of DI 78961. As a result of this, the setting gets added to the Web.config file.

19.	Make sure that ASP.Net State Service is started and is marked to Start Automatically. 
20.	Make sure that Microsoft FTP service is started and is marked to Start Automatically. 
21.	Make changes to Web.Config under web folder to replace OIDEV50AV with OIDWB86AV.

[[FTPSite.ETS]]
22.	Create FTP site ETS on OIDWB86AV  
23.	Create FTP site ETS on OIDWB86BV 
24.	Set DefaultLogonDomain for FTP site, so that users don’t need to prefix accounts by domain name. 

[[Context]]
25.	Send a request to GIS team to change their reference for Create Posting and Create Bidding to OIDWB86V from OIDEV50V. [[@GIS.Team]]
26.	Change all references in the MigrationTool.exe.config from OIDEV50AV to OIDWB86AV and OIDEV50BV to OIDWB86BV.


27.	Ask migration team to run the migration tool to compile and deploy to EXTERNAL servers [[@MigrationTeam]][[migrateWebApp]]
28.	Ask Energy IT Service Desk to Backup and Restore the FTPROOT folder, since permissions need to be copied over to the new server.[[ServiceDesk, BackupRestorFoder]]
29.	On Production date, all directories under the subscription folder should be copied over from the old server to the new server, The location of the folders are [[CopyFolder]]
a.	\\OIxxxxxAV.mgt.dev.dmz\applctn\ETS\FTPROOT\SUBSCRPTN




Test the following:
	Posting - Query by Land
	Posting - Query by Map
	Bidding – Query by Map
	OASIS
	Transfers
	Land Searches
	ETS Application

Trouble shooting 
1.	Web site is white
a.	Check the log file in the server for the error but basically the remoting is not configured correctly.




`;
    
    
    
/*
 * ontology and annotation 
 */    
var re = /\[\[[\w\.\@\#]*\]\]/img;
var found = str.match(re);
console.log(found);

var results = found.reduce(function(countMap, word) {countMap[word] = ++countMap[word] || 1;return countMap}, {});
console.log(results);


/*
 * count words in a document
 */
// remove line breaks
var str1 = str.replace(/\^\s+|\s+$/g, '');
// remove extra spaces
str1 = str1.replace(/\s+/g, ' ');
var words = str1.split(' ');
console.log(words);
