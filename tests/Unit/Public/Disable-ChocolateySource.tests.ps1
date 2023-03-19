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

Describe Disable-ChocolateySource {
    Context 'Default' {
        BeforeAll {
            Mock Get-ChocolateySource -MockWith {
                'MyChocoSource'
            }
            Mock Get-ChocolateyDefaultArgument -MockWith { 'TestArgument' }
            Mock Get-Command -MockWith { Get-Command Write-Output } -ParameterFilter {$Name -eq 'choco.exe'}
        }

        It 'Should call Get-Command' {
            $null = Disable-ChocolateySource -Name 'TestSource'
            {Assert-MockCalled Get-Command} | Should -not -Throw
        }
        It 'Should Call Get-ChocolateySource' {
            $null = Disable-ChocolateySource -Name 'TestSource'
            {Assert-MockCalled Get-ChocolateySource} | Should -not -Throw
        }
        It 'Should not return value' {
            $return = Disable-ChocolateySource -Name 'TestSource'
            $return | Should -BeNullOrEmpty
        }
    }
}
