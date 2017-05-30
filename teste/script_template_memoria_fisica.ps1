param(
    [string]$idMemoria,
    [string]$tip
)
if ( [string]::IsNullOrEmpty($idMemoria)){
	#$params=New-Object System.Collections.Hashtable
	$memoria=Get-WmiObject Win32_PhysicalMemory | Select-Object @{name='{#FSMI}';expression={$_.DeviceLocator}},@{name='{#FSMNAME}';expression={$_.BankLabel}}
	#$params.Add('data',$memoria)
	#$params | ConvertTo-Json 
    write-host "{"
    write-host " `"data`":["
    write-host      
    #write-host $Results
               
       
    $n = ($memoria | measure).Count

            foreach ($Results in $memoria ) {
                $line = " { `"{#FSMI}`":`""+$Results.'{#FSMI}'+"`","
                $line += "`"{#FSMNAME}`":`""+$Results.'{#FSMNAME}'+"`"}" 
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
	(Get-WmiObject Win32_PhysicalMemory | Where-Object {$_.DeviceLocator -match $idMemoria} | select-object $tip ).$($tip)	
}

function ConvertTo-Json20([object] $item){
    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer
    return $ps_js.Serialize($item)
}