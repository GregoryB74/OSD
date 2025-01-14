function Start-EjectCD {
    [CmdletBinding()]
    param ()   
    Write-Host -ForegroundColor Cyan "Ejecting ISO from VM"
    (New-Object -ComObject 'Shell.Application').Namespace(17).Items() | Where-Object { $_.Type -eq 'CD Drive' } | ForEach-Object { $_.InvokeVerb('Eject') }
}