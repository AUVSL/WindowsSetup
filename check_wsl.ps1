[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')


winget install "JetBrains Toolbox"
winget  install 9WZDNCRDK3WP #Slack
winget install Anaconda3
winget install "Microsoft Visual Studio Code"
winget install Git.Git


function Show-ProgressBar {
    param (
        [int]$Duration
    )

    $progress = 0
    $InputDuration = $Duration

    Write-Progress -Activity "Waiting..." -Status "Time remaining: $Duration seconds" -PercentComplete $progress

    while ($Duration -gt 0) {
        Start-Sleep -Seconds 1
        $Duration -= 1
        $progress = (1 - ($Duration / $InputDuration)) * 100
        Write-Progress -Activity "Waiting..." -Status "Time remaining: $Duration seconds" -PercentComplete $progress
    }
}

function WSL-Setup{
    param (
        [string]$distro
    )

    wsl --unregister $distro

    $username = "auvsl"
    $password = "auvsl"

    Write-Host "WSL installation process started for Distro $distro. DO NOT TOUCH ANYTHING"
    
    Write-Host "Setting username and password for $distro to User: $username and Password: $password"
    

    # Start the WSL installation process in a separate PowerShell process
    Start-Process -FilePath "wsl" -ArgumentList "--install -d $distro" -NoNewWindow
    
    # Wait for the installation process to start and display the username prompt
    Write-Host "Waiting for the installation process to start..."
    
    Show-ProgressBar -Duration 180

    
    # Simulate manual input for username and password
    # Replace "Username" and "Password" with your actual username and password
    # Adjust sleep timings as needed based on your system's responsiveness
    
    [System.Windows.Forms.SendKeys]::SendWait("$username{ENTER}")
    Show-ProgressBar -Duration 5
    [System.Windows.Forms.SendKeys]::SendWait("$password{ENTER}")
    Show-ProgressBar -Duration 5
    [System.Windows.Forms.SendKeys]::SendWait("$password{ENTER}")
    Show-ProgressBar -Duration 5
    
    # Send "exit" command to terminate the process
    [System.Windows.Forms.SendKeys]::SendWait("exit{ENTER}")

    Show-ProgressBar -Duration 5
    
    Write-Host "WSL installation process completed."    
}

function Check-WSLDistributions {
    param (
        [string[]]$DistributionNames
    )

    # Check if all specified WSL 2 distributions are installed
    $wslOutput = wsl.exe -l -q

    foreach ($distro in $DistributionNames) {
        if ($wslOutput -split '\r?\n' -contains $distro) {
            Write-Host "$distro is installed."
            return $false
        }
    }

    # If none of the specified distributions are installed, install the first one
    if ($DistributionNames.Count -gt 0) {
        Write-Host "None of the specified distributions are installed. Installing $($DistributionNames[0]) now..."
        # wsl.exe --install -d $DistributionNames[0]

        # wsl.exe --install -d $DistributionNames[0] --no-launch

        WSL-Setup -distro $DistributionNames[0]


        return $true
    }

    return $false
}



# wsl --install
wsl --update

$distros = @("Ubuntu-18.04")
$isInstalled1 = Check-WSLDistributions -DistributionNames $distros

# Example usage:
# $distros = @("Ubuntu-22.04", "Ubuntu")
$distros = @("Ubuntu-22.04")
$isInstalled2 = Check-WSLDistributions -DistributionNames $distros

if($isInstalled1 -or $isInstalled2){
    Restart-Computer -Confirm
}
else{

# Define the URL of the Git repository to clone
$gitRepoUrl = "https://github.com/AUVSL/WindowsSetup.git"

# Get the path to the user's desktop folder
$destinationDirectory = [Environment]::GetFolderPath("Desktop")

# Print out the destination directory for debugging
Write-Host "Destination directory: $destinationDirectory"

# Check if the destination directory exists, if not, create it
if (!(Test-Path -Path $destinationDirectory)) {
    Write-Host "Destination directory does not exist. Creating it..."
    # New-Item -ItemType Directory -Path $destinationDirectory | Out-Null
}

# Change directory to the destination directory
Set-Location -Path $destinationDirectory

# Print out the current directory for debugging
Write-Host "Current directory: $(Get-Location)"

# Clone the Git repository
Write-Host "Cloning repository from $gitRepoUrl..."
git clone $gitRepoUrl

# Print out success message
Write-Host "Repository cloned successfully!"

# Get the name of the cloned repository
$clonedRepoName = $gitRepoUrl.Split("/")[-1].Replace(".git", "")

# Change directory into the cloned repository
Set-Location -Path (Join-Path -Path $destinationDirectory -ChildPath $clonedRepoName)

# Print out the current directory after changing
Write-Host "Current directory after cloning: $(Get-Location)"

Write-Host "Running script.sh using WSL..."

$distros = @("Ubuntu-18.04" , "Ubuntu-22.04")
# $distros = @("Ubuntu-22.04")



foreach ($distro in $distros) {
    wsl -d $distro bash -c "sudo apt-get update; sudo apt-get upgrade; sudo apt-get install dos2unix; chmod +x setup_$distro.sh; dos2unix setup_$distro.sh; ./setup_$distro.sh; exit"
}
}
