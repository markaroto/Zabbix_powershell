param(
    [string]$vm,
    [string]$tip
)
if ( [string]::IsNullOrEmpty($vm)){
	$params=New-Object System.Collections.Hashtable
	$vmtemp=get-vm | Select-Object @{name='{#FSVM}';expression={$_.VMId.guid}},@{name='{#FSVMNAME}';expression={$_.VMName}}
	$params.Add('data',$vmtemp)
	$params | ConvertTo-Json 
}else{
	(get-vm -id $vm | Measure-VM |select $tip).$($tip)
}