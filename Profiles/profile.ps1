#### This profile is designed to support multiple OS and powershell versions since I use a mix of Linux, Windows, Windows Powershell (v5) and PowerShell (v7) ####

#### Global Variables ####
$env:POWERSHELL_UPDATECHECK = 'Off'
$vers = ( -join ("v" + ($Host.Version.Major).ToString()))
IF ($vers -eq "v5") {
	$IsWindows = $True
}

#### System specific variables ####
IF ($IsWindows) {
	$rootPath = 'C:\'
}
else {
	$rootPath = '\'
	$env:COMPUTERNAME = $env:HOSTNAME
		function Get-Path {
		($env:PATH).Split(':')
	}
}
$prettyName = $env:COMPUTERNAME.ToUpper()

#### Aliases ####
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name sel -Value Select-Object
Set-Alias -Name clip -Value Set-Clipboard


#### Start Logging ####
$linuxLogPath = '/mnt/networkhome'
$windowsLogPath = 'U:'
$filedate = get-date -format MM_dd_yyyy
IF ($IsWindows) {
	Start-Transcript $windowsLogPath\PowershellLogs\$prettyName\$filedate.log -Append
}
else {
	Start-Transcript $linuxLogPath/PowershellLogs/$prettyName/$filedate.log -Append
}

#### Functions ####
function CustomizeConsole {
	$hostversion = "$($Host.Version.Major)`.$($Host.Version.Minor)`.$($Host.Version.Build)"
	$title = "PowerShell $hostversion"
	$Host.UI.RawUI.WindowTitle = $title
	Clear-Host
}
    
function Prompt {
	$prompt = -join ("[" + (Get-Date -format HH:mm:ss) + "][" + ($env:USERNAME) + "@$prettyName" + "] " + ($PWD) + "> ")
	return $prompt;
}

function unzip ($file) {
	$dirname = (Get-Item $file).BaseName
	Write-Host "Extracting $file to $dirname"
	New-Item -Force -ItemType Directory -Path $dirname | Out-Null
	Expand-Archive $file -DestinationPath $dirname
}

IF ($vers -eq "v5") {
	function uptime {
  		(get-Date) - (Get-CimInstance -ClassName win32_operatingsystem | Select-Object  -exp lastbootuptime) | Select-Object Days, Hours, Minutes, Seconds
	}
}
else {
	function uptime {
		Get-Uptime | Select-Object Days, Hours, Minutes, Seconds
	}
}

function hist {
	Get-Content (Get-PSReadlineOption).HistorySavePath | more
}

function Get-PublicIP {
	(Invoke-WebRequest http://ifconfig.me/ip ).Content
}

function sela {
	[cmdletbinding()]
	param(
		[parameter(
			Mandatory = $true,
			ValueFromPipeline = $true)]
		$pipelineInput
	)
	process {
	$pipelineInput | Select-Object *
	}
}

#### Windows Specific Functions ####
IF ($IsWindows) {
	#Import-Module PSPKI -ErrorAction SilentlyContinue
	function Get-Path {
		($env:Path).Split(';')
	}
	function touch($file) {
		"" | Out-File $file -Encoding ASCII
	}
	function df {
		Get-Volume
	}

	function npp ($file) {
		Start-Process 'C:\Program Files\Notepad++\notepad++.exe' -ArgumentList "$file"
	}
	function which($name) {
		Get-Command $name | Select-Object -ExpandProperty Definition
	}
	function cat($filename) {
		Get-Content -Raw $filename
	}
	function Get-PasswordLastSet ($user) {
		[datetime]::FromFileTime((Get-Aduser $user -Properties * | Select -exp pwdLastSet))
	}
	function Get-RandomPassword {
		$pw = -join ((65..90) + (97..122) + (48..57) + (33,35,36,37,38,42) | Get-Random -Count 24 | ForEach-Object {[char]$_}) 
		$pw | Set-Clipboard
		return $pw
	}
}

CustomizeConsole
Set-Location $HOME
