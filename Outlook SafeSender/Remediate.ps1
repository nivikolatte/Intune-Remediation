<#
.SYNOPSIS
    Creates a Safe Senders text file in C:\Temp for Outlook.

.DESCRIPTION
    This script creates a text file with Safe Sender email addresses in C:\Temp using Unicode encoding.
    The file can be used with Intune/Endpoint Manager to configure Outlook's Safe Senders list.

    Instructions for configuring this via Intune:
    1. Go to Intune/Endpoint Manager > Devices > Windows > Configuration profiles > New profile.
    2. Platform: Windows 10 and later | Profile type: Settings catalog.
    3. Navigate to: Microsoft Outlook 2016 > Outlook options > Preferences > Junk e-mail.
    4. Configure the following settings:
        - **Specify path to safe sender’s list (user)**: Set this to `C:\Temp\SafeSenders.txt`.
        - **Trigger to apply junk email settings list (user)**: This will append the existing Safe Senders list, not replace it.
        - To replace the list, enable the setting: **Overwrite or append junk mail import (users)**.
          Having this enabled will overwrite any existing list.
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
    
    # Success
    exit 0
}
catch {
    # Fail the script
    exit 1
}
