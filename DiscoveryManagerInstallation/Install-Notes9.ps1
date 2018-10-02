$notesSetupPath = 'C:\temp\Deploy\NOTES_9.0.1\setup.exe'
$notesSetupOpt = ' /s /v"/qn"'
$notesInstallPath = "C:\Program Files (x86)\IBM\Notes\notes.exe"


$notesSetupPID = Start-Process -FilePath $notesSetupPath -ArgumentList $notesSetupOpt -Wait -Verb runas

if ( $(Try { Test-Path $notesInstallPath.trim() } Catch { $false }) ) {
   Write-Host "Lotus Notes Install Successful."  -ForegroundColor Green
 }
Else {
   Write-Host "Lotus Notes Install Failed." -ForegroundColor Red 
 }

# Loads Default User Settings
Add-Content "C:\Program Files (x86)\IBM\Notes\notes.ini" "ConfigFile=C:\Deploy\Settings\Notes9_setup.cfg"
# Removes close prompt from Notes
Add-Content "C:\Program Files (x86)\IBM\Notes\notes.ini" "ExitNotesPrompt=1"

#### Start Notes Initialization Process #####
#### Open Lotus Notes #####
$notesInstallPath = "C:\Program Files (x86)\IBM\Notes\notes.exe"
$notesSetupPID = Start-Process -FilePath $notesInstallPath
Start-Sleep -s 30

$wshellinit = new-object -com wscript.shell
if ($wshellinit.AppActivate("IBM Notes Social Edition Client Configuration")) {
    #Complete Notes Configuration
    $wshellinit.Sendkeys("%(F)")
}

## Wait for Lotus to Completely Load
Start-Sleep -s 60

#### Close Lotus Notes ####
$isNotesOpen = Get-Process notes2*
if($isNotesOpen = $null){
    # Notes is already closed run code here:
    Write-Host "Lotus Notes is Closed" -ForegroundColor Green
    }
else {
     $isNotesOpen = Get-Process notes2*

     # while loop makes sure all notes windows are closed before moving on to other code:
         while($isNotesOpen -ne $null){
            Get-Process notes2* | ForEach-Object {$_.CloseMainWindow() | Out-Null }
            sleep 5
            If(($isNotesOpen = Get-Process notes2*) -ne $null){
            Write-Host "Notes is Open.......Closing Notes"
                $wshell = new-object -com wscript.shell
                $wshell.AppActivate("Discover - IBM Notes")
                $wshell.Sendkeys("%(F4)")
                $wshell.Sendkeys("x")

            $isNotesOpen = Get-Process notes2*          }
        }
        #Notes has been closed run code here:
        Write-Host "Lotus Notes is Closed" -ForegroundColor Green
    }
