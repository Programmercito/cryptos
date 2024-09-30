#!/bin/bash

# Lista de direcciones IP de servidores VPN
vpnServers=(
    "219.100.37.201" "219.100.37.169" "219.100.37.49" "219.100.37.5" "219.100.37.8"
    "219.100.37.54" "219.100.37.32" "219.100.37.26" "219.100.37.53" "219.100.37.123"
    "123.195.133.10" "219.100.37.206" "123.198.244.25" "107.172.76.139" "173.198.248.39"
    "1.66.34.6" "211.224.135.147" "217.138.212.58" "121.131.200.107"
)

# Función para crear, conectar y eliminar una conexión VPN
manage_vpn_connection() {
    serverIp=$1
    vpnName="VPN-$serverIp"

    echo "Procesando servidor: $serverIp"

    # Crear la conexión VPN (comando de ejemplo, ajustar según el cliente VPN usado)
    nmcli con add type vpn con-name $vpnName ifname -- vpn-type l2tp vpn.data "gateway=$serverIp,ipsec-enabled=yes,ipsec-psk=vpn"

    # Conectar a la VPN
    result=$(nmcli con up id $vpnName)

    echo "resultado: $result"
    if [[ $result == *"conectado con éxito"* || $result == *"successfully"* ]]; then
        echo "Conexión a la VPN exitosa."
        # Ejecutar el script (asumiendo que está en el mismo directorio)
        ./crypto.sh
    else
        echo "Error al conectar a la VPN. No se ejecutará el script."
    fi

    # Desconectar la VPN
    nmcli con down id $vpnName

    # Eliminar la conexión VPN
    nmcli con delete id $vpnName
}

# Bucle infinito
while true; do
    # Iterar sobre cada servidor VPN
    for server in "${vpnServers[@]}"; do
        manage_vpn_connection $server
    done
    # Esperar una hora (3600 segundos)
    echo "Esperando una hora antes de volver a ejecutar..."
    sleep 3600
done

echo "Proceso completado para todos los servidores."
