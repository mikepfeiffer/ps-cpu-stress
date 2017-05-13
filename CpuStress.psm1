function New-CpuStress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [int32]
        $CoreCount = 1
    )

    process {
        Write-Verbose "Creating $CoreCount jobs for CpuStress"
        foreach($i in 1..$CoreCount) {
            $guid = [System.Guid]::NewGuid().Guid
            Start-Job -ScriptBlock {
                $result = 1
                foreach ($number in 1..2147483647) {
                    $result = $result * $number
                }
            } -Name "cpustress-$guid"        
        }
    }
}

function Get-CpuStress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name
    )

    process {
        if($Name) {
            Write-Verbose "Getting $Name"
            Get-Job -Name $Name
        }
        else {
            Write-Verbose "Getting all cpustress jobs"
            Get-Job -Name cpustress-*
        }
    }
}

function Stop-CpuStress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name
    )

    process {
        if($Name) {
            Write-Verbose "Removing $Name"
            Stop-Job -Name $Name -Confirm:$false
            Remove-Job -Name $Name -Force -Confirm:$false
        }
        else {
            Write-Verbose "Removing all cpustress jobs"
            Get-Job -Name cpustress-* | Stop-Job -Confirm:$false
            Get-Job -Name cpustress-* | Remove-Job -Confirm:$false
        }
    }
}