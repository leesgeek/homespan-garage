# Define the target VID and PID
#$targetVID = "VID_10C4"
#$targetPID = "PID_EA60"

#CH340G
$targetVID = "VID_1A86"
$targetPID = "PID_7523"

#Silicon Labs CP210x
#$targetVID = "VID_10C4"
#$targetPID = "PID_EA60"


# Get all PnP devices with COM ports
$comPorts = Get-PnpDevice | Where-Object { $_.FriendlyName -match "COM[0-9]+" }

# Find the matching device
$matchingPort = $comPorts | Where-Object {
    $_.InstanceId -match $targetVID -and $_.InstanceId -match $targetPID
}

# Extract the COM port name
$comPortName = $null
if ($matchingPort) {
    $comPortName = ($matchingPort.FriendlyName -match "COM\d+") | Out-Null
    $comPortName = $matches[0]
    Write-Host "Found matching COM port: $comPortName"
} else {
    Write-Host "No matching COM port found for VID=$targetVID and PID=$targetPID"
}