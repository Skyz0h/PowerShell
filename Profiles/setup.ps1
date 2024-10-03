# This will set up the profile for the respective version of Powershell you're using
$vers = (-join("v" + ($Host.Version.Major).ToString()))
IF($vers -eq "v5"){
	$IsWindows = $True
}

IF($IsWindows){
    $slash = '\'
}else{
    $slash = '/'
}
$localRepoPath = -join($HOME + $slash + "projects$slash" + "PowerShell") # $localRepoPath is the filepath where you cloned this repo. 
$profileSelection = $PROFILE.CurrentUserAllHosts # Change this accordingly. I typically use CurrentUserAllHosts
$profileFromRepo = (-join($localRepoPath + $slash + "Profiles$slash" + "profile.ps1"))

IF(!(Test-Path $profileSelection)){
    New-Item -ItemType SymbolicLink -Name $profileSelection -Value $profileFromRepo -Force
}else{
    Write-Host -ForegroundColor Yellow "$profileSelection already exists. Creating Backup..."
    Rename-Item -path $profileSelection -NewName (-join($profileSelection + ".bak"))
    Write-Host -ForegroundColor Green "Creating symlink $profileSelection ..."
    New-Item -ItemType SymbolicLink -Path $profileSelection -Value $profileFromRepo -Force
}
