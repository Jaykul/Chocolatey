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

Describe Enable-ChocolateySource {
    Context 'Default' {
        BeforeAll {
            Mock Get-Command -MockWith { Get-Command Write-Output } -ParameterFilter {$Name -eq 'choco.exe'}
            Mock Get-ChocolateySource -MockWith {
                'MyChocoSource'
            }
            Mock Get-ChocolateyDefaultArgument -MockWith { 'TestArgument' }
        }

        It 'Should call Get-Command' {
            $null = Enable-ChocolateySource -Name 'TestSource'
            {Assert-MockCalled Get-Command} | Should -Not -Throw
        }

        It 'Should call Get-ChocolateySource' {
            $null = Enable-ChocolateySource -Name 'TestSource'
            {Assert-MockCalled Get-ChocolateySource} | Should -Not -Throw
        }

        It 'Should not return value' {
            $return = Enable-ChocolateySource -Name 'TestSource'
            $return | Should -BeNullOrEmpty
        }
    }
}
