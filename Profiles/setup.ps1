Clear-Host
Write-Host -ForegroundColor Green @"
██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ███████╗██╗  ██╗███████╗██╗     ██╗         ███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝██║     ██║         ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝███████╗███████║█████╗  ██║     ██║         ███████╗█████╗     ██║   ██║   ██║██████╔╝
██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗╚════██║██╔══██║██╔══╝  ██║     ██║         ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║███████║██║  ██║███████╗███████╗███████╗    ███████║███████╗   ██║   ╚██████╔╝██║     
╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
                                                                                                                                 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"@
$vers = ( -join ("v" + ($Host.Version.Major).ToString()))
IF ($vers -eq "v5") {
    $IsWindows = $True
}

IF ($IsWindows) {
    $slash = '\'
}
else {
    $slash = '/'
}
$localRepoPath = -join ($HOME + $slash + "projects$slash" + "PowerShell") # $localRepoPath is the filepath where you cloned this repo. 
$profileSelection = $PROFILE.CurrentUserAllHosts # Change this accordingly. I typically use CurrentUserAllHosts
$profileFromRepo = ( -join ($localRepoPath + $slash + "Profiles$slash" + "profile.ps1"))


$headers = @{    
    Authorization = "token $env:github_token"
    'User-Agent'  = "PowerShell"
}
$repoUrl = "https://api.github.com/repos/Skyz0h/PowerShell/zipball/main"
Invoke-RestMethod -Uri $repoUrl -OutFile 'PowerShell.zip' -Headers $headers
IF (!(Test-Path 'PowerShell')) {
    Expand-Archive 'PowerShell.zip' -DestinationPath 'PowerShell_tmp'
    Remove-Item PowerShell.zip -Force -Confirm:$false
    Get-ChildItem PowerShell_tmp | Move-item -Destination . -Force -Confirm:$false
    Get-ChildItem -Filter "Skyz0h*" | Rename-Item -NewName PowerShell -Force -Confirm:$false
    Remove-Item PowerShell_tmp -Recurse -Force -Confirm:$false
    #Expand this later to check for winget, use it to install git.git, and automate the git init of repo. For now warning message to do it manually
    Write-Host -ForegroundColor Yellow "Repository has been cloned. Please use git to set it up and keep up to date with changes."
    IF (!(Test-Path $profileSelection)) {
        New-Item -ItemType SymbolicLink -Path $profileSelection -Value $profileFromRepo -Force
    }
    else {
        Write-Host -ForegroundColor Yellow "$profileSelection already exists. Creating Backup..."
        Rename-Item -path $profileSelection -NewName ( -join ($profileSelection + ".bak"))
        Write-Host -ForegroundColor Green "Creating symlink $profileSelection ..."
        New-Item -ItemType SymbolicLink -Path $profileSelection -Value $profileFromRepo -Force
    }
}
else {
    Write-Host -ForegroundColor Red "PowerShell already exists at $PWD. Please remove this directory and try again. Exiting..."
}


