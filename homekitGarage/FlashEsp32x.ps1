# === CONFIGURATION ===
$SketchPath = Get-Location
$BinFile = Get-ChildItem "$SketchPath\build" -Filter *.bin | Select-Object -First 1
$Python = "C:\Users\jerem\AppData\Local\Arduino15\packages\esp8266\tools\python3\3.7.2-post1/python3"
$Esptool ="C:\Users\jerem\AppData\Local\Arduino15\packages\esp8266\hardware\esp8266\3.1.2/tools/upload.py"

$Port = "COM8"  # Adjust to your actual serial port
$Baud = 115200

# === Check for binary ===
if (-not $BinFile) {
    Write-Host "No .bin file found in build folder."
    exit 1
}

# === Flash the ESP8266 ===
Write-Host "Flashing $($BinFile.Name) to ESP8266 on $Port..."
& $Python -I $Esptool --chip esp8266 --port $Port --baud $Baud --before default_reset --after hard_reset write_flash 0x00000 "$($BinFile.FullName)"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Flash successful."
} else {
    Write-Host "Flash failed."
    exit 1
}

putty.exe -serial $Port -sercfg 115200,8,n,1,N