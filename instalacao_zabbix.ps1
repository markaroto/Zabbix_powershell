#Define o endereço do servidor zabbix
$meuzabbix=meuzabbix.com.br

#url com a ultima versão do Zabbix agent para windows, infelizmente eles não possuem ainda um diretório "lastest" para facilitar
$url="http://www.zabbix.com/downloads/3.2.0/zabbix_agents_3.2.0.win.zip"

#caminho onde o arquivo será salvo
$outfile="C:\zabbix_agent.zip"

#Download efetivo do agente
$download= New-Object System.Net.WebClient
$download.DownloadFile($url,$outfile)
#Invoke-WebRequest -Uri $url -OutFile $outfile

#Descompactando o agente em C:
# show .......

function Unzip
{
    param(
        [string]$zipfile,
        [string]$outpath
    )
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
Unzip $outfile c:\zabbix_agent\


#Definindo parâmetros do agente
#$confpath='c:\zabbix_agent\conf\zabbix_agentd.win.conf'
#Set-Content -Path $confpath -Value ''
#Add-Content -Path $confpath -Value 'LogFile=C:\zabbix_agent\zabbix_agentd.log'
$confpath = Get-Content 'c:\zabbix_agent\conf\zabbix_agentd.win.conf'
$confpath[(($confpath | Select-String "^LogFile=" | Select-Object linenumber).linenumber) -1]='LogFile=C:\zabbix_agent\zabbix_agentd.log'
$confpath[(($confpath | Select-String "^LogFileSize=" | Select-Object linenumber).linenumber) -1 ]='LogFileSize=1024'
$confpath[(($confpath | Select-String "^DebugLevel=" | Select-Object linenumber).linenumber) -1 ]='DebugLevel=3'
$confpath[(($confpath | Select-String "^EnableRemoteCommands=" | Select-Object linenumber).linenumber) -1 ]='EnableRemoteCommands=1'
$confpath[(($confpath | Select-String "^LogRemoteCommands=" | Select-Object linenumber).linenumber) -1 ]='LogRemoteCommands=1'
$confpath[(($confpath | Select-String "^DebugLevel=" | Select-Object linenumber).linenumber) -1 ]='DebugLevel=3'
$confpath[(($confpath | Select-String "^Server=" | Select-Object linenumber).linenumber) -1 ]= "Server=$meuzabbix"

$confpath[(($confpath | Select-String "^ListenPort=" | Select-Object linenumber).linenumber) -1 ]='ListenPort=10050'
$confpath[(($confpath | Select-String "^ListenIP=" | Select-Object linenumber).linenumber) -1 ]='ListenIP=0.0.0.0'
$confpath[(($confpath | Select-String "^StartAgents=" | Select-Object linenumber).linenumber) -1 ]='StartAgents=5'
$confpath[(($confpath | Select-String "^DebugLevel=" | Select-Object linenumber).linenumber) -1 ]='DebugLevel=3'

$confpath[(($confpath | Select-String "^ServerActive=" | Select-Object linenumber).linenumber) -1 ]='ServerActive=zabbix.ewinfo.com.br'
$confpath[(($confpath | Select-String "^Hostname=Windows" | Select-Object linenumber).linenumber) -1 ]= 'HostnameItem=system.hostname'

$confpath[(($confpath | Select-String "^RefreshActiveChecks=" | Select-Object linenumber).linenumber) -1 ]='RefreshActiveChecks=120'
$confpath[(($confpath | Select-String "^BufferSend=" | Select-Object linenumber).linenumber) -1 ]='BufferSend=5'
$confpath[(($confpath | Select-String "^BufferSize=" | Select-Object linenumber).linenumber) -1]='BufferSize=1000'
$confpath[(($confpath | Select-String "^MaxLinesPerSecond=" | Select-Object linenumber).linenumber) -1 ]='MaxLinesPerSecond=100'
$confpath[(($confpath | Select-String "^Timeout=" | Select-Object linenumber).linenumber) -1 ]='Timeout=30'
$confpath[(($confpath | Select-String "^UnsafeUserParameters=" | Select-Object linenumber).linenumber) -1 ]='UnsafeUserParameters=1'

$confpath | Out-File  'c:\zabbix_agent\conf\zabbix_agentd.win.conf'

#Verifica arquitetura do windows
#$osarch=(Get-WmiObject Win32_OperatingSystem).OSArchitecture
#if ($osarch -eq "32 bits") {
#Set-Location C:\zabbix_agent\bin\win32\
#}elseif($osarch -eq "64 bits"){
#Set-Location C:\zabbix_agent\bin\win64\
#}
if([environment]::Is64BitOperatingSystem){
    Set-Location C:\zabbix_agent\bin\win64\
}else{
    Set-Location C:\zabbix_agent\bin\win32\    
}

#instalando serviço zabbix Agent
.\zabbix_agentd.exe -i -c $confpath
.\zabbix_agentd.exe -s
Invoke-Item -Path 'c:\zabbix_agent\conf\zabbix_agentd.win.conf'
#$checkagent=netstat -na | Select-String 0.0.0.0:10050 | out-file c:\zabbix_agent\Status.txt
#Invoke-Item -Path $checkagent
try{
    $teste=New-Object System.Net.Sockets.TcpClient
    $teste.Connect('localhost',10050)
    $teste.Available
}
catch{
    Write-Host "Porta do zabbix com falha."
}



