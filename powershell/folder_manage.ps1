# passing parameters
param([string]$source="c:\temp\source",[string]$destination="c:\temp\destination")

#function to check folder
function Check-Folder([string]$path, [switch]$create){
    $exists = Test-Path $path

    if(!$exists -and $create){
        #create the directory because it doesn't exist
        mkdir $path | out-null
        $exists = Test-Path $path
    }
    return $exists
}




function Display-FolderStats([string]$path){
 $files = dir $path -Recurse | where {!$_.PSIsContainer}
 $totals = $files | Measure-Object -Property length -sum
 $stats = "" | Select path,count,size
 $stats.path = $path
 $stats.count = $totals.count
 $stats.size = [math]::round($totals.sum/1MB,2)
 return $stats
}



$sourceexists = Check-Folder $source

if (!$sourceexists){
    Write-Host "The source directory is not found. Script can not continue."
    Exit
}

$destinationexists = Check-Folder $destination -create

if (!$destinationexists){
    Write-Host "The destination directory is not found. Script can not continue."
    Exit
}


$files = dir $source -Recurse | where {!$_.PSIsContainer}


foreach ($file in $files){
    $ext = $file.Extension.Replace(".","")
    $extdestdir = "$destination\$ext"

    #check to see if the folder exists, if not create it
    $extdestdirexists = Check-Folder $extdestdir -create

    if (!$extdestdirexists){
        Write-Host "The destination directory ($extdestdir) can't be created."
        Exit
    }

    #copy file
    copy $file.fullname $extdestdir
}


$dirs = dir $destination | where {$_.PSIsContainer}

$allstats = @()
foreach($dir in $dirs){
    $allstats += Display-FolderStats $dir.FullName
}

$allstats | sort size -Descending


