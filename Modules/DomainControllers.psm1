function Test-AllDomainControllers {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, mandatory = $false)]
        [switch]
        $Output
    )
    $head = @"
<style>
    body
  {
      background-color: 
  }
    .container {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-evenly;
    overflow: auto;
    width: auto;
	}

    table, th, td{
      border: 1px solid;
      align: center
    }

    h1{
        background-color: #F57835;
        color:white;
        text-align: center;
    }
    .fail {
            background: #F52900;
    }
        
    .pass{
            background: #0EF52D;
    }
    .blank{
            background: #F57835;
    }
    .result-table {
    border-collapse: collapse;
    font-size: 12px;
    
    }
.result-table th, .result-table td {
    text-align: left;
    border: 1px solid #ddd;
    padding: 2px;
}


</style>
"@
    Function Get-AllDomainControllers {
        $allDomainControllers = Get-ADDomainController -Filter *
        return $allDomainControllers.HostName
    }

    $domainControllers = Get-AllDomainControllers

    Function Get-DomainControllerTestResults {
        param (
            [Parameter( Mandatory = $false)]
            [string]$DomainController
        )
        $DCDiagTest = (Dcdiag.exe /s:$DomainController /DnsBasic /skip:SystemLog ) -split ('[\r\n]')
        $DCDiagTestResults = New-Object Object
        $DCDiagTestResults | Add-Member -Type NoteProperty -Name "FQDN" -Value $DomainController
        $DCDiagTest | ForEach-Object {
            Switch -RegEx ($_) {
                "Starting" { $TestName = ($_ -Replace ".*Starting test: ").Trim() }
                "passed test|failed test" {
                    If ($_ -Match "passed test") {
                        $TestStatus = "Passed"
                    }
                    Else {
                        $TestStatus = "Failed"
                    }
                }
            } 
            If ($null -ne $TestName -And $null -ne $TestStatus) {
                $DCDiagTestResults | Add-Member -Name $("$TestName".Trim()) -Value $TestStatus -Type NoteProperty -force
                $TestName = $null; $TestStatus = $null
            }
        }
        return $DCDiagTestResults
    }
    
    [array]$allTestedDomainControllers = @()
    $report = $null
    foreach ($dc in $domainControllers) {
        $results = Get-DomainControllerTestResults -DomainController $dc
        $allTestedDomainControllers += $results

    }
    if ($Output) {
        $LogPath = "$env:USERPROFILE\DomainControllerReport.html"
        $report = $allTestedDomainControllers | ConvertTo-Html -Head $head -as Table
        $finalReport = $report `
            -replace '<td>Passed</td>', '<td class="pass">Passed</td>' `
            -replace '<td>Failed</td>', '<td class="fail">Failed</td>' `
            -replace '<table>', '<div class="container"><table class="result-table">' `
            -replace '<tr><td><hr></td></tr>', '</table><br><br><table class="result-table">' `

        $finalReport | Out-File $LogPath -Force -Confirm:$false
        Invoke-Item $LogPath
    }
    else {
        return $allTestedDomainControllers
    }
}