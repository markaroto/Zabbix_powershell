param(
    [string]$vm,
    [string]$tip
)
if ( [string]::IsNullOrEmpty($vm)){
	#$params=New-Object System.Collections.Hashtable
	$vmtemp=get-vm | Select-Object @{name='{#FSVM}';expression={$_.VMId.guid}},@{name='{#FSVMNAME}';expression={$_.VMName}}
	#$params.Add('data',$vmtemp)
	#$params | ConvertTo-Json
    write-host "{"
    write-host " `"data`":["
    write-host      
    #write-host $Results
               
       
    $n = ($vmtemp | measure).Count

            foreach ($Results in $vmtemp ) {
                $line = " { `"{#FSVM}`":`""+$Results.'{#FSVM}'+"`","
                $line += "`"{#FSVMNAME}`":`""+$Results.'{#FSVMNAME}'+"`"}" 
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
	(get-vm -id $vm | Measure-VM |select $tip).$($tip)
}