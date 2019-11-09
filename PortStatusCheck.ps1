$Server_Port_Details = import-csv Server_Port_Details.csv
$OutArray = @()
Import-Csv Server_Port_Details.csv |`
ForEach-Object { 
    try {
        $remote_host = $_.HostName
        $port = $_.port
        $socket = new-object System.Net.Sockets.TcpClient($remote_host, $port)
    } catch [Exception] {
        $status = "" | Select "HostName", "port", "status"
        $status.HostName = $remote_host
        $status.port = $port
        $status.status = "failed"
        Write-Host $status
        $outarray += $status
        $status = $null
        return
    }
    $status = "" | Select "HostName", "port", "status"
    $status.HostName = $remote_host
    $status.port = $port
    $status.status = "success"
    Write-Host $status
    $outarray += $status
    $status = $null
    return
}
$outarray | export-csv -path "status.csv" -NoTypeInformation