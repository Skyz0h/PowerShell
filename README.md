# PowerShell

This repository is a collection of my personal profile.ps1 settings, modules, scripts and functions that I have written over the years. It's important to note that some of this is company specific and may need to be slightly modified to fit other environments.

## Usage

### Automated setup

Make sure you have your Github PAT set up as an environment variable and then run the following in your $HOME\Projects directory:
```powershell
$headers = @{    
    Authorization = "token $env:github_token"
    'User-Agent'  = "PowerShell"
}
$repoUrl = "https://api.github.com/repos/Skyz0h/PowerShell/contents/Scripts/setup.ps1"
iex ([System.Text.Encoding]::ASCII.GetString([Convert]::FromBase64String((Invoke-RestMethod -Uri $repoUrl -Headers $headers).Content)))

```

### Manual setup

#### Profile:
   
   Determine the profile you want to set up. Profile locations can be determined by running:
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

New-Item -ItemType SymbolicLink -Path $PROFILE.CurrentUsersAllHosts -Value C:\users\User\projects\PowerShell\Profiles\profile.ps1 -Force

```
#### Modules

Placeholder content

#### Scripts

Placeholder content


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
