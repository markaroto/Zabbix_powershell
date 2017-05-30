param(
    [string]$usbid
)
if ( [string]::IsNullOrEmpty($usbid)){
 #$params=New-Object System.Collections.Hashtable
    $usbinfo= (Get-WmiObject Win32_USBControllerDevice | ForEach-Object{[wmi]($_.Dependent)} | Sort-Object ClassGuid,name | Select-Object -Unique name, PNPDeviceID )
 write-host "{"
    write-host " `"data`":["
    write-host      
    #write-host $Results
               
       
    $n = ($usbinfo | measure).Count

            foreach ($Results in $usbinfo ) {
                $line = " { `"{#USBNAME}`":`""+$Results.name+"`","
                $line += "`"{#USBID}`":`""+(((($Results.PNPDeviceID -replace "&",".--.") -replace "\\",".---." ) -replace "{",".----.") -replace "}",".-----.")+"`"}" 
                if ($n -gt 1 ){
                    $line += ","
                }

                write-host $line
                $n--
            }
    
    write-host " ]"
    write-host "}"
    write-host 
}else{
 $usbid= ((($usbid -replace ".-----.","}") -replace ".----.","{" ) -replace ".---.","\") -replace ".--.","&"
 (Get-WmiObject Win32_USBControllerDevice | ForEach-Object{[wmi]($_.Dependent)}  | Where-Object {$_.PNPDeviceID -eq $usbid} | Select-Object status).status

}