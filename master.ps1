#Get Directory this Powershell is in

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

#Import config.csv 
cd $scriptPath

If(test-path config.csv)
{
    $configFile = import-csv config.csv
    Write-Host "Config.csv found and imported"
}
Else
{
    Write-Host "Can't find Config.csv"
    Exit
}
$c
#Get Settings from Config
$districtCode = $configFile | select -ExpandProperty DISTRICT_CODE -first 1
$MISTerm = $configFile | select -ExpandProperty MIS_TERM -first 1

#Find .EXT Files and valid files in the Config

$ExtFiles = Get-ChildItem -Filter *.EXT 
$validFiles = $configFile | select -ExpandProperty VALID_FILES

#Check if Files are in the list of valid files in the Config
foreach ($file in $ExtFiles)
{
    $tempName =  [System.IO.Path]::GetFileNameWithoutExtension($file)
        
    if($validFiles -contains $tempName)
    {
        if($tempName -eq "SB_STU"){$tempName = "SB"}
        
        $tempPath = "U" + $districtCode.Substring(0,2) + $MISTerm + $tempName + ".dat"
        #Copy File if there isn't already a corresponding .dat
        if(-Not(test-path $tempPath))
        {
            Copy-Item $file -destination $tempPath
            Write-Host "$tempPath created"
        }
              
    }
}

Write-Host "Finished transforming .ext files into .dat files (if any found)" 
Write-Host "Creating TX File" 

$TXName = "U" + $districtCode.Substring(0,2) + $MISTerm + "TX" + ".dat"

If(test-path $TXName)
{
    Write-Host "A TX file for this district/term already exists here"
    Exit

}
Else
{
    New-Item $TXName -type file
    Write-Host "TX File Created"

}

$datFiles = Get-ChildItem -Filter U*$MISTerm*.dat 

foreach ($file in $datFiles)
{
    $fileType = [System.IO.Path]::GetFileNameWithoutExtension($file).substring(6,2)
    if($validFiles -contains $fileType)
    {
        #Get number of lines in $file
        [string]$lines = get-content $file | Measure-Object -line | select -expandproperty lines
        $lines = $lines.PadLeft(8)
                
        #Write the full line to the TX
        [string]$fileName = $file.Name -replace '\.',''
        $content = "TX" + $districtCode + $MISTerm + $fileType + $lines + $fileName
        Add-Content $TXName $content
    }
}

#Get Contact Information from config.csv - DP Manager, Tech Contact, Data Contact

$DPFName = $configFile | select -ExpandProperty FIRST_NAME -first 1
    if($DPFName.length -gt 10)
    {
        $DPFName = $DPFName.Substring(0,10)
        Write-Host "DP Manager First Name Truncated"
    }
    $DPFName = $DPFName.PadRight(10).ToUpper()
$DPLName = $configFile | select -ExpandProperty LAST_NAME -first 1
    if($DPLName.length -gt 16)
    {
        $DPLName = $DPLName.Substring(0,16)
        Write-Host "DP Manager Last Name Truncated"
    }
    $DPLName = $DPLName.PadRight(16).ToUpper()
[string]$DPNum = $configFile | select -ExpandProperty PHONE_NUM -first 1
$DPNum = $DPNum -replace '[\W]',''
if($DPNum.Substring(0,1) -eq "1") {$DPNum = $DPNum.Substring(1)}
$DPNum = $DPNum.PadRight(17)


$techFName = $configFile | select -ExpandProperty FIRST_NAME -skip 1 -first 1
    if($techFName.length -gt 10)
    {
        $techFName = $techFName.Substring(0,10)
        Write-Host "Tech First Name Truncated"
    }
    $techFName = $techFName.PadRight(10).ToUpper()
$techLName = $configFile | select -ExpandProperty LAST_NAME -skip 1 -first 1
    if($techLName.length -gt 16)
    {
        $techLName = $techLName.Substring(0,16)
        Write-Host "Tech Last Name Truncated"
    }
    $techLName = $techLName.PadRight(16).ToUpper()
[string]$techNum = $configFile | select -ExpandProperty PHONE_NUM -skip 1 -first 1
$techNum = $techNum -replace '[\W]',''
if($techNum.Substring(0,1) -eq "1") {$techNum = $techNum.Substring(1)}
$techNum = $techNum.PadRight(17)


$dataFName = $configFile | select -ExpandProperty FIRST_NAME -skip 2 -first 1
    if($dataFName.length -gt 10)
    {
        $dataFName = $dataFName.Substring(0,10)
        Write-Host "Tech First Name Truncated"
    }
    $dataFName = $dataFName.PadRight(10).ToUpper()
$dataLName = $configFile | select -ExpandProperty LAST_NAME -skip 2 -first 1
    if($dataLName.length -gt 16)
    {
        $dataLName = $dataLName.Substring(0,16)
        Write-Host "Tech Last Name Truncated"
    }
    $dataLName = $dataLName.PadRight(16).ToUpper()
[string]$dataNum = $configFile | select -ExpandProperty PHONE_NUM -skip 2 -first 1
$dataNum = $dataNum -replace '[\W]',''
if($dataNum.Substring(0,1) -eq "1") {$dataNum = $dataNum.Substring(1)}
$dataNum = $dataNum.PadRight(17)


#Get number of lines in TX file

[int]$TXLines = get-content $TXName | Measure-Object -line | select -expandproperty lines
$TXLines = $TXLines + 1
[string]$sTXLines = $TXLines
$sTXLines = $sTXLines.PadLeft(8)

#Write final Line

[string]$sTXName = $TXName -replace '\.',''

$lastLine = "TX" + $districtCode + $MISTerm + "TX" + $sTXLines + $sTXName + $DPFName + $DPLName + $DPNum + $techFName + $techLName + $techNum + $dataFName + $dataLName + $dataNum

$lastLine = $lastLine.PadRight(200)

Add-Content $TXName $lastLine

Write-Host "TX File Complete!"