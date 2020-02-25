Set-PSReadlineOption -BellStyle None

Add-Type -AssemblyName System.speech
$speechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer

Function pow { Start-Process powershell }
Function add { code $profile }
Function x { exit }
Function open( $path = '.') { Invoke-Item $path }
Function up { Set-Location .. }
Function res { shutdown /r /f /t 0 }

Function rip($time = 0) {
    if ($time -ne 0) { $time *= 60 }
    shutdown /s /f /t $time
}

Function sh($time = 0) { rip $time }

Function browse($target = ' ') {
    Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" $target
}

Function go($path) {
    if (!(Test-Path $path)) { mkdir $path > $null }
    Set-Location $path
}

Function Notes($title) {
    if ($title) {
        $today = Get-Date -Format MM/dd/yyyy
        $template = "$title`n=`n###### $today`n"
        $path = "C:\Notes\$title.md"
        Set-Content -Path $path -Value $template
        code $path
    } else {
        go C:\Notes\
    }
}

Function SearchNotes($tag, [switch] $archive) {
    # For both view and search notes, consider facility to search tag combinations
    # Would it be useful to list the tags present in each file?
    if ($archive) {
        Get-ChildItem C:\Notes, C:\Notes\Archive | Select-String -Pattern "``$tag``" -SimpleMatch | Select-Object Path
    } else {
        Get-ChildItem C:\Notes | Select-String -Pattern "``$tag``" -SimpleMatch | Select-Object Filename
    }
}

Function ViewNotes($tag, [switch] $archive) {
    if ($archive) {
        Get-ChildItem C:\Notes, C:\Notes\Archive | Select-String -Pattern "``$tag``" -SimpleMatch | ForEach-Object { code $_.Path }
    } else {
        Get-ChildItem C:\Notes | Select-String -Pattern "``$tag``" -SimpleMatch | ForEach-Object { code $_.Path }
    }
}

Function ArchiveNotes() {
    # TODO
    # By default move anything older than 6 months to the archive folder
    # Have a time parameter to be able to specify how old it should be otherwise
    # Possibly 
}

Function Transcribe($name = '') {
    if ($name -eq '') { $name = Get-Date -Format ddd-dd }
    Start-Transcript -Path "C:\Notes\Transcript_$name.txt"
}

Function Stop {
    Stop-Transcript
}

Function Delta($alpha, $beta) {
    Compare-Object (Get-Content $alpha) (Get-Content $beta)
}

Function Brightness($value = 100) {
    $monitor = Get-WmiObject -ns root/wmi -class wmiMonitorBrightNessMethods
    $monitor.WmiSetBrightness(0, $value)
}

Function Query($query, $server = '(localdb)\Personal', $database = 'POC') {
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


Function searchgroups { rundll32 dsquery OpenQueryWindow }

Function CreateLocalDb($name) { sqllocaldb create $name }
