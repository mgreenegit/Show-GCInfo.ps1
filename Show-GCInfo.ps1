param(
    # Output from GC status cmdlet
    [Parameter(Mandatory = $true)]
    [Object[]]
    $ComplianceData,

    [switch]
    $Detailed
)

$VM = $ComplianceData[0].VM.ResourceId.split('/')[8]

# Disclaimer
# Yes I know that Write-Host does not actually return usable output.
# This is for display purposes only.

Write-Host ''
Write-Host "Compliance Details for $VM" -ForegroundColor Yellow
Write-Host ''

foreach ($guestAssignment in $ComplianceData) {

    Write-Host $($guestAssignment.Configuration.Version) -ForegroundColor Blue -NoNewLine
    Write-Host ' ' -NoNewLine

    Write-Host $($guestAssignment.PolicyDisplayName) -ForegroundColor White
    Write-Host "`tCollected on $($guestAssignment.EndTime)" -ForegroundColor Blue
    
    foreach ($Assignment in $guestAssignment) {
        switch ($Assignment.ComplianceStatus) {
            'Compliant' {
                $ForegroundColor = 'Green'
                $VisualKey = "`t+ Compliant "
            }
            'NonCompliant' {
                $ForegroundColor = 'Red'
                $VisualKey = "`t- Not Compliant "
            }
            'Pending' {
                $ForegroundColor = 'Gray'
                $VisualKey = "`t Pending "
            }
        }
        foreach ($Resource in $Assignment) {
            Write-Host $VisualKey -ForegroundColor $ForegroundColor -NoNewLine
            Write-Host $($Resource.ComplianceReasons.ResourceId) -ForegroundColor Blue -NoNewLine
            Write-Host $($Resource.ComplianceReasons.Code) -ForegroundColor Blue
            foreach ($Reason in $Resource.ComplianceReasons.Reasons) {
                if ($true -eq $Detailed) {
                    Write-Host ''
                    Write-Host "$($Reason.Reason)" -ForegroundColor Yellow
                }
            }
        }
    }
    Write-Host ''
}
