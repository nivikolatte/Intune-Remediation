<#
.SYNOPSIS
    Configures Safe Senders list for Outlook 2016.
.DESCRIPTION
    This script overwrites the Outlook 2016 Safe Senders list with the specified email addresses.
    To update the list in the future, simply modify the email addresses in the 
    "CONFIGURATION SECTION" below.
.NOTES
    Version:        1.0
    For use with:   Microsoft Intune Remediation Scripts
#>

#==============================================================================
# CONFIGURATION SECTION - MODIFY EMAIL ADDRESSES HERE
#==============================================================================
# Add or remove email addresses as needed, keeping the same format
$safeSenders = @(
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
    # Define the registry path for Outlook 2016
    $regPath = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Options\Mail"

    # Check if the registry path exists, create it if it doesn't
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
        Write-Output "Created registry path: $regPath"
    }

    # Update the registry with the safe senders list (overwrite existing)
    New-ItemProperty -Path $regPath -Name "Safe Senders" -Value $($safeSenders -join ";") -PropertyType String -Force
    
    # Set JunkMailImportLists to 1 to ensure the list is imported
    Set-ItemProperty -Path $regPath -Name "JunkMailImportLists" -Value 1 -Type DWord

    Write-Output "Successfully updated Safe Senders list for Outlook 2016"
    exit 0 # Success
}
catch {
    Write-Error "Error updating Safe Senders list: $_"
    exit 1 # Failure
}
