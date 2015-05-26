if exist "C:\Windows\Temp\puppet.msi" exit 0

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set URL=https://s3.amazonaws.com/pe-builds/released/3.8.0/puppet-enterprise-3.8.0-x64.msi
) else (
    set URL=https://s3.amazonaws.com/pe-builds/released/3.8.0/puppet-enterprise-3.8.0.msi
)

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%URL%', 'C:\Windows\Temp\puppet.msi')" <NUL
if errorlevel 1 goto :ErrorExit

:HavePuppetMSI
:: http://docs.puppetlabs.com/pe/latest/install_windows.html
start "puppet-install" /w msiexec /qn /i C:\Windows\Temp\puppet.msi /log C:\Windows\Temp\puppet.log
if errorlevel 1 goto :ErrorExit

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    <nul set /p ".=;C:\Program Files\Puppet Labs\Puppet\bin" >> C:\Windows\Temp\PATH
) else (
    <nul set /p ".=;C:\Program Files (x86)\Puppet Labs\Puppet\bin" >> C:\Windows\Temp\PATH
)
set /p Path=<C:\Windows\Temp\PATH
setx Path "%Path%" /m
exit /b %ERRORLEVEL%

:ErrorExit
del /f /q C:\Windows\Temp\puppet.msi
exit /b 1
