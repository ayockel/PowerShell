Import-Module “D:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1” 

CD XXX: 


$applications = get-cmapplication | Where-Object {($_.LocalizedDisplayName -like 'wks-ss*') -and ($_.LocalizedDisplayName -notlike '*licensed*')}

$alreadydeployed = Get-WmiObject -Namespace root\sms\XXX -ComputerName XXX -Query "select TargetName from sms_deploymentinfo where CollectionName = 'WKS-SS-Unlicensed Software'"

foreach($application in $applications){
    if($application.LocalizedDisplayName -ne $alreadydeployed.TargetName){
        Start-CMApplicationDeployment -Name $application.LocalizedDisplayName -CollectionName "WKS-SS-Unlicensed Software" -DeployPurpose Available -UserNotification DisplaySoftwareCenterOnly       
    }
}
