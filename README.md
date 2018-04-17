# ColorizedHost
PowerShell modules that provides a function to write text to console with specified words highlighted in colors.

## How to install
Install from Powershell Gallery Repository
```
Install-Module -Name ColorizedHost
```

## How to use
### Example 1
```
Write-ColorizedHost -Word "Success", "Warning", "Error" -Color Green, Yellow, Red -Text "This is some text. The previous action was a success. Not an error or warning."
```
This will output the text with the word "Sucess" colored in green and the word "Error" colored red.

### Example 2
```
This is some text. The previous action was a success. Not an error or warning." | Write-ColorizedHost -Word "Success", "Warning", "Error" -Color Green, Yellow, Red 
```

The same output as example 1, but this uses pipeline input.
