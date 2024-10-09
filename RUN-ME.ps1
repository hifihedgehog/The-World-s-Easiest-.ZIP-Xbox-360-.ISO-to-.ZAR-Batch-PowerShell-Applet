# Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Function to open the folder browser dialog
function Get-FolderDialog {
    param (
        [string]$description = "Select a folder"
    )
    
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $description
    $folderBrowser.ShowNewFolderButton = $true

    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    }
    else {
        Write-Host "No folder selected. Exiting script."
        exit
    }
}

# Ask user to select the folder containing the .zip files
$zipFolder = Get-FolderDialog -Description "Select the folder containing the .zip files"
# Ask user to select the destination folder for .zar files
$zarDestination = Get-FolderDialog -Description "Select the destination folder for the .zar files"

# Get all .zip files in the specified folder
$zipFiles = Get-ChildItem -Path $zipFolder -Filter "*.zip"
$totalZipFiles = $zipFiles.Count  # Total number of .zip files

# Get all existing .zar files in the destination folder
$zarFiles = Get-ChildItem -Path $zarDestination -Filter "*.zar"
$zarFilesAlreadyPresent = $zarFiles.Count  # Count of .zar files already present in the destination folder

$convertedCount = 0  # Counter for successfully converted .zar files during this run

# Loop through each .zip file
foreach ($zipFile in $zipFiles) {
    $zipFileName = $zipFile.BaseName
    $zarFilePath = Join-Path -Path $zarDestination -ChildPath "$zipFileName.zar"

    # Set temporary folder paths
    $tempZipFolder = ".\temp_zip"
    $isoExtractedFolder = ""
    $compressionSuccessful = $false  # Track whether compression was successful

    # Wrap the extraction and compression steps in try/catch/finally
    try {
        # Check if a .zar file already exists in the destination folder
        if (Test-Path $zarFilePath) {
            Write-Host "Skipping '$($zipFile.Name)': .zar file already exists at '$zarFilePath'"
            continue  # Skip to the next .zip file
        }

        # Create the temporary folder for extracting the .zip file
        Write-Host "Extracting '$($zipFile.Name)'..."
        New-Item -ItemType Directory -Force -Path $tempZipFolder

        # Use 7-Zip to extract the ZIP file (handling paths with spaces and special characters)
        $zipFilePath = "`"$($zipFile.FullName)`""  # Handle spaces in path
        $outputPath = "`"$tempZipFolder`""         # Handle spaces in output path
        $sevenZipExePath = "C:\Program Files\7-Zip\7z.exe"  # Path to 7-Zip

        Write-Host "Running: $sevenZipExePath x $zipFilePath -o$outputPath"
        & $sevenZipExePath x $zipFilePath "-o$outputPath"

        # Find the single .iso file in the temporary zip folder
        $isoFiles = Get-ChildItem -Path $tempZipFolder -Filter "*.iso"

        foreach ($isoFile in $isoFiles) {
            Write-Host "Found ISO file: '$($isoFile.Name)'"

            # Extract the .iso using extract-xiso.exe (handle special characters)
            $isoFilePath = "`"$($isoFile.FullName)`""  # Handle spaces in ISO path
            $extractXisoExePath = ".\extract-xiso.exe" # Path to extract-xiso

            Write-Host "Running: $extractXisoExePath -s $isoFilePath"
            & $extractXisoExePath -s $isoFilePath

            # Compress the extracted contents into a .zar file
            $zarFilePath = Join-Path -Path $zarDestination -ChildPath "$($isoFile.BaseName).zar"
            Write-Host "Compressing extracted contents into '$zarFilePath'..."
            $isoExtractedFolder = $isoFile.BaseName  # No quotes or backticks here, just the plain folder name
            $zarFilePathEscaped = "`"$zarFilePath`""  # Handle spaces in zar path
            $zarchiveExePath = ".\zarchive.exe"       # Path to zarchive

            Write-Host "Running: $zarchiveExePath $isoExtractedFolder $zarFilePathEscaped"
            & $zarchiveExePath $isoExtractedFolder $zarFilePathEscaped

            # If we reach this point, the compression was successful
            $compressionSuccessful = $true

            # Increment the successful conversion count if the .zar file was created
            if (Test-Path $zarFilePath) {
                $convertedCount++
            }
        }
    }
    catch {
        Write-Host "An error occurred: $_"
    }
    finally {
        # Clean up the temporary zip folder
        if (Test-Path $tempZipFolder) {
            Write-Host "Cleaning up temporary folder '$tempZipFolder'..."
            Remove-Item -Recurse -Force $tempZipFolder
        }

        # Clean up the temporary extracted ISO folder
        if ($isoExtractedFolder -and (Test-Path $isoExtractedFolder)) {
            Write-Host "Cleaning up extracted ISO folder '$isoExtractedFolder'..."
            Remove-Item -Recurse -Force $isoExtractedFolder
        }

        # Clean up the incomplete .zar file if compression was not successful
        if (!$compressionSuccessful -and (Test-Path $zarFilePath)) {
            Write-Host "Cleaning up incomplete .zar file '$zarFilePath'..."
            Remove-Item -Force $zarFilePath
        }
    }
}

# Calculate total .zar files (previous + converted) and how many files remain unconverted
$totalConverted = $zarFilesAlreadyPresent + $convertedCount
$remainingCount = $totalZipFiles - $totalConverted

# Report the number of .zar files, including pre-existing ones
Write-Host "$totalConverted out of $totalZipFiles .zip files have been successfully converted (including previously converted files)."
Write-Host "$remainingCount files remain to be converted in the destination folder."
