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

Function seenotes ($name = '') {
    Get-ChildItem C:\work\Notes -r | Where-Object {!$_.PSIsContainer -and  $_.Name -match $name } | Select-Object Directory, Name
}

Function cleannotes {
    Get-ChildItem C:\work\Notes -r | Where-Object {$_.PSIsContainer -and `
    @(Get-ChildItem -Lit $_.Fullname -r | Where-Object {!$_.PSIsContainer}).Length -eq 0} |
    Remove-Item -r
}

Function viewnotes($name) {
    Get-ChildItem C:\work\Notes -r | Where-Object {!$_.PSIsContainer -and  $_.Name -match $name } | Invoke-Item
}

Function delta($alpha, $beta) {
    Compare-Object (Get-Content $alpha) (Get-Content $beta)
}

Function brightness($value = 100) {
    $monitor = Get-WmiObject -ns root/wmi -class wmiMonitorBrightNessMethods
    $monitor.WmiSetBrightness(0, $value)
}

Function query($query, $server = '(localdb)\MessagingMiddleware', $database = 'MessageDB') {
    $definedServer = Get-Variable 'server' -Scope Global -ErrorAction 'Ignore'
    $definedDatabase = Get-Variable 'database' -Scope Global -ErrorAction 'Ignore'
    if ($definedServer) { $server = $definedServer.Value }
    if ($definedDatabase) { $database = $definedDatabase.Value }
    Invoke-Sqlcmd -Query $query -ServerInstance $server -Database $database
}

Function scry($name, [switch] $image = $false) {
    $name = [uri]::EscapeUriString($name)
    $content = Invoke-WebRequest "https://api.scryfall.com/cards/named?fuzzy=$name" | ConvertFrom-Json
    $cardName = $content.name
    if ($image) {
        $location = "C:\Personal\Scryfall\$cardName.jpg"
        if (!(Test-Path $location)) {
            Invoke-WebRequest $content.image_uris.normal -OutFile $location
        }
        view($location)
    } else {
        Write-Host $content.oracle_text
    }
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
