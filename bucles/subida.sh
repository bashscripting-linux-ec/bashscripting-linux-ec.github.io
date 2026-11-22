#!/bin/bash
# Suma de dos números ingresados por el usuario

read -p "Ingresa el primer número: " num1
read -p "Ingresa el segundo número: " num2

suma=$(( num1 + num2 ))

echo "La suma de $num1 + $num2 es: $suma"
