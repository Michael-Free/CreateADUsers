Describe "Generic Pass Test" {
    It "Should always pass" {
        $true | Should -Be $true
    }
}