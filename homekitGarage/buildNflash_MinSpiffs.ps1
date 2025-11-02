# === CONFIGURATION ===

# arduino-cli core install esp32:esp32
# arduino_cli lib install lvgl@8.3.11 
# arduino-cli compile --fqbn esp32:esp32:esp32 MySketch --library-path /path/to/your/libraries
$Board = "esp32:esp32:esp32"
$SketchPath = Get-Location
$LibraryPath = "$SketchPath\libraries"
$BuildCache = "$SketchPath\build-cache"
$Build = "$SketchPath\build"
$OutputDir = "$SketchPath\output"
$DestDir = "$SketchPath\flashed"
$paramFQBN = "esp32:esp32:esp32:UploadSpeed=921600,CPUFreq=240,FlashFreq=80,FlashMode=qio,FlashSize=4M,PartitionScheme=min_spiffs,DebugLevel=none,PSRAM=disabled,LoopCore=1,EventsCore=1,EraseFlash=none,JTAGAdapter=default,ZigbeeMode=default"

# === Ensure arduino-cli is available ===
$ArduinoCLI = Join-Path $SketchPath "arduino-cli.exe"


if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
    Write-Host "Created output directory: $OutputDir"
}

# === Compile the sketch ===
#Write-Host "Compiling sketch in $SketchPath..."
#& $ArduinoCLI compile --fqbn $Board $SketchPath --libraries $LibraryPath --build-path $Build --output-dir $OutputDir --verbose

# === Compile with PSRAM and Huge APP ===
Write-Host "Compiling sketch with PSRAM disabled and Minimal SPIFFS partition..."
& $ArduinoCLI compile `
    --fqbn $paramFQBN `
    --libraries $LibraryPath `
    --build-path $Build `
    --output-dir $OutputDir `
    --verbose



if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation failed."
    exit 1
}

# === Find and copy the .bin file ===
$BinFile = Get-ChildItem "$Build" -Filter *.bin | Select-Object -First 1

if ($BinFile) {
    if (!(Test-Path $DestDir)) {
        New-Item -ItemType Directory -Path $DestDir | Out-Null
    }

    $DestPath = Join-Path $DestDir $BinFile.Name
    Copy-Item $BinFile.FullName -Destination $DestPath -Force
    Write-Host "Copied $($BinFile.Name) to $DestDir"
} else {
    Write-Host "No .bin file found in $OutputDir"
    exit 1
}

Write-Host "Build and copy complete."

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
#Silicon Labs CP210x
$targetVID = "VID_10C4"
$targetPID = "PID_EA60"

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