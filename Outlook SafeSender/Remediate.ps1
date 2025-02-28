<#
.SYNOPSIS
    Configures Safe Senders list for Outlook 2016 and logs the output.
.DESCRIPTION
    This script overwrites the Outlook 2016 Safe Senders list with the specified email addresses.
    Logs are written to the user's TEMP directory for troubleshooting.
.NOTES
    Version:        1.2
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

# Define the log file path in the user's TEMP directory
$logFile = Join-Path -Path $env:TEMP -ChildPath "OutlookSafeSendersLog.txt"

# Function to write to the log file
function Write-Log {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $Message"
    Add-Content -Path $logFile -Value $logMessage
}

try {
    # Start logging
    Write-Log "Starting remediation script for Outlook 2016 Safe Senders."

    # Define the registry path for Outlook 2016
    $regPath = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Options\Mail"

    # Check if the registry path exists, create it if it doesn't
    if (-not (Test-Path $regPath)) {
        Write-Log "Registry path does not exist. Creating it now..."
        New-Item -Path $regPath -Force | Out-Null
        Write-Log "Registry path created: $regPath"
    }

    # Overwrite the Safe Senders list with the specified email addresses
    $safeSendersValue = $safeSenders -join ";"
    New-ItemProperty -Path $regPath -Name "Safe Senders" -Value $safeSendersValue -PropertyType String -Force
    Write-Log "Safe Senders list updated: $safeSendersValue"

    # Set JunkMailImportLists to 1 to ensure the list is imported
    Set-ItemProperty -Path $regPath -Name "JunkMailImportLists" -Value 1 -Type DWord
    Write-Log "JunkMailImportLists set to 1 to ensure Safe Senders list is imported."

    # Success
    Write-Log "Remediation completed successfully."
    exit 0
}
catch {
    # Log the error and fail the script
    Write-Log "Error during remediation: $_"
    exit 1
}
