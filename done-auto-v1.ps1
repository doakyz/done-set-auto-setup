## Setup script by Doakyz
## Done Set created by Quack Walks
## https://archive.org/details/done-set

# Define the zip files for extraction in the submenu
$zipFilesSubMenu = @{
    "1" = "Thumbs 2D Box Art.zip"
    "2" = "Thumbs 3 Image Mix.zip"
    "3" = "Thumbs Miyoo Mix (Default).zip"
}

function Show-Menu {
    Clear-Host
    Write-Host "Automatically setup Done Set on your SD card."
    Write-Host "When prompted, select the root folder of your SD card,"
    Write-Host "This tool will extract everything into their correct locations."
    Write-Host "`n"
    Write-Host "Select SD Card size:"
    Write-Host "1. 32GB SD card"
    Write-Host "2. 64GB SD card"
    Write-Host "3. 128GB SD card"
    Write-Host "`n"
    Write-Host "Extras:"
    Write-Host "4. Setup Box Art"
    Write-Host "`n"
    Write-Host "Q. Quit"
    Write-Host "`n"
}

function Show-BoxArtMenu {
    Clear-Host
    Write-Host "Select the type of thumbnails you want:"
    Write-Host "`n"
    Write-Host "Only one option can be used."
    Write-Host "1. 2D Box Art"
    Write-Host "2. 3 Image Mix"
    Write-Host "3. Miyoo Mix (Default)"
    Write-Host "`n"
    Write-Host "R. Return to previous menu"
    Write-Host "`n"
}

#Primary Menu
function Get-UserChoice {
    $validChoices = "1", "2", "3", "4", "Q"
    $userChoice = Read-Host "Enter your choice"

    if ($validChoices -contains $userChoice) {
        return $userChoice
    } else {
        Write-Host "Invalid choice. Please try again."
        return $null
    }
}

#Boxart Menu
function Get-BoxArtChoice {
    $validChoices = "1", "2", "3", "R"
    $userChoice = Read-Host "Enter your choice"

    if ($validChoices -contains $userChoice) {
        return $userChoice
    } else {
        Write-Host "Invalid choice. Please try again."
        return $null
    }
}

#Select folder GUI
function Show-FolderDialog {
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Select a directory to extract the files"
    $folderDialog.RootFolder = "MyComputer"
    $folderDialog.SelectedPath = [System.Environment]::GetFolderPath('Desktop')

    $result = $folderDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderDialog.SelectedPath
    } else {
        return $null
    }
}

function Extract-BoxArt {
    param(
        [string]$zipFileName
    )

    $directory = Show-FolderDialog

    if ($directory) {
        # Check if the zip file exists in the submenu zip files
        if ($zipFilesSubMenu.ContainsValue($zipFileName)) {
            $zipPath = Join-Path -Path $PSScriptRoot -ChildPath $zipFileName
            Expand-Archive -Path $zipPath -DestinationPath $directory -Force
            Write-Host "Extracted $zipFileName to $directory"
        } else {
            Write-Host "Invalid choice. Please try again."
        }
    } else {
        Write-Host "Extraction canceled."
    }
}

# Main script

# Set the initial menu level to the main menu
$menuLevel = 1

while ($choice -ne "Q") {
    if ($menuLevel -eq 1) {
        Show-Menu
        $choice = Get-UserChoice
    } elseif ($menuLevel -eq 2) {
        Show-BoxArtMenu
        $boxArtChoice = Get-BoxArtChoice

        switch ($boxArtChoice) {
            "1" {
                Extract-BoxArt "Thumbs 2D Box Art.zip"
            }
            "2" {
                Extract-BoxArt "Thumbs 3 Image Mix.zip"
            }
            "3" {
                Extract-BoxArt "Thumbs Miyoo Mix (Default).zip"
            }
            "R" {
                $menuLevel = 1  # Return to the main menu
            }
            default {
                Write-Host "Invalid choice. Please try again."
            }
        }

        # Skip the main menu choice handling
        continue
    }

    # Main menu choice handling

    switch ($choice) {
        "1" {
            Write-Host "You chose to extract 32GB."

            # Specify the zip files to extract for 32GB
            $zipFiles32GB = @(
                "Games + BIOS 32 GB (Base Set).zip",
                "Configs, Icon layout and Theme.zip",
                "Manuals.zip",
                "The Cheats.zip"
            )

            $directory = Show-FolderDialog
            if ($directory) {
                # Extract the specified zip files for 32GB into the chosen directory
                foreach ($zipFile32GB in $zipFiles32GB) {
                    $zipPath32GB = Join-Path -Path $PSScriptRoot -ChildPath $zipFile32GB
                    Expand-Archive -Path $zipPath32GB -DestinationPath $directory -Force
                    Write-Host "Extracted $zipFile32GB to $directory"
                }
            } else {
                Write-Host "Extraction canceled."
            }
        }
        "2" {
            Write-Host "You chose 64GB."

            $directory = Show-FolderDialog
            if ($directory) {
                # Specify the zip files to extract for 64GB
                $zipFiles64GB = @(
                    "Games + BIOS 32 GB (Base Set).zip",
                    "Configs, Icon layout and Theme.zip",
                    "Manuals.zip",
                    "The Cheats.zip"
                    "Games 64 GB Expansion.zip"
                )

                # Extract the specified zip files for 64GB into the chosen directory
                foreach ($zipFile64GB in $zipFiles64GB) {
                    $zipPath64GB = Join-Path -Path $PSScriptRoot -ChildPath $zipFile64GB
                    Expand-Archive -Path $zipPath64GB -DestinationPath $directory -Force
                    Write-Host "Extracted $zipFile64GB to $directory"
                }
            } else {
                Write-Host "Extraction canceled."
            }
        }
        "3" {
            Write-Host "You chose 128GB."

            $directory = Show-FolderDialog
            if ($directory) {
                # Specify the zip files to extract for 128GB
                $zipFiles128GB = @(
                    "Games + BIOS 32 GB (Base Set).zip",
                    "Configs, Icon layout and Theme.zip",
                    "Manuals.zip",
                    "The Cheats.zip"
                    "Games 64 GB Expansion.zip"
                    "Games 128 GB Expansion.zip"
                )

                # Extract the specified zip files for 128GB into the chosen directory
                foreach ($zipFile128GB in $zipFiles128GB) {
                    $zipPath128GB = Join-Path -Path $PSScriptRoot -ChildPath $zipFile128GB
                    Expand-Archive -Path $zipPath128GB -DestinationPath $directory -Force
                    Write-Host "Extracted $zipFile128GB to $directory"
                }
            } else {
                Write-Host "Extraction canceled."
            }
        }
        "4" {
            $menuLevel = 2  # Set the menu level to submenu
        }
        "Q" {
            Write-Host "Exiting..."
        }
        "R" {
            Write-Host "Invalid choice. Please try again."
        }
        default {
            Write-Host "Invalid choice. Please try again."
        }
    }

    if ($choice -ne "Q") {
        Write-Host "Press Enter to continue."
        [void][System.Console]::ReadKey($true)
    }
}
