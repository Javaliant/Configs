Set-PSReadlineOption -BellStyle None

Function pow { Start-Process powershell }
Function add { subl $profile }
Function x { exit }
Function open( $path = '.') { ii $path }
Function up { cd .. }
Function res { shutdown /r /f /t 0 }

Function sh($time = 0) {
    if ($time -ne 0) {
        $time *= 60
    }
    shutdown /s /f /t $time
}

Function rip($time = 0) {
    sh($time)
}

Function browse($target = ' ') {
    Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" $target
}

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

Function seenotes {
    gci C:\work\Notes -r | ? {!$_.PSIsContainer} | Select Directory, Name
}

Function cleannotes {
    gci C:\work\Notes -r | ? {$_.PSIsContainer -and `
    @(gci -Lit $_.Fullname -r | ? {!$_.PSIsContainer}).Length -eq 0} |
    rm -r
}

Function brightness($value = 100) {
    $monitor = Get-WmiObject -ns root/wmi -class wmiMonitorBrightNessMethods
    $monitor.WmiSetBrightness(0, $value)
}

Function query($query, $server = '.\SQLEXPRESS') {
    $serverDefined = Get-Variable 'db' -Scope Global -ErrorAction 'Ignore'
    if ($serverDefined) {
        $server = $serverDefined.Value
    }
    Invoke-Sqlcmd -Query $query -ServerInstance $server
}   
