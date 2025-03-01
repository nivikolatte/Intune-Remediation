<#
.SYNOPSIS
    Creates a Safe Senders text file in C:\Temp and configures Outlook to use it.
.DESCRIPTION
    This script creates a text file with Safe Sender email addresses in C:\Temp using Unicode encoding
    and configures Outlook to import Safe Senders directly from this file.
.NOTES
    Version:        1.0
    For use with:   Microsoft Intune Remediation Scripts
#>

#==============================================================================
# CONFIGURATION SECTION - MODIFY EMAIL ADDRESSES HERE
#==============================================================================
# Specify the path where the Safe Senders text file will be stored
$safeSendersFilePath = "C:\Temp\SafeSenders.txt"

# List of email addresses to add to the Safe Senders list
$emailAddresses = @(
    "noreply@axioshq.com",
    "help@axioshq.com"
    # Add more addresses as needed:
    # "example@domain.com",
    # "another@example.com"
)
#==============================================================================
# END OF CONFIGURATION SECTION - DO NOT MODIFY BELOW THIS LINE
#==============================================================================

try {
    # Create the C:\Temp directory if it doesn't exist
    if (-not (Test-Path -Path "C:\Temp")) {
        New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null
    }
    
    # Create or overwrite the Safe Senders text file with Unicode encoding
    $emailAddresses | Out-File -FilePath $safeSendersFilePath -Encoding Unicode -Force
    
    # Define the registry path for Outlook
    $regPath = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Options\Mail"
    
    # Check if the registry path exists, create it if it doesn't
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    
    # Set the registry values to tell Outlook to use the text file
    New-ItemProperty -Path $regPath -Name "SafeSendersFile" -Value $safeSendersFilePath -PropertyType String -Force
    
    # Set JunkMailImportLists to 1 to ensure the list is imported
    Set-ItemProperty -Path $regPath -Name "JunkMailImportLists" -Value 1 -Type DWord
    
    # Success
    exit 0
}
catch {
    # Fail the script
    exit 1
}
