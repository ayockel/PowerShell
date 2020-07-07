Import-Module “D:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1” 

CD XXX: 

$collections = Get-WmiObject -Namespace "root\sms\XXX" -ComputerName XXX -Query "select * from sms_appdeploymentstatus where CollectionName like 'zPortal%'" 
$olddeployments = Get-WmiObject -Namespace "root\sms\XXX" -ComputerName XXX -Query "select * from sms_collection where Name like '%zportal%' and (DateDiff(day, LastChangeTime, GetDate()) > 15)"

#Delete successful deployments
Foreach($collection in $collections){ 

 $collectionID = $collection.CollectionID 

 $deploymentstatus = Get-WmiObject -Namespace "root\sms\XXX" -ComputerName XXX -Query "select * from sms_appdeploymentstatus where CollectionID = '$collectionID'" 

  Foreach($status in $deploymentstatus){
    if($status.EnforcementState = '1000' -or '1001'){
        echo "Removing " $status.CollectionName
        Remove-CMDeviceCollection -Id $collectionID -Force
    }
  }

} 


#Delete any deployments older than 15 days
foreach($oldcollection in $olddeployments){

    $collID = $oldcollection.CollectionID
    Remove-CMDeviceCollection -Id $collID -Force

}
