#This script will connect to the COMPANY O365 instance, create the user's account/mailbox, assign O365 Enterprise E3 license, set the password, add it to requested distribution lists, and enable it for litigation hold.
#It will also create the account in Active Directory and email them a welcome packet.
#It will require the Windows Azure Active Directory Module for Windows Powershell, which can be downloaded here (http://go.microsoft.com/fwlink/p/?linkid=236297) as well as Remote Server Administration Tools


#Import required modules
Import-Module MSOnline
Import-Module ActiveDirectory

#Get credentials to connect
$UserCredential = Get-Credential

#Connect to O365
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Connect to MSol
Try
{
	Connect-MsolService -Credential $UserCredential -ErrorAction Stop
}
Catch
{
	"Something went wrong connecting to MSOL"
}

#Prompt for user type
$userType = Read-host -Prompt 'Input the user type (Onshore or Offshore)'

If($userType -eq 'Onshore'){
	#Get user parameters
	$FirstName = Read-Host -Prompt 'Input the first name'
	$LastName = Read-Host -Prompt 'Input the last name'
	$Username = Read-Host -Prompt 'Input the AD username'
	$Title = Read-Host -Prompt 'Input the AD title'
    $Description = Read-Host -Prompt 'Input the description'
    $Laptop = Read-Host -Prompt 'Laptop? (yes or no)'
	$DisplayName = $FirstName + " " + $LastName
	$Alias = $FirstName + "." + $LastName
	$Email = $FirstName + "." + $LastName + "@COMPANY.com"
	$COMPANYContractConsultants = Read-Host -Prompt 'Add user to COMPANY Contract Consultants? (y/n)'
	$COMPANYHourlyConsultants = Read-Host -Prompt 'Add user to COMPANY Hourly Consultants? (y/n)'
	$COMPANYInternal = Read-Host -Prompt 'Add user to COMPANY Internal? (y/n)'
	$COMPANYCore = Read-Host -Prompt 'Add user to COMPANY Core? (y/n)'

	#Create account and mailbox, set password
	New-Mailbox -Alias $Alias -Name $Alias -FirstName $FirstName -LastName $LastName -DisplayName $DisplayName -MicrosoftOnlineServicesID $Email -Password (ConvertTo-SecureString -String -AsPlainText -Force)

	#Pause for 10 seconds to allow account creation
	Start-Sleep -s 10

	#Create SIP address
	$sipemail = "sip:" + $Email
	Set-Mailbox $Email -EmailAddresses $sipemail

	#Set usage location
	Set-MsolUser -UserPrincipalName $Email -UsageLocation "US"

	#Assign O365 Enterprise E3 license and usage location
	Set-MsolUserLicense -UserPrincipalName $Email -AddLicenses "company:ENTERPRISEPACK"

	#Enable litigation hold indefinitely
	Set-Mailbox $Email -LitigationHoldEnabled $true

	#Add user to distribution lists 
	if ($COMPANYContractConsultants -match "y")
	{
		Add-DistributionGroupMember -Identity "COMPANY Contract Consultants" -Member $Email
	}
	if ($COMPANYHourlyConsultants -match "y")
	{
		Add-DistributionGroupMember -Identity "COMPANY Hourly Consultants" -Member $Email
	}
	if ($COMPANYInternal -match "y")
	{
		Add-DistributionGroupMember -Identity "COMPANY Internal" -Member $Email
	}
	if ($COMPANYCore -match "y")
	{
		Add-DistributionGroupMember -Identity "COMPANY Core" -Member $Email
	}

	#Email user IT Welcome Packet
	$From = "me@company.com"
	$To = $FirstName + "." + $LastName + "@COMPANY.com"
	$Attachment = "\\share\it\documents\IT Welcome Packet.docx"
	$Subject = "IT Welcome Packet"
	$Body = "Welcome to COMPANY.  Please review the attached IT Welcome Packet for information about our systems."
	$SMTPServer = "smtp.office365.com"
	$SMTPPort = "587"
	Send-MailMessage -From $From -to $To -Subject $Subject `
	-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
	-Credential $UserCredential -Attachments $Attachment

	#Create the user in Active Directory
    New-ADUser -GivenName $FirstName -Surname $LastName -Name $DisplayName -DisplayName $DisplayName -Title $Title -SamAccountName $Username -UserPrincipalName ($Username + "@COMPANY.com") -AccountPassword (Read-Host -AsSecureString) -ChangePasswordAtLogon $false -Description $Description -Path -PassThru | Enable-ADAccount

	#Set the user's home directory
	Set-ADUser -Identity $Username -HomeDrive "H:" -HomeDirectory "\\share\users\$Username"
	
  #Add to GBL-EPUsers
  Add-ADGroupMember -Identity "GBL-EPUsers" -Member $Username

  #Add to GBL-VPNUsers if required
  If($Laptop = 'yes'){
      Add-ADGroupMember -Identity "GBL-VPNUsers" -Member $Username
  }
}
ElseIf($userType -eq 'Offshore'){
    #Get user parameters
    $FirstName = Read-Host -Prompt 'Input the first name'
    $LastName = Read-Host -Prompt 'Input the last name'
    $Username = Read-Host -Prompt 'Input the username'
    $DisplayName = $FirstName + " " + $LastName
    
    #Create the user in Active Directory
    New-ADUser -Name $DisplayName -DisplayName $DisplayName -SamAccountName $Username -UserPrincipalName ($Username + "@COMPANY.com") -AccountPassword (Read-Host -AsSecureString) -ChangePasswordAtLogon $false -Description "India" -Path "ou=Users,ou=COMPANY-Users,dc=COMPANY,dc=com" -PassThru | Enable-ADAccount

    #Add to GBL-EPUsers
    Add-ADGroupMember -Identity "GBL-EPUsers" -Member $Username
}
Else {
echo "Unknown user type"
}

#End session
Remove-PSSession $Session

#Press any key to continue
Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
