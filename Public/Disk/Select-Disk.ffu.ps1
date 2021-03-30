function Select-Disk.ffu {
    [CmdletBinding()]
    param (
        [switch]$Skip,
        [switch]$SelectOne
    )
    #=======================================================================
    #	Get USB Disk and add the MinimumSizeGB filter
    #=======================================================================
    $AllItems = Get-Disk.fixed | Sort-Object -Property DiskNumber
    $InUseDrives = $AllItems | Where-Object {$_.IsBoot -eq $true}
    foreach ($Item in $InUseDrives) {
        Write-Warning "$($Item.FriendlyName) cannot be backed up because it is in use"
    }
    $AllItems = $AllItems | Where-Object {$_.IsBoot -eq $false}
    #=======================================================================
    #	Let's bounce if there are no results
    #=======================================================================
    if (-NOT ($AllItems)) {Return $false}
    #=======================================================================
    #	There was only 1 Item, then we will select it automatically
    #=======================================================================
    if ($PSBoundParameters.ContainsKey('SelectOne')) {
        Write-Verbose "Automatically select "
        if (($AllItems | Measure-Object).Count -eq 1) {
            $SelectedItem = $AllItems
            Return $SelectedItem
        }
    }
    #=======================================================================
    #	Table of Items
    #=======================================================================
    $AllItems | Select-Object -Property DiskNumber, BusType,`
    @{Name='SizeGB';Expression={[int]($_.Size / 1000000000)}},`
    FriendlyName,Model, PartitionStyle,`
    @{Name='Partitions';Expression={$_.NumberOfPartitions}} | `
    Format-Table | Out-Host
    #=======================================================================
    #	Select an Item
    #=======================================================================
    if ($PSBoundParameters.ContainsKey('Skip')) {
        do {$Selection = Read-Host -Prompt "Select a Fixed Disk to Backup by DiskNumber, or press S to SKIP"}
        until (($Selection -ge 0) -and ($Selection -in $AllItems.DiskNumber) -or ($Selection -eq 'S'))
        
        if ($Selection -eq 'S') {Return $false}
    }
    else {
        do {$Selection = Read-Host -Prompt "Select a Fixed Disk to Backup by DiskNumber"}
        until (($Selection -ge 0) -and ($Selection -in $AllItems.DiskNumber))
    }
    #=======================================================================
    #	Return Selection
    #=======================================================================
    Return ($AllItems | Where-Object {$_.DiskNumber -eq $Selection})
    #=======================================================================
}