
Write-Host ""
Write-Host "This program"
Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring files with saved Baseline?"
Write-Host ""

$response = Read-Host -Prompt "Please enter 'A' or 'B'"


Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHAsh -Path $filepath -Algorithm SHA512
    return $filehash


}

Function Erase-Duplicate-Basline() {
    $baselineExists = Test-PAth -PAth .\baseline.txt

    if ($baselineExists) {
        # Delete duplicate baseline
        Remove-Item -Path .\baseline.txt
    }
}



if ($response -eq "A".ToUpper()) {
    #Delete baseline.txt if it already exists
    Erase-Duplicate-Basline

    # Calculate Hash from target file and store in baseline.txt
    #Collect all files in the target folder
    $files = Get-ChildItem -Path .\Files

    #For file, calculate hash, and write to baseline.txt

    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }

}

elseif ($response -eq "B".ToUpper()) {

    $fileHashTable = @{}

    # Load file|hash from baseline.txt and store in dictionary 19:53
    $filePathesAndHashes = Get-Content -Path .\baseline.txt
    
    foreach ($f in $filePathesAndHashes) {
        $fileHashTable.add($f.Split("|")[0], $f.Split("|")[1])

    }

  
    # Begin continuously monitoring files with saved Baseline
    while ($true) {
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path .\Files

        #For file, calculate hash, and write to baseline.txt

        foreach ($f in $files) {
            $hash = Calculate-File-Hash $f.FullName
            # "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append

            #Notify if new file is created
            if ($fileHashTable[$hash.Path] -eq $null) {
                #Detected creation of new file
                Write-Host "$($hash.Path) was created" -ForegroundColor Green
      
            }
            else {
      
                #Notify if file has been changed
                if ($fileHashTable[$hash.Path] -eq $hash.Hash) {
                    # File has not changed
      
                }

                else {

                    # File compromised, notify user

                    Write-Host "$($hash.Path) has changed" -ForegroundColor Red
       
       
                }
            }
        }

        foreach ($key in $fileHashTable.Keys) {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists) {
                # One of the baseline files must have been deleted, notify the user
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }


    
    }
}


