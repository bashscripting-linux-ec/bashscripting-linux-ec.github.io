#!/bin/bash
#Fernando Guarderas

#Literal1
if [ $# -ne 5 ]
then
    echo "Uso: bash $0 <red/CIDR> <comunidad> <nodo1> <nodo2> <nodo3>"
    exit 1
fi

red=$1
comunidad=$2
nodo1=$3
nodo2=$4
nodo3=$5

echo "Buscando hosts activos en la red $red ..."
hosts=$(nmap -sn -n $red | grep "report for" | cut -d " " -f 5)

if [ -z "$hosts" ]
then
    echo "No se encontraron hosts activos"
else
    echo "Direcciones IP activas:"
    for h in $hosts
    do
        echo "$h"
    done
fi

#Literal2
while true
do
    echo ""
    echo "NMS EPN"
    echo "a) Deteccion de servicios"
    echo "b) Modificacion de MIBs"
    echo "c) Salida"
    read -p "Elija una opcion: " opcion

    case $opcion in
        a|A)
            #Literal3
            read -p "Ingrese una IP activa: " ip
            encontrado=0
            for h in $hosts
            do
                if [ "$h" = "$ip" ]
                then
                    encontrado=1
                fi
            done

            if [ $encontrado -eq 0 ]
            then
                echo "La IP no esta en la lista de hosts activos"
            else
                echo "Escaneando servicios de $ip ..."
                echo "------------------------------"
                printf "%-20s %-10s\n" "SERVICIO" "PUERTO"
                echo "------------------------------"
                nmap -n $ip | grep "/tcp" | grep " open " | while read puerto estado servicio
                do
                    numero=$(echo $puerto | cut -d "/" -f 1)
                    printf "%-20s %-10s\n" "$servicio" "$numero"
                done
                echo "------------------------------"
            fi
            ;;
        b|B)
            #Literal4
            read -p "Ingrese una IP activa: " ip
            encontrado=0
            for h in $hosts
            do
                if [ "$h" = "$ip" ]
                then
                    encontrado=1
                fi
            done

            if [ $encontrado -eq 0 ]
            then
                echo "La IP no esta en la lista de hosts activos"
            else
                seguir="s"
                while [ "$seguir" = "s" ]
                do
                    echo ""
                    echo "Objetos MIB:"
                    echo "1) $nodo1"
                    echo "2) $nodo2"
                    echo "3) $nodo3"
                    read -p "Elija el objeto MIB a modificar: " num

                    nodo=""
                    case $num in
                        1) nodo=$nodo1 ;;
                        2) nodo=$nodo2 ;;
                        3) nodo=$nodo3 ;;
                        *) echo "Opcion no valida" ;;
                    esac

                    if [ "$nodo" != "" ]
                    then
                        echo "Valores actuales de $nodo:"
                        snmpwalk -v2c -c $comunidad $ip $nodo

                        echo "1) Objeto escalar"
                        echo "2) Objeto no escalar (tabla)"
                        read -p "Elija la clase de objeto: " clase

                        if [ "$clase" = "1" ]
                        then
                            oid="$nodo.0"
                        else
                            read -p "Ingrese el indice de la instancia: " indice
                            oid="$nodo.$indice"
                        fi

                        echo "Tipos de datos:"
                        echo "1) INTEGER"
                        echo "2) UNSIGNED / GAUGE32"
                        echo "3) STRING"
                        echo "4) HEX STRING"
                        echo "5) DECIMAL STRING"
                        echo "6) OBJECT IDENTIFIER"
                        echo "7) TIMETICKS"
                        echo "8) IPADDRESS"
                        echo "9) BITS"
                        read -p "Elija el tipo de dato: " td

                        tipo=""
                        case $td in
                            1) tipo="i" ;;
                            2) tipo="u" ;;
                            3) tipo="s" ;;
                            4) tipo="x" ;;
                            5) tipo="d" ;;
                            6) tipo="o" ;;
                            7) tipo="t" ;;
                            8) tipo="a" ;;
                            9) tipo="b" ;;
                            *) echo "Tipo de dato no valido" ;;
                        esac

                        if [ "$tipo" != "" ]
                        then
                            read -p "Ingrese el nuevo valor: " valor
                            snmpset -v2c -c $comunidad $ip $oid $tipo "$valor"
                            if [ $? -eq 0 ]
                            then
                                echo "Objeto modificado correctamente"
                                echo "Nuevo valor:"
                                snmpget -v2c -c $comunidad $ip $oid
                            else
                                echo "No se pudo modificar el objeto"
                            fi
                        fi
                    fi

                    read -p "Desea modificar otro objeto MIB? (s/n): " seguir
                done
            fi
            ;;
        c|C)
            #Literal5
            echo "Saliendo del script..."
            exit 0
            ;;
        *)
            echo "Opcion no valida"
            ;;
    esac
done
