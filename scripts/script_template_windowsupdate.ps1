param(
    [string]$kb,[string]$tip
)
if ( [string]::IsNullOrEmpty($kb)){ 
    $update=[activator]::CreateInstance([type]::GetTypeFromProgID("microsoft.update.session"))
    $search=$update.CreateUpdateSearcher()
    $todos=$search.QueryHistory(0,$($search.GetTotalHistoryCount()))
    $wp=$todos | Select-Object @{name="hotfixid";expression={$_.title -match "KB(\d+)"| Out-Null; $Matches[0]}}  | Where-Object {$_.hotfixid -notlike "" } | Select-Object -Unique hotfixid

    #$wp= Get-WmiObject -class win32_quickfixengineering | Select-Object hotfixid |Select-Object -Unique hotfixid
	
	write-host "{"
    write-host " `"data`":["
    write-host      
    #write-host $Results
    $n = ($wp | measure).Count
            foreach ($Results in $wp ) {
                $line = " { `"{#WUPDATE}`":`""+$Results.hotfixid+"`"}"                 
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
    $update=[activator]::CreateInstance([type]::GetTypeFromProgID("microsoft.update.session"))
    $search=$update.CreateUpdateSearcher()
    $todos=$search.QueryHistory(0,$($search.GetTotalHistoryCount()))
    ($todos | Where-Object {$_.title -match $kb } | Sort-Object date -Descending | Select-Object -Index 0 | Select-Object $tip).$($tip) 
}