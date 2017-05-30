param(
    [string]$pm,
    [string]$tip
)
if ( [string]::IsNullOrEmpty($pm)){
	#$params=New-Object System.Collections.Hashtable
	$pmtemp=Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*  | Where-Object {$_.displayname -ne $null} | select-object DisplayName,PSChildName
	 write-host "{"
    write-host " `"data`":["
    write-host      
    #write-host $Results
               
       
    $n = ($pmtemp | measure).Count

            foreach ($Results in $pmtemp ) { 
                $b= $Results.PSChildName -replace " ","----"
                $b= $b -replace "{","---"
                $b= $b -replace "}","--"               
                $line = " { `"{#FSPMAME}`":`""+$b+"`","
                $line += "`"{#FSPID}`":`""+$Results.DisplayName+"`"}"                 
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
    $pm= $pm -replace "----"," "
    $pm= $pm  -replace "---","{"
    $pm= $pm -replace "--" , "}"
    if ($tip -match "InstallDate"){
        $temp=(Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*  | Where-Object { $_.PSChildName -eq $pm } |Select-Object $tip).$($tip)
        if ($temp -ne $null){
            (($temp[6,7] -join ""),($temp[4,5] -join ""),($temp[0..3] -join "") -join  "/")
         }else{
            Write-Host "Data nao informada"
         }
         
    }else{
	   (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*  | Where-Object { $_.PSChildName -eq $pm } |Select-Object $tip).$($tip)
    }
}