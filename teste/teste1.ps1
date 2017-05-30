param(
    [string]$vm,
    [string]$tip
)
(get-vm -id $vm | Measure-VM |select $tip).$($tip)