cd "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
if not exist c:\offline md c:\offline
dism /mount-wim /wimfile:c:\iso\sources\install.wim /index:1 /mountdir:c:\offline
dism /image:c:\offline /enable-feature /featurename:NetFx3 /all /limitaccess /source:c:\iso\sources\sxs
dism /unmount-wim /mountdir:c:\offline /commit