$list = Get-Content depList.txt

$clnt = New-Object System.Net.WebClient

Write-Host "[Stage 1] Downloading dependencies..."

foreach($url in $list) {
    #Get the filename 
    $filename = [System.IO.Path]::GetFileName($url)

    #Create the output path 
    $file = [System.IO.Path]::Combine($pwd.Path, $filename) 

    Write-Host -NoNewline "Downloading ""$url""..."

    #Download the file using the WebClient 
    $clnt.DownloadFile($url, $file)

    Write-Host -NoNewline " Done!`n"
}
Write-Host "[Stage 2] Renaming dependencies..."

Rename-Item -Path "$($pwd.Path)\lua%20sdk.lua" -NewName "lib_gamesense.lua"
Rename-Item -Path "$($pwd.Path)\images.lua" -NewName "lib_image.lua"
Rename-Item -Path "$($pwd.Path)\maf.lua" -NewName "lib_maf.lua"

Write-Host "[Stage 3] Moving dependencies..."

Move-Item -Path "$($pwd.Path)\lib_gamesense.lua" -Destination "$($pwd.Path)\scripts"
Move-Item -Path "$($pwd.Path)\lib_image.lua" -Destination "$($pwd.Path)\scripts"
Move-Item -Path "$($pwd.Path)\lib_maf.lua" -Destination "$($pwd.Path)\scripts"

Write-Host "[Stage 4] Unzip game dependencies..."

Add-Type -AssemblyName System.IO.Compression.FileSystem

[System.IO.Compression.ZipFile]::ExtractToDirectory("$($pwd.Path)\scripts\csgo.zip", "$($pwd.Path)\scripts")

Write-Host "Completed!"