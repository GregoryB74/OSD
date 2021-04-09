function Select-FFUDataStore {
    [CmdletBinding()]
    param (
        [int]$NotDiskNumber,
        [switch]$Skip,
        [switch]$SelectOne
    )
    #=======================================================================
    #	Get USB Disk and add the MinimumSizeGB filter
    #=======================================================================
    $Results = Get-FFUDataStore | Sort-Object -Property DriveLetter
    #=======================================================================
    #	Filter NotDiskNumber
    #=======================================================================
    if ($PSBoundParameters.ContainsKey('NotDiskNumber')) {
        $Results = $Results | Where-Object {$_.DiskNumber -ne $NotDiskNumber}
    }
    #=======================================================================
    #	Process Results
    #=======================================================================
    if ($Results) {
        #=======================================================================
        #	There was only 1 Item, then we will select it automatically
        #=======================================================================
        if ($PSBoundParameters.ContainsKey('SelectOne')) {
            Write-Verbose "Automatically select "
            if (($Results | Measure-Object).Count -eq 1) {
                $SelectedItem = $Results
                Return $SelectedItem
            }
        }
        #=======================================================================
        #	Table of Items
        #=======================================================================
        $Results | Select-Object -Property DriveLetter, FileSystemLabel,`
        @{Name='FreeGB';Expression={[int]($_.SizeRemaining / 1000000000)}},`
        @{Name='TotalGB';Expression={[int]($_.Size / 1000000000)}},`
        FileSystem, DriveType, DiskNumber | Format-Table | Out-Host
        #=======================================================================
        #	Select an Item
        #=======================================================================
        if ($PSBoundParameters.ContainsKey('Skip')) {
            do {$Selection = Read-Host -Prompt "Select an FFUDataStore by DriveLetter, or press S to SKIP"}
            until (($Selection -ge 0) -and ($Selection -in $Results.DriveLetter) -or ($Selection -eq 'S'))
            
            if ($Selection -eq 'S') {Return $false}
        }
        else {
            do {$Selection = Read-Host -Prompt "Select an FFUDataStore by DriveLetter"}
            until (($Selection -ge 0) -and ($Selection -in $Results.DriveLetter))
        }
        #=======================================================================
        #	Return Selection
        #=======================================================================
        Return ($Results | Where-Object {$_.DriveLetter -eq $Selection})
        #=======================================================================
    }
}