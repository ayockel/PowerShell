#This script will connect to the Alliance O365 instance, unassign the license from the specified user, reset its password, remove it from any distribution groups, and convert its mailbox to a shared mailbox.
#It will also disable its account in Active Directory and move it to the Disable Users OU
#It will require the Windows Azure Active Directory Module for Windows Powershell, which can be downloaded here (http://go.microsoft.com/fwlink/p/?linkid=236297) as well as Remote Server Administration Tools

##### OFFICE 365 ############################################

#Import Azure AD Module
Import-Module MSOnline

#Get credentials to connect
$UserCredential = Get-Credential

#Get user email address
$Email = Read-Host -Prompt 'Input the email address to offboard'

#Connect to O365
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Convert user to shared mailbox
Set-Mailbox $Email -Type shared

#Remove the user from all distribution groups
$DGs = Get-DistributionGroup
foreach($dg in $DGs)
{
    Remove-DistributionGroupMember $dg.Name -Member $Email -BypassSecurityGroupManagerCheck -Confirm:$false -erroraction 'silentlycontinue'
}

#Remove all licenses
Connect-MsolService -Credential $UserCredential
$license = Get-MsolUser -UserPrincipalName $Email | select -ExpandProperty licenses
Set-MsolUserLicense -UserPrincipalName $Email -RemoveLicense $license.AccountSkuID

#Reset the user's password
Set-MsolUserPassword -UserPrincipalName $Email -NewPassword -ForceChangePassword $False

#End session
Remove-PSSession $Session

#Press any key to continue
Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#####################################################################


#### ACTIVE DIRECTORY ###############################################

#Import Active Directory module
Import-Module ActiveDirectory

#Get user samAccountName
$samAccountName = Read-Host -Prompt 'Input the username to offboard'

#Disable the account
Set-ADUser -Identity $samAccountName -Enabled $false

#Move to Disabled User Accounts OU
Get-ADUser $samAccountName | Move-ADObject -TargetPath

#Remove account from all security groups
$User = Get-ADUser $samAccountName -Properties memberOf
$Groups = $User.MemberOf | ForEach-Object {
	Get-ADGroup $_
}
$Groups | ForEach-Object {Remove-ADGroupMember -Identity $_ -Members $User}

#####################################################################
