param(
    [string]$vm,
    [string]$tip
)
if ( $vm -eq $null){
	$params=New-Object System.Collections.Hashtable
	$teste=get-vm | Select-Object @{name='{#FSVM}';expression={$_.VMId.guid}},@{name='{#FSVMNAME}';expression={$_.VMName}}
	$params.Add('data',$teste)
	$params | ConvertTo-Json 
}else{
	(get-vm -id $vm | Measure-VM |select $tip).$($tip)
}