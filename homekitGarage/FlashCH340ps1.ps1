# Set variables
$projectDir = Get-Location
$cliPath = Join-Path $projectDir "arduino-cli.exe"
$sketchFile = Get-ChildItem -Filter *.ino | Select-Object -First 1
$sketchName = [System.IO.Path]::GetFileNameWithoutExtension($sketchFile.Name)
$buildPath = Join-Path $projectDir "build"
$boardFQBN = "esp32:esp32:esp32"  # Change this to match your board
$port = "COM3"  # Change this to match your ESP32's COM port

# Check if arduino-cli exists
if (-Not (Test-Path $cliPath)) {
    Write-Error "arduino-cli.exe not found in current directory."
    exit 1
}

# Define the target VID and PID
#$targetVID = "VID_10C4"
#$targetPID = "PID_EA60"

#CH340
$targetVID = "VID_1A86"
$targetPID = "PID_7523"

# Get all PnP devices with COM ports
$comPorts = Get-PnpDevice | Where-Object { $_.FriendlyName -match "COM[0-9]+" }

# Find the matching device
$matchingPort = $comPorts | Where-Object {
    $_.InstanceId -match $targetVID -and $_.InstanceId -match $targetPID

}


# Extract the COM port name (e.g., COM3)
$comPortName = $null
if ($matchingPort) {
    foreach ($port in $matchingPort) {
        if ($port.FriendlyName -match "COM\d+") {
            $port = $matches[0]
            break
        }
    }
}

# Output result
if ($comPortName) {
    Write-Host "Found COM port: $port"
} else {
    Write-Host "No matching COM port found for VID=$targetVID and PID=$targetPID"
}


# Upload the sketch
Write-Host "Uploading to ESP32 on port $port..."
& $cliPath upload -p $port --fqbn $boardFQBN --input-dir $buildPath

if ($LASTEXITCODE -eq 0) {
    Write-Host "Upload successful!"
} else {
    Write-Error "Upload failed."
}