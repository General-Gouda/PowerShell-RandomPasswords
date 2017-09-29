# Password generators found out in the web. Slightly tweaked by me.

function Get-RandomPassword
{
    Param
    (
        [int]$PasswordLength=16,
        [switch]$Secure
    )
    
    $ascii = $NULL;For ($a=48;$a -le 122;$a++) {$ascii+=,[char][byte]$a}

    For ($loop=1; $loop -le $PasswordLength; $loop++)
    {
        $randomPassword += ($ascii | Get-Random)
    }

    if ($Secure)
    {
        $randomPassword = ConvertTo-SecureString $randomPassword -AsPlainText -Force
    }

    return $randomPassword
}

Function New-ComplexPassword {
    
    [Cmdletbinding(DefaultParameterSetName='Single')]
        Param(
        [Parameter(ParameterSetName='Single')]
        [Parameter(ParameterSetName='Multiple')]
        [Int]
        $PasswordLength,
        
        [Parameter(ParameterSetName='Single')]
        [Parameter(ParameterSetName='Multiple')]
        [int]
        $SpecialCharCount,

        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ParameterSetName='Multiple')]
        [String[]]
        $GenerateUserPW
        )
    Begin {   
        # The System.Web namespaces contain types that enable browser/server communication
        Add-Type -AssemblyName System.Web 
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'Single' {
                # GeneratePassword static method: Generates a random password of the specified length
                [System.Web.Security.Membership]::GeneratePassword($PasswordLength, $SpecialCharCount)
            }
            'Multiple' {
                $GenerateUserPW | Foreach {
                    # Custom Object to display results
                    New-Object -TypeName PSObject -Property @{
                        User = $_
                        Password = [System.Web.Security.Membership]::GeneratePassword($PasswordLength, $SpecialCharCount)
                   }
                }
            }
        } # End of Switch
    }
} # End of Function