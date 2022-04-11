
# The API key to be used when requesting current details from your Tautulli installation
$APIKey = "cfc2c681723f437f8bfd67468e22e3a7"
# The folder Tautulli is running from
$TautulliDir = "D:\Tautulli-Monitor\Tautulli"
# The address Tautulli is listening on (default is http://localhost:8181)
$TautulliURL = "http://localhost:8181"
# The temp directory where the install will be run from.
$UpdaterPath = "D:\Tautulli-Updates\"
# The filename of the Ombi download
$Filename = "Tautulli-windows-v$TautulliUpdate-x64.exe"


function Get-CurrentDetails {
    param($URL,$HeaderValues)
    try {
        $init = (Invoke-WebRequest "$TautulliURL/api/v2?apikey=$APIKey&cmd=get_tautulli_info&tautulli_version" | ConvertFrom-Json)
        $data = $init.response[0].data
        $vers = $data.tautulli_version
        $result = $vers -replace "v",""
        return $result
    } 
    catch {
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        return $result
    }
    return $result
}

#Get-NewVersion function setup
function Get-NewVersion {
    $tag = (Invoke-WebRequest "https://api.github.com/repos/Tautulli/Tautulli/releases" | ConvertFrom-Json)[0].tag_name
    $tag = $tag -replace '[v]'
    return $tag
}

#Generated Variables (UpdateNeeded, TautulliCurrent.array, TautulliUpdate.array, TodayDate, DLFile, DLSource, BackupFile)
[bool]$UpdateNeeded = $false
$TautulliCurrent = Get-CurrentDetails
$TautulliUpdate = Get-NewVersion
$download = "https://github.com/Tautulli/Tautulli/releases/download/v$TautulliUpdate/$Filename"
$dir = "$UpdaterPath$Filename"

Remove-Item "C:\temp\Script\Logs\tautulli-update.txt" -Force -ErrorAction SilentlyContinue
#Compare current version to latest version, define $UpdateNeeded
Start-Transcript -Path "C:\temp\Scripts\Logs\tautulli-update.txt"
if ($TautulliCurrent -ne $TautulliUpdate) {
    $UpdateNeeded = $true
}

if ($UpdateNeeded -or $Force -and -not $UpdateError){
    #Update is needed, continue
    #Notify of version change and update
    Write-Host ("There is an update pending. Current: " + $TautulliCurrent + ", Latest: " +$TautulliUpdate)
    New-Item -Path $UpdaterPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

    $arg = Get-Process -Name "Tautulli"

    if ($null -eq ($arg)) {
        Write-Host "Tautulli is already stopped."
    }
    else{
        Write-Host Stopping Tautulli 
        Stop-Process -Name "Tautulli" 
    }

    Write-Host Dowloading latest release
    Set-Location -Path $UpdaterPath
    Invoke-WebRequest $download -Out $dir

    Write-Host Installing updated version
    Start-Process -FilePath $dir -ArgumentList "/S"

    Start-Sleep 30
    Write-Host "Tautulli has been updated to v$TautulliUpdate"

    Write-Host Cleaning up
    Remove-Item $dir -Force

    if ($arg = $true) {
        Write-Host "Tautulli already running"
    }
    else{
        Write-Host Starting Tautulli 
        Start-Process -FilePath "$TautulliDir\Tautulli.exe"
    }
}
else{
    Write-Host ("Tautulli-v$TautulliCurrent is the latest version. No update needed.")
}
Stop-Transcript
