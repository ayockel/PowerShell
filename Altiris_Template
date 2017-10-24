<#

.Format 
    Windows PowerShell Language Specification Version 3.0 
    https://www.microsoft.com/en-us/download/details.aspx?id=36389

.SYNOPSIS
    Template used to recreate Altiris-style deployments in SCCM.

.DESCRIPTION
    Altiris_Template.ps1 is a customizable PowerShell installation script that emulates the deployment steps of an Altiris policy for SCCM.  It contains functions for common deployment tasks, logging, and error checking.

.NOTES
    File Name      : Altiris_Template
    Author         : Austin Yockel (ayockel@celgene.com)
    Prerequisite   : PowerShell (PoSh) V2 over Windows 10 RTM (a.k.a. 1507) or Windows Server 2016 or newer.
    Version        : 1.2

.LINK
    Script posted over:
.EXAMPLE
    Example 1
.EXAMPLE
    Example 2
#>

#GLOBAL VARIABLES
##########################################################################

#Enter values
$logpath = "C:\Windows\Celgene\Logs"            #Logpath
$LOGNAME = "Altiris_Template"                    #Logname                                                                                       
$ErroActionPreference = "SilentlyContinue"      #Default terminating error action

#Static values (do not touch)
$logfile = $logpath + "\$LOGNAME.log"
$shell = New-Object -ComObject Wscript.Shell
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
###########################################################################

#FUNCTIONS
###########################################################################

#Get-Timestamp
## Gets current timestamp in readable format
## e.g. Get-Timestamp()
function Get-TimeStamp {   
    return "[{0:MM/dd/yy} {0:HH:mm:ss}] " -f (Get-Date) 
}

#WriteLog
## Writes to a custom log file in C:\Windows\Celgene\Logs
## e.g. WriteLog("Your text here...")
function WriteLog($logtext) {
    $timestamp = Get-TimeStamp
    if(Test-Path $logfile){
        $text = $timestamp + "" + $logtext
        $text | out-file $logfile -Append
        echo $text
    }
    else {
        $text = $timestamp + $logtext
        $text | out-file $logfile
        echo $text
    }
}

#Block-UserInput
## Disables mouse and keyboard input until killed by Unblock-UserInput.  Requires BlockInput.exe in same directory.
## e.g. Block-UserInput()
function Block-UserInput() {
    .\BlockInput.exe
}

#Unblock-UserInput
## Kills BlockInput.exe
## e.g. Unblock-UserInput()
function Unblock-UserInput() {
    Stop-Process -Name "blockinput"
}

#FileVersionDetectionCheck
## Compares FileVersion property of a file to specified version (format 1.1.1.1) and returns False if file version is lower than specified version.
## e.g. FileVersionDetectionCheck "c:\program files\internet explorer\iexplore.exe" "11.9.999.0"
function FileVersionDetectionCheck() {
    param([string]$file,[string]$version)
    $fileversion = (get-item $file).VersionInfo.ProductVersion
    $fileversionobject = [System.Version]$fileversion
    $targetversion = [System.Version]$version
    if($fileversionobject -ge $targetversion) {
        return $true
    }
    else {
        return $false
    }
}

#UninstallGUIDDetectionCheck
## Searches the registry for uninstall key under HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall (and 64bit location). Returns true if found.
## e.g. UninstallGUIDDetectionCheck -GUID "FB54F620-9555-3A11-26CB-B027C4DDF260"
function UninstallGUIDDetectionCheck {
param($GUID)
$results = @()
if($env:PROCESSOR_ARCHITECTURE = "AMD64"){
    $keys = Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | where {$_.Name -match $guid}
    if($keys) {
        return $true
    }
    else {
        return $false
    }
}
else {
    $keys = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | where {$_.Name -match $guid}
    if($keys) {
        return $true
    }
    else {
        return $false
    }
  } 
}

#RegVersionDetectionCheck
## Compares DisplayVersion property of a registry uninstall key to specified version and returns False if registry version is lower than specified version.
## e.g. RegVersionDetectionCheck -GUID "05935793-A34C-4272-3361-7AF9AEEE5649" -DISPLAYVERSION "10.1.14393.0"
function RegVersionDetectionCheck {
    param([string]$GUID,[string]$DISPLAYVERSION)
    if($env:PROCESSOR_ARCHITECTURE = "AMD64"){
        $key = Get-ItemProperty "HKLM:\software\wow6432node\microsoft\windows\currentversion\Uninstall\{$guid}"
        if($key.DisplayVersion -ge $DISPLAYVERSION){
            return $true
        }
        else {
            return $false
        }
    }
    else {
        $key = Get-ItemProperty "HKLM:\software\wow6432node\microsoft\windows\currentversion\Uninstall\{$guid}"
        if($key.DisplayVersion -ge $DISPLAYVERSION){
            return $true
        }
        else {
            return $false
        }
    }
}
###########################################################################







#START

#Set up log folder
###########################################################################
try {
    if(!(Test-Path $logpath)){
        New-Item -ItemType Directory -Force -Path $logpath
    }
}
catch {
    WriteLog($_.Exception.Message)
}

#USER NOTIFICATION
###########################################################################
#try {
#    $shell.Popup("ITGDS will now perform an important system update.  If Outlook is open, please close it now or it will close automatically in 2 minutes.  Your keyboard and mouse will be disabled during this process which will take approximately 5 minutes.  Click OK to update now, otherwise it will start automatically in 2 minutes.", 120, "ITGDS System Update", 0x0 + 0x20)
#}
#catch {
#    WriteLog($_.Exception.Message)
#    Exit
#}
#try {
#    Block-UserInput
#}
#catch {
#    WriteLog($_.Exception.Message)
#    Exit
#}
###########################################################################

#TASK 1
###########################################################################

###########################################################################

#TASK 2
###########################################################################

###########################################################################

#TASK 3
###########################################################################

###########################################################################

#SOFTWARE 1
###########################################################################
#$detectioncheckFile = "C:\Program Files\Internet Explorer\iexplore.exe"
#$detectioncheckVersion = "15.0.0.0"
#if(FileVersionDetectionCheck "$detectioncheckFile" "$detectioncheckVersion" -eq $true) {
#    WriteLog("Detection check.....Latest version detected....Continuing")
#}
#else {
#    WriteLog("Detection check....Latest version not detected....Installing")
#    try {
#        WriteLog("Installing...")
#        $installresult = (Start-Process -filepath "$PSScriptRoot\file.exe" -Wait -PassThru).ExitCode
#        WriteLog("Installation finished with return code: $installresult")
#    }
#    catch {
#        WriteLog($_.Exception.Message)
#    }
#}
###########################################################################

#SOFTWARE 2
###########################################################################
#if(UninstallGUIDDetectionCheck -GUID "535cde5a-39d6-46ee-b6e5-9f38d0664d97" -eq $true) {
#    WriteLog("Detection check.....Latest version detected....Continuing")
#}
#else {
#    WriteLog("Detection check....Latest version not detected....Installing")
#    try {
#        WriteLog("Installing...")
#        $installresult = (Start-Process -filepath "$PSScriptRoot\file.exe" -ArgumentList "/s" -Wait -PassThru).ExitCode
#        WriteLog("Installation finished with return code: $installresult")
#    }
#    catch {
#        WriteLog($_.Exception.Message)
#    }
#}
###########################################################################

#SOFTWARE 3
###########################################################################
#try {
#    WriteLog("Installing...")
#    $installresult = (Start-Process msiexec.exe -ArgumentList "/i $PSScriptRoot\file.msi /qn /norestart" -Wait -PassThru).ExitCode
#    WriteLog("Installation finished with return code: $installresult")
#}
#catch {
#    WriteLog($_.Exception.Message)
#}
###########################################################################

#CLEANUP
###########################################################################
#Unblock-UserInput
###########################################################################
