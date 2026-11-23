#!/bin/bash
# menu_comidas.sh - Menú de comidas con case

while true; do
  echo "=============================="
  echo "        MENÚ DE COMIDAS"
  echo "=============================="
  echo "1) Hamburguesa  - \$5.00"
  echo "2) Pizza        - \$7.50"
  echo "3) Encebollado  - \$4.00"
  echo "4) Salchipapa   - \$3.00"
  echo "5) Salir"
  echo "------------------------------"
  read -p "Elige una opción [1-5]: " opcion

  case $opcion in
    1) echo "Pediste una Hamburguesa. Total: \$5.00" ;;
    2) echo "Pediste una Pizza. Total: \$7.50" ;;
    3) echo "Pediste un Encebollado. Total: \$4.00" ;;
    4) echo "Pediste una Salchipapa. Total: \$3.00" ;;
    5) echo "¡Gracias por tu visita!"; exit 0 ;;
    *) echo "Opción no válida" ;;
  esac
  echo
done
