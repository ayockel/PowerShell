Import-Module “D:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1” 

CD XXX: 

$currentdateminus30 = (get-date).adddays(-60)

$deployments = get-cmsoftwareupdatedeployment | where-object {($_.CreationTime -le $currentdateminus30) -and ($_.AssignmentName -like "wks-Monthly*")} | select AssignmentName, AssignmentID, Enabled

foreach($deployment in $deployments){

    Set-cmupdategroupdeployment -DeploymentName $deployment.AssignmentName -Disable

}
