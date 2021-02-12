# Script is only configured for 64-bit systems.
# Update $SysMonConfig to point at the config file you want to use
$SysMonConfig = "https://raw.githubusercontent.com/johnwhirsch/sysmon-config/master/sysmonconfig-export.xml"

try{ Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile "$($env:APPDATA)\sysmon.zip"}
catch{ Write-Error "Unable to download Sysmon zip from Microsoft"; exit 660; }
 
if(Test-Path "$($env:APPDATA)\sysmon.zip"){
    try{ Expand-Archive -Path "$($env:APPDATA)\sysmon.zip" -DestinationPath "$($env:APPDATA)\sysmon-temp" -Force }
    catch {Write-Error "Unable to unzip sysmon.zip file"; exit 661; }
}
else{ Write-Error "Sysmon.zip doesn't exist"; exit 662; }
if(Test-Path "$($env:APPDATA)\sysmon-temp\sysmon64.exe"){
    try{ Invoke-WebRequest -Uri $SysMonConfig -OutFile "$($env:APPDATA)\sysmon-temp\config.xml" }
    catch{ Write-Error "Unable to download config file from GitHub"; exit 663; }
     
    try{ Start-Process "Sysmon64.exe" -WorkingDirectory "$($env:APPDATA)\sysmon-temp" -ArgumentList "-i -accepteula" -Wait }
    catch{ Write-Error "Unable to install sysmon64"; exit 664; }
     
    try{ Start-Process "Sysmon64.exe" -WorkingDirectory "$($env:APPDATA)\sysmon-temp" -ArgumentList "-c config.xml" -Wait }
    catch{ Write-Error "Unable to apply config file to sysmon"; exit 665; }
}
 
if((Get-Service -Name Sysmon64).Status -eq "Running"){ Write-Output "Install Succeeeded"; exit 0; }
else{ Write-Error "Install failed"; Exit 666; }
