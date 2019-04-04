#Set-PSReadlineOption -BellStyle None
# Add-Type -path C:\Users\lvincent\Documents\WindowsPowerShell\VolumeControl.cs 

Add-Type -AssemblyName System.speech
$speechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer

Function pow { Start-Process powershell }
Function add { code $profile }
Function x { exit }
Function open( $path = '.') { Invoke-Item $path }
Function up { Set-Location .. }
Function res { shutdown /r /f /t 0 }

Function sh($time = 0) {
    if ($time -ne 0) {
        $time *= 60
    }
    shutdown /s /f /t $time
}

Function rip($time = 0) {
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

Function ghibli { browse https://www.youtube.com/watch?v=9YNws6yE9Ns=1s }
Function ghiblijazz { browse https://youtu.be/3jWRrafhO7M?t=1s }

Function go($path) {
    if (!(Test-Path $path)) {
        mkdir $path > $null
    }
    Set-Location $path
}

Function notes {
    $today = Get-Date -Format yyyy/MMM/ddd-dd
    go C:\Notes\$today
}

Function seenotes ($name = '') {
    Get-ChildItem C:\Notes -r | Where-Object {!$_.PSIsContainer -and  $_.Name -match $name } | Select-Object Directory, Name
}

Function cleannotes {
    Get-ChildItem C:\Notes -r | Where-Object {$_.PSIsContainer -and `
    @(Get-ChildItem -Lit $_.Fullname -r | Where-Object {!$_.PSIsContainer}).Length -eq 0} |
    Remove-Item -r
}

Function viewnotes([Parameter(Mandatory=$true)] $name) {
    Get-ChildItem C:\work\Notes -r | Where-Object {!$_.PSIsContainer -and  $_.Name -match $name } | Invoke-Item
}

Function delta($alpha, $beta) {
    Compare-Object (Get-Content $alpha) (Get-Content $beta)
}

Function brightness($value = 100) {
    $monitor = Get-WmiObject -ns root/wmi -class wmiMonitorBrightNessMethods
    $monitor.WmiSetBrightness(0, $value)
}

Function query($query, $server = '(localdb)\GMW', $database = 'MessageDB') {
    $definedServer = Get-Variable 'server' -Scope Global -ErrorAction 'Ignore'
    $definedDatabase = Get-Variable 'database' -Scope Global -ErrorAction 'Ignore'
    if ($definedServer) { $server = $definedServer.Value }
    if ($definedDatabase) { $database = $definedDatabase.Value }
    Invoke-Sqlcmd -Query $query -ServerInstance $server -Database $database
}

Function view($file) {
    [void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
    $img = [System.Drawing.Image]::Fromfile($file);

    [System.Windows.Forms.Application]::EnableVisualStyles();
    $form = new-object Windows.Forms.Form
    $form.Text = "Image Viewer"
    $form.Width = $img.Size.Width;
    $form.Height =  $img.Size.Height;
    $pictureBox = new-object Windows.Forms.PictureBox
    $pictureBox.Width =  $img.Size.Width;
    $pictureBox.Height =  $img.Size.Height;

    $pictureBox.Image = $img;
    $form.controls.add($pictureBox)
    $form.Add_Shown( { $form.Activate() } )
    $form.ShowDialog()
}

Function HashContent($path) {
    Get-ChildItem $path -Recurse | Where-Object{!$_.psiscontainer} | ForEach-Object{[Byte[]]$contents += [System.IO.File]::ReadAllBytes($_.fullname)}
    $hasher = [System.Security.Cryptography.SHA1]::Create()
    [string]::Join("",$($hasher.ComputeHash($contents) | ForEach-Object {"{0:x2}" -f $_}))
}

Function ShareFolder($path, $user) {
    $securitySettings = Get-Acl $path
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $securitySettings.SetAccessRule($accessRule)
    Set-Acl $path $securitySettings
}

Function CheckSize ($size = 50mb, $path = '.') {
    Get-ChildItem $path -Recurse | Where-Object {$_.Length -ge $size } | ForEach-Object { Write-Host $_.FullName " is >= $size" }
}

Function Window($width = 0, $height = 0) {
    if ($width -eq 0 -and $height -eq 0) {
        $host.UI.RawUI
    } else {
        $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size($width, $height)
    }
}

Function Speak($phrase) {
    $speechSynth.Speak($phrase)
}
