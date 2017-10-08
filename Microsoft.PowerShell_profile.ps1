Function add { subl $profile }
Function x { exit }
Function rs { shutdown /r /f /t 0 }
Function open($path = '.') { ii $path }

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

Function go($path) {
    if (!(Test-Path $path)) {
        mkdir $path > $null
    }

    cd $path
}