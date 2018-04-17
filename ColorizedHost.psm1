<#
.SYNOPSIS
  Writes text to console with specified words highlighted in colors..
.DESCRIPTION
  Writes text to console with specified words highlighted in colors.
.EXAMPLE
  Write-ColorizedHost -Word "Success", "Warning", "Error" -Color Green, Yellow, Red -Text "This is some text. The previous action was a success. Not an error or warning."
#>
function Write-ColorizedHost {
  [CmdletBinding()]
  param(
        [Parameter(ValueFromPipeline=$true, Position=0)][string]$Text,
        [Parameter(Mandatory = $false)][string[]]$Word = "success",
        [Parameter(Mandatory = $false)][System.ConsoleColor[]]$Color = 'Green',
        [Parameter(Mandatory = $false)][System.ConsoleColor]$DefaultColor = 'White'
  )
  
  begin {

  }
  
  process {

    if (($Text -ne "") -and ($Text -ne $null)) {
      $AllMatches = @()
      $ColorTable = @{}
      $i = 0

      $Word.ForEach({
        $ColorTable[$_] = $Color[$i]
        $i++
        Select-String ([regex]::Escape($_)) -InputObject $Text -AllMatches | ForEach-Object {
            $AllMatches += $_.matches
        }
      })

      $objCollection = @()

      $lastEnd = -1

      $AllMatches | Sort-Object Index | Group-Object Index | Foreach-Object { $_.Group | sort Length -Descending } | ForEach-Object {

          if (($_.Index) -gt $lastEnd - 1) {
              $object = New-Object -TypeName PSObject
              $object | Add-Member -MemberType NoteProperty -Name "text" -Value ($text.Substring($_.Index, $_.Length))
              $object | Add-Member -MemberType NoteProperty -Name "color" -Value $ColorTable[$_.Value]
              $object | Add-Member -MemberType NoteProperty -Name "startIndex" -Value $_.Index
              $object | Add-Member -MemberType NoteProperty -Name "length" -Value $_.Length
              $object | Add-Member -MemberType NoteProperty -Name "lastIndex" -Value  ($_.Index + $_.Length)
              $objCollection += $object
              $lastEnd = $object.lastIndex
          }

      }

      if ($objCollection.Count -gt 0) {
          if ($objCollection[0].startIndex -gt 0) {
              Write-Host -NoNewline -ForegroundColor $DefaultColor -Object $Text.Substring(0, $objCollection[0].startIndex)
          }

          $i = 0
          $objCollection | ForEach-Object {
              Write-Host -NoNewline -ForegroundColor $_.color -Object ($text.Substring($_.StartIndex, $_.Length))
              $endIndex = $_.StartIndex + $_.length
              $i++
              if ($objCollection.count -gt ($i)) {
                  if ($objCollection[$i].StartIndex -gt $endIndex) {
                      Write-Host -ForegroundColor $DefaultColor -NoNewline -Object $text.Substring($endIndex, ($objCollection[$i].StartIndex - $endIndex))
                  } 
              }
              else {
                  Write-Host -ForegroundColor $DefaultColor -NoNewline -Object $text.Substring($endIndex, $text.length - $endIndex)
              }

          }

      }
      else {
          Write-Host -Object $Text -ForegroundColor $DefaultColor -NoNewline
      }

      Write-Host
    }

  }
  
  end {
  }
}
Export-Modulemember -function Write-ColorizedHost -Cmdlet Write-ColorizedHost