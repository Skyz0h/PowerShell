# PowerShell

This repository is a collection of my personal profile.ps1 settings, modules, scripts and functions that I have written over the years. It's important to note that some of this is company specific and may need to be slightly modified to fit other environments.

## Usage

Clone this repository to your $HOME directory. From there, symlink the profile.ps1 to it's appropriate locations. 

Profile locations can be determined by running:
```powershell
$PROFILE | Select-Object *  

# Example output from a linux host
AllUsersAllHosts       : /opt/microsoft/powershell/7/profile.ps1
AllUsersCurrentHost    : /opt/microsoft/powershell/7/Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : /home/user/.config/powershell/profile.ps1
CurrentUserCurrentHost : /home/user/.config/powershell/Microsoft.PowerShell_profile.ps1

# Example out from a Windows host
AllUsersAllHosts       : C:\Program Files\PowerShell\7\profile.ps1
AllUsersCurrentHost    : C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\user\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\user\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

Create the symlink to the appropriate profile. For example, to create the symlink to the CurrentUsersAllHosts profile:
```powershell
# This will set up the profile for the respective version of Powershell you're using

$localRepoPath = "C:\users\pkadmin\github\PowerShell" # $localRepoPath is the filepath where you cloned this repo. 
$profileSelection = $PROFILE.CurrentUserAllHosts # Change this accordingly. I typically use CurrentUserAllHosts

IF(!(Test-Path $profileSelection)){
    New-Item -ItemType SymbolicLink -Name $profileSelection -Value $localRepoPath\Profiles\profile.ps1 -Force
}else{
    Write-Host -ForegroundColor Yellow "$profileSelection already exists. Creating Backup..."
    Rename-Item -path $profileSelection -NewName (-join($profileSelection + ".bak"))
    Write-Host -ForegroundColor Green "Creating symlink $profileSelection ..."
    New-Item -ItemType SymbolicLink -Path $profileSelection -Value $localRepoPath\Profiles\profile.ps1 -Force
}

```





## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT License](https://choosealicense.com/licenses/mit/)


Copyright (c) [2024] [github.com/Skyz0h]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
