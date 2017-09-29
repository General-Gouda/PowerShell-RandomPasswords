function New-PasswordFromWordList
{
    [CmdletBinding()]
    param
    (
        [int]$NumberOfWordsInPassword = 3,
        [int]$PasswordLength = 16,
        [switch]$NumbersAtTheEnd
    )

    if ($NumbersAtTheEnd)
    {
        $PasswordLength = $PasswordLength - 3
    }

    if (($PasswordLength / $NumberOfWordsInPassword) -lt 4)
    {
        Throw "Impossible calculation.`nToo many words requested in password for length to mathematically handle.`nPlease decrease the number of words or increase the password length."    
    }
    else
    {
        Push-Location $PSScriptRoot

        $words = Get-Content .\wordlist.txt

        [string]$password = $null
        $numArray = @()
        $total = 0
            
        do
        {
            $total = 0
            $numArray = @()
        
            1..$NumberOfWordsInPassword | ForEach-Object {
                $numArray += Get-Random -Minimum 4 -Maximum $PasswordLength
            }
        
            foreach ($num in $numArray)
            {
                $total += $num
            }
        } until ($total -eq $PasswordLength)

        foreach ($number in $numArray)
        {
            if ($number -ne $lastNum)
            {
                $wordArray = New-Object System.Collections.ArrayList
            
                foreach ($word in $words)
                {
                    if ($word.Length -eq $number)
                    {
                        $wordArray.add($word) | Out-Null
                    }
                }
            }
        
            $randomWord = $wordArray | Get-Random
        
            $password += (Get-Culture).TextInfo.ToTitleCase($randomWord)
        }
        
        if ($NumbersAtTheEnd)
        {
            $password += (100..999 | Get-Random -Count 1)
        }

        Pop-Location

        return $password
    }
}