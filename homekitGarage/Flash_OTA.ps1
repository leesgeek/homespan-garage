# Set variables
$projectDir = Get-Location
$cliPath = Join-Path $projectDir "arduino-cli.exe"
$sketchFile = Get-ChildItem -Filter *.ino | Select-Object -First 1
$sketchName = [System.IO.Path]::GetFileNameWithoutExtension($sketchFile.Name)
$buildPath = Join-Path $projectDir "build"
$boardFQBN = "esp32:esp32:esp32"  # Change to match your board
$espIp = "192.168.1.250"          # ESP32 IP address
$otaPort = 3232                   # Default OTA port
$auth = "snowpole"            # OTA password

# Locate espota.py
$arduinoCorePath = "$env:USERPROFILE\AppData\Local\Arduino15\packages\esp32\hardware\esp32"
$espVersion = Get-ChildItem $arduinoCorePath | Sort-Object Name -Descending | Select-Object -First 1
$espotaPath = Join-Path $espVersion.FullName "tools\espota.py"

if (-Not (Test-Path $cliPath)) {
    Write-Error "arduino-cli.exe not found in current directory."
    exit 1
}

if (-Not (Test-Path $espotaPath)) {
    Write-Error "espota.py not found. Ensure ESP32 core is installed."
    exit 1
}

# Find firmware binary
$firmwareBin = Get-ChildItem -Path $buildPath -Recurse -Filter "*.bin" | Select-Object -First 1
if (-Not $firmwareBin) {
    Write-Error "Firmware binary not found."
    exit 1
}

# Upload via espota.py
Write-Host "Uploading OTA to $espIp..."
& python $espotaPath --ip $espIp --port $otaPort --auth $auth --file $firmwareBin.FullName

if ($LASTEXITCODE -eq 0) {
    Write-Host "OTA upload successful!"
} else {
    Write-Error "OTA upload failed."
}
