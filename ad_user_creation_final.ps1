# Set number of users
$numberUsers = 3

# read names from files
$firstNames = (Get-Content -Path C:\temp\first-names.json) -join "`n"
$surnamesRaw = (Get-Content -Path C:\temp\surnames.json) -join "`n"


[void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
$jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
$jsonserial.MaxJsonLength  = 67108864

$firstNameArray = @($jsonserial.DeserializeObject($firstNames))
$surnameArray = @($jsonserial.DeserializeObject($surnamesRaw))

$firstNamesLength = $firstNameArray.Length
$surnameLength = $surnameArray.Length

write-host "Number of first names available: $firstNamesLength"
Write-Host "Number of surnames available: $surnameLength"

Write-Host "Will create $numberUsers users."


# Create users 
For ($i = 0; $i -lt $numberUsers; $i++){

    $firstName = $firstNameArray[(Get-Random -Maximum $firstNamesLength)]
    $middleName = $firstNameArray[(Get-Random -Maximum $firstNamesLength)]
    $lastName = $surnameArray[(Get-Random -Maximum $surnameLength)]
    $number = Get-Random -Minimum 1111111111 -Maximum 999999999999
    $randomNote = -join ((65..90) + (97..122) | Get-Random -Count 20 | % {[char]$_})
    $officeNumber = Get-Random -Minimum 1 -Maximum $numberUsers
    
    new-aduser -Name "$firstName $lastName" -PasswordNotRequired $true  -OtherAttributes @{
        'title'="director";
        'mail'="$firstname.$lastName@ADTest.com";
        'accountExpires'='0';
        'accountNameHistory'='50';
        'aCSPolicyName'='aCSPolicyName';
        'adminCount'="$i";
        'company'="ADTest";
        'codePage'="$i";
        'comment'="value$i";
        'userPassword'="sisenseTest1!";
        'displayName'="$firstName.$lastName";
        'description'="Users created for testing";
        'postOfficeBox'="45311";
        'street'="1600 Pennsylvania Avenue";
        'streetAddress'="1600 Pennsylvania Avenue";
        'profilePath'="www.ADTest.com/$firstName.$lastName";
        'scriptPath'="www.ADTest.com/$firstName.$lastName";
        'userSharedFolder'="www.ADTest.com/$firstName.$lastName";
        'userSharedFolderOther'="www.ADTest.com/$firstName.$lastName";
        'name'="$firstName.$lastName";
        'givenName'="$firstName";
        'middleName'="$middleName";
        'personalTitle'="value$i";
        'sn'="$lastName";
        'st'="DC";
        'physicalDeliveryOfficeName'="$officeNumber";
        'l'="Washington";
        'postalCode'="20008";
        'co'="United States";
        "homeDirectory"="www.ADTest.com/$firstName.$lastName"
        'userPrincipalName'="$firstName.$lastName";
        'homePhone'="$number";
        'telephoneNumber'="$number";
        'pager'="$number";
        'mobile'="$number";
        'facsimileTelephoneNumber'="$number";
        'ipPhone'="$number";
        'info'="$randomNote";
        'department'="Sales";
        'wWWHomePage'="www.ADTest.com/$firstName.$lastName";
        'initials'="AI";
     } -PassThru | Enable-ADAccount
}


# Create groups and and bind users