Set-PSReadlineOption -BellStyle None

Function add { subl $profile }
Function x { exit }
Function open( $path = '.') { ii $path }
Function up { cd .. }
Function rs { shutdown /r /f /t 0 }

Function sh($time = 0) {
    if ($time -ne 0) {
        $time *= 60
    }
    shutdown /s /f /t $time
}

Function browse($target) {
    if ($target) {
        Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" $target
    } else {
        Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    }
}

Function ghibli { browse https://youtu.be/3jWRrafhO7M?t=1s }
Function ghiblijazz { browse https://youtu.be/3jWRrafhO7M?t=1s }

Function go($path) {
    if (!(Test-Path $path)) {
        mkdir $path > $null
    }
    cd $path
}

Function notes {
    $today = Get-Date -Format yyyy/MMM/ddd-dd
    go C:\work\Notes\$today
}

Function cleannotes {
    gci C:\work\Notes -r | ? {$_.PSIsContainer -and `
    @(gci -Lit $_.Fullname -r | ? {!$_.PSIsContainer}).Length -eq 0} |
    rm -r
}
