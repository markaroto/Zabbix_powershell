param(
    [string]$idMemoria,
    [string]$tip
)
if ( [string]::IsNullOrEmpty($idMemoria)){
	$params=New-Object System.Collections.Hashtable
	$memoria=Get-WmiObject Win32_PhysicalMemory | Select-Object @{name='{#FSMI}';expression={$_.DeviceLocator}},@{name='{#FSMNAME}';expression={$_.BankLabel}}
	$params.Add('data',$memoria)
	$params | ConvertTo-Json 
}else{
	(Get-WmiObject Win32_PhysicalMemory | Where-Object {$_.DeviceLocator -match $idMemoria} | select-object $tip ).$($tip)	
}