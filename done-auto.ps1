## Setup script by Doakyz
## Done Set created by Quack Walks
## https://archive.org/details/done-set

## Changelog
## V2 - Complete rework of code, additional user input settings based on feedback from Quack Walks
## V1 - Initial proof of concept, extracts zips into target directory, only works in powershell ISE
##

# Initialize GUI resources
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName presentationframework
Add-type -AssemblyName microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()
Add-Type -AssemblyName System.Drawing

# Required for use with web SSL sites
[Net.ServicePointManager]::
SecurityProtocol = [Net.ServicePointManager]::
                   SecurityProtocol -bor 
                   [Net.SecurityProtocolType]::
                   Tls12

# Load necessary modules
Import-Module Microsoft.PowerShell.Management
Import-Module Microsoft.PowerShell.Utility

# Function to display GUI folder selection dialog
function Show-FolderDialog {
    param(
        [string]$initialDirectory
    )
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Select a directory"
    $folderDialog.RootFolder = "MyComputer"
    if (-not [string]::IsNullOrWhiteSpace($initialDirectory)) {
        $folderDialog.SelectedPath = $initialDirectory
    }
    $result = $folderDialog.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderDialog.SelectedPath
    } else {
        return $null
    }
}

# Function to prompt for yes or no answers
function Prompt-YesNoQuestion {
    while ($true) {
        Write-Host "Y or N ?"
        $choice = Read-Host

        if ($choice -eq 'y') {
            return $true
        } elseif ($choice -eq 'n') {
            return $false
        } else {
            Write-Host "Invalid choice. Please enter 'y' or 'n'."
        }
    }
}

# Function to prompt for additional zip files based on the storage capacity
function Prompt-AdditionalZipFiles {
    $additionalZipFiles = @()
    
    # Configs, Icon layout and Theme
    Write-Host "Do you want preconfiged menus and optimizations and theme? (recommended)"
    if (Prompt-YesNoQuestion) {
        $configsZipFile = "Configs, Icon layout and Theme.zip"
        if ($configsZipFile -ne $null) {
            $additionalZipFiles += $configsZipFile
        }
    }

    # Manuals
    Write-Host "Do you want game manuals?"
    if (Prompt-YesNoQuestion) {
        $manualsZipFile = "Manuals.zip"
        if ($manualsZipFile -ne $null) {
            $additionalZipFiles += $manualsZipFile
        }
    }

    # Cheats
    Write-Host "Do want cheats?"
    if (Prompt-YesNoQuestion) {
        $cheatsZipFile = "The Cheats.zip"
        if ($cheatsZipFile -ne $null) {
            $additionalZipFiles += $cheatsZipFile
        }
    }

    # Thumbnails
    Write-Host "Select your thumbnail option"
    Write-Host "1. 2D Box Art"
    Write-Host "2. 3 Image Mix"
    Write-Host "3. Miyoo Mix (Default)"
    Write-Host "4. None"
    $pictureChoice = Read-Host
    switch ($pictureChoice) {
        1 { $additionalZipFiles += "Thumbs 2D Box Art.zip" }
        2 { $additionalZipFiles += "Thumbs 3 Image Mix.zip" }
        3 { $additionalZipFiles += "Thumbs Miyoo Mix (Default).zip" }
        4 { }
        default { Write-Host "Invalid choice." }
    }
    return $additionalZipFiles
}

# Zip files for 32GB storage
$additionalZipFilesFor32GB = @(
    "Games + BIOS 32 GB (Base Set).zip"
)

# Zip files for 64GB storage
$additionalZipFilesFor64GB = @(
    "Games + BIOS 32 GB (Base Set).zip",
    "Games 64 GB Expansion.zip"
)

# Zip files for 128GB storage
$additionalZipFilesFor128GB = @(
    "Games + BIOS 32 GB (Base Set).zip",
    "Games 64 GB Expansion.zip",
    "Games 128 GB Expansion.zip"
)

# Get the extraction location using the GUI folder selection dialog
Write-Host "Select the extraction path."
$extractionPath = Show-FolderDialog -initialDirectory ([System.Environment]::GetFolderPath('Desktop'))

# Check if the extraction path exists, if not, create it
if (-not (Test-Path -Path $extractionPath)) {
    New-Item -ItemType Directory -Path $extractionPath | Out-Null
}

# Prompt the user to select the desired storage capacity
$selectedStorage = $null
while ($selectedStorage -notin "32GB", "64GB", "128GB") {
    Write-Host "Select your SD card size:"
    Write-Host "`n"
    Write-Host "1. 32GB"
    Write-Host "2. 64GB"
    Write-Host "3. 128GB"
    Write-Host "`n"
    $choice = Read-Host -Prompt "Enter 1, 2, or 3"
    
    switch ($choice) {
        1 { $selectedStorage = "32GB"
            # If 32GB, add additional zip files
            $additionalZipFiles = $additionalZipFilesFor32GB + (Prompt-AdditionalZipFiles)     
        }
        2 { $selectedStorage = "64GB"
            # If 64GB, add additional zip files
            $additionalZipFiles = $additionalZipFilesFor64GB + (Prompt-AdditionalZipFiles)
        }
        3 { $selectedStorage = "128GB" 
            # If 128GB, add additional zip files
            $additionalZipFiles = $additionalZipFilesFor128GB + (Prompt-AdditionalZipFiles)    
        }

        default { Write-Host "Invalid choice. Please select a valid option." }
    }
}

# If 32GB, add additional zip files
if ($selectedStorage -eq "32GB") {
    $zipFilePaths += $additionalZipFiles
}

# If 64GBGB, add additional zip files
if ($selectedStorage -eq "64GB") {
    $zipFilePaths += $additionalZipFiles
}

# If 128GB, add additional zip files
if ($selectedStorage -eq "128GB") {
    $zipFilePaths += $additionalZipFiles
}

# Prompt the user for confirmation to start the extraction
Write-Host "`n"
Write-Host "Please review your selections before proceeding with the extraction."
Write-Host "`n"
Write-Host "Selected storage capacity: $selectedStorage"

Write-Host "Zip files to be extracted:"
foreach ($zipFilePath in $zipFilePaths) {
    Write-Host "- $zipFilePath"
}

Write-Host "`n"
Write-Host "Extraction path: $extractionPath"
Write-Host ""

$confirmationPrompt = "Do you want to proceed with the extraction? (yes/no)"
$proceedWithExtraction = $null

while ($proceedWithExtraction -notin "yes", "no") {
    $choice = Read-Host -Prompt $confirmationPrompt

    if ($choice -eq "yes") {
        $proceedWithExtraction = $true
        break  # Exit the loop to start extraction
    } elseif ($choice -eq "no") {
        Write-Host "Extraction aborted by user."
        exit
    } else {
        Write-Host "Invalid choice. Please enter 'yes' or 'no'."
    }
}

# Perform the extraction with the -Force parameter to overwrite existing files
if ($proceedWithExtraction) {
    foreach ($zipFilePath in $zipFilePaths) {
        if (Test-Path $zipFilePath) {
            Expand-Archive -Path $zipFilePath -DestinationPath $extractionPath -Force
            Write-Host "Extracted $zipFilePath to $extractionPath"
        } else {
            Write-Host "File not found: $zipFilePath"
        }
    }

    Write-Host "Extraction completed. Files extracted to: $extractionPath"
} else {
    Write-Host "Extraction aborted by user."
}
