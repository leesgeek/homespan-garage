# === CONFIGURATION ===

# arduino-cli core install esp32:esp32
# arduino_cli lib install lvgl@8.3.11 
# arduino-cli compile --fqbn esp32:esp32:esp32 MySketch --library-path /path/to/your/libraries
$Board = "esp32:esp32:esp32cam"
$SketchPath = Get-Location
$LibraryPath = "$SketchPath\libraries"
$BuildCache = "$SketchPath\build-cache"
$Build = "$SketchPath\build"
$OutputDir = "$SketchPath\output"
$DestDir = "$SketchPath\flashed"

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
Write-Host "Compiling sketch with PSRAM enabled and Huge APP partition..."
& $ArduinoCLI compile `
    --fqbn $Board `
    --build-property build.partitions=huge_app `
    --build-property build.flash_mode=qio `
    --build-property build.flash_freq=80m `
    --build-property build.flash_size=4MB `
    --build-property compiler.cpp.extra_flags="-DBOARD_HAS_PSRAM -mfix-esp32-psram-cache-issue -mfix-esp32-psram-cache-strategy=memw" `
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