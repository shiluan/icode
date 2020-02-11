@echo off
REM build a solution
REM

cd C:\Users\kevin.luan\source\repos\Kevin_ETS_Cmds

"%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild" kevin_ets_cmds.sln -t:rebuild

REM on error
if %ERRORLEVEL% GEQ 1 EXIT /B %ERRORLEVEL%


REM deployment 
REM
cd C:\Temp\ets_qry_autobuild
copy C:\Users\kevin.luan\source\repos\Kevin_ETS_Cmds\EtsDbQryCmd\bin\Debug\*.*

echo "Done!"
