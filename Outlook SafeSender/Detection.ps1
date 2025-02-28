<#
.SYNOPSIS
    Always triggers remediation for Outlook 2016 Safe Senders list.
.DESCRIPTION
    This script always returns exit code 1 to ensure the remediation script runs,
    guaranteeing that the Safe Senders list is always up to date.
.NOTES
    Version:        1.0
    For use with:   Microsoft Intune Remediation Scripts
#>

# Always trigger remediation
Write-Output "Triggering remediation to ensure Safe Senders list is up to date."
exit 1
