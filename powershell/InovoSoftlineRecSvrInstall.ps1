﻿Start-Process -FilePath .\nssm.exe -ArgumentList 'install InovoSoftlineRecShell "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-command "& { . C:\software\inovo\powershell\InovoSoftlineRecSvr.ps1; Start-TaggingRecordings }"" ' -NoNewWindow -Wait