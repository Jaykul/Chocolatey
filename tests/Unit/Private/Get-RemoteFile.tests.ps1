BeforeAll {
    $script:moduleName = 'Chocolatey'

    # If the module is not found, run the build task 'noop'.
    if (-not (Get-Module -Name $script:moduleName -ListAvailable))
    {
        # Redirect all streams to $null, except the error stream (stream 2)
        & "$PSScriptRoot/../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
    }

    # Re-import the module using force to get any code changes between runs.
    Import-Module -Name $script:moduleName -Force -ErrorAction 'Stop'

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName
}
Describe Get-RemoteFile {

    Context 'Default' {
        BeforeAll {

            Mock Get-Downloader -MockWith {
                $Obj = [PSCustomObject]@{}
                $obj | Add-member -MemberType ScriptMethod -Name DownloadFile -Value {
                    Param ($url,$file)
                    return @{url=$url;file=$file}
                } -PassThru
            }
        }

        It 'Should Return a downloader object' {
            $result = InModuleScope -ScriptBlock { Get-RemoteFile -url 'https://my/url' -File 'C:\test.zip' }
            $result.url | Should -Be 'https://my/url'
            $result.file | Should -Be 'C:\test.zip'
        }
    }
}
