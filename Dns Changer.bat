@echo off
cls
echo:
echo              Dns Changer By ConfusedCharacter 
echo                   github @ConfusedCharacter
echo:
echo 1-Change DNS
echo 2-Reset DNS to Auto
echo:

echo -----------------------INFO-----------------------
FOR /F "tokens=*" %%g IN ('powershell.exe -ExecutionPolicy Bypass -Command "Get-NetAdapter  * | Format-List -Property "Name" | findstr /R "Name""') do (SET VAR=%%g)
echo Adapter %VAR%
echo:

echo Current DNS 
powershell.exe -ExecutionPolicy Bypass -Command "Get-DnsClientServerAddress -AddressFamily IPv4 * | Format-List -Property "ServerAddresses" |findstr /R "ServerAddresses""
echo:
echo -----------------------END-----------------------
echo:

set /p "option=Choose Option : "


set /p "adaptor=Enter Netowrk Adapter Name (1 for Ethernet and 2 for Wi-Fi or write something else...): "

if %adaptor%==1 ( 
    set adaptor=Ethernet

) else if %adaptor%==2 (

    set adaptor=Wi-Fi
)

if %option%==1 (
    set /p "dns1=Enter Preferred DNS : "
    set /p "dns2=Enter Alternate DNS : "
) else if %option%==2 (
    @netsh interface ipv4 set dnsservers name="%adaptor%" source=dhcp
    echo All DNS's Removed Success.
    echo:
    set /p "p=Press Any Key To Exit..."
    Exit
)
echo:
echo ---Testing DNS Connection---
powershell.exe -ExecutionPolicy Bypass -Command "test-connection %dns1%,%dns2% -Count 1 | format-table ResponseTime"

netsh interface ipv4 set dnsservers "%adaptor%" static %dns1% primary
netsh interface ip add dns "%adaptor%" %dns2% index=2
ipconfig /flushdns
echo: 
echo DNS set Successfully.
echo: 
set /p "p=Press Any Key To Exit..."
