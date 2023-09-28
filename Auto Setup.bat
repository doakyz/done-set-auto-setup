@echo off
#Download the latest version of the script from github
Powershell.exe Invoke-WebRequest -Uri https://raw.githubusercontent.com/doakyz/done-set-auto-setup/main/done-auto.ps1 -OutFile "./done-auto.ps1"
#Run the script
Powershell.exe -ExecutionPolicy Bypass -File "./done-auto.ps1"