function Set-SetupCompleteCreateFinish {

    $ScriptsPath = "C:\Windows\Setup\scripts"
    $RunScript = @(@{ Script = "SetupComplete"; BatFile = 'SetupComplete.cmd'; ps1file = 'SetupComplete.ps1';Type = 'Setup'; Path = "$ScriptsPath"})
    $PSFilePath = "$($RunScript.Path)\$($RunScript.ps1File)"

    if (Test-Path -Path $PSFilePath){
        Add-Content -Path $PSFilePath "Stop-Transcript"
        Add-Content -Path $PSFilePath "Restart-Computer -Force"
    }
    else {
    Write-Output "$PSFilePath - Not Found"
    }

}