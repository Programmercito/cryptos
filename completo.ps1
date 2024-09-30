# Lista de direcciones IP de servidores VPN
$vpnServers = @(
    "219.100.37.201", "219.100.37.169", "219.100.37.49", "219.100.37.5", "219.100.37.8",
    "219.100.37.54", "219.100.37.32", "219.100.37.26", "219.100.37.53", "219.100.37.123",
    "123.195.133.10", "219.100.37.206", "123.198.244.25", "107.172.76.139", "173.198.248.39",
    "1.66.34.6", "211.224.135.147", "217.138.212.58", "121.131.200.107"
)

# Función para crear, conectar y eliminar una conexión VPN
function Manage-VpnConnection {
    param (
        [string]$serverIp
    )

    $vpnName = "VPN-$serverIp"


    try {
        # Crear la conexión VPN
        Add-VpnConnection -Name $vpnName -ServerAddress $serverIp -TunnelType "L2tp" -L2tpPsk "vpn" -AuthenticationMethod MSChapv2 -EncryptionLevel Required -RememberCredential -Force

        $result = rasdial $vpnName "vpn" "vpn"

        # Verificar si la conexión fue exitosa
        Write-Output "resultado: "+$result
        if ($result -match "Conectado correctamente a VPN" -or $result -match "Successfully") {
            Write-Output "Conexión a la VPN exitosa."
            # Ejecutar el script (asumiendo que está en el mismo directorio)
            &.\crypto.ps1
        } else {
            Write-Output "Error al conectar a la VPN. No se ejecutará el script."
        }
        # Desconectar la VPN
        rasdial $vpnName /disconnect

        # Eliminar la conexión VPN
        Remove-VpnConnection -Name $vpnName -Force
    }
    catch {
        Write-Error "Error al manejar la conexión VPN para $serverIp : $_"
    }
}

# Bucle infinito
while ($true) {
    # Iterar sobre cada servidor VPN
    foreach ($server in $vpnServers) {
        Write-Output "Procesando servidor: $server"
        Manage-VpnConnection -serverIp $server
    }
    # Esperar una hora (3600 segundos)
    Write-Output "Esperando una hora antes de volver a ejecutar..."
    Start-Sleep -Seconds 3600
}

Write-Output "Proceso completado para todos los servidores."