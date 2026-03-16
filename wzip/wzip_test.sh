#!/bin/bash

# ============================================
# Script de pruebas para wzip
# ============================================

# Colores para salida en consola
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir encabezados
print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Función para imprimir éxito
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Función para imprimir error
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ============================================
# 1. Compilación
# ============================================
print_header "Compilando wzip"
gcc -Wall -Wextra -std=c99 -o wzip wzip.c
if [ $? -ne 0 ]; then
    print_error "Error de compilación"
    exit 1
fi
print_success "Compilación exitosa"
echo

# ============================================
# 2. Creación de archivos de prueba
# ============================================
print_header "Creando archivos de prueba"

printf "aaaaaaaaaabbbb" > simple.txt
print_success "simple.txt creado"

printf "aaabbc\ndddeee" > multiline.txt
print_success "multiline.txt creado"

printf "abcdef" > norepeat.txt
print_success "norepeat.txt creado"

printf "aaaa" > file1.txt
printf "bbbb" > file2.txt
print_success "file1.txt y file2.txt creados"
echo

# ============================================
# 3. Ejecución de pruebas
# ============================================

# Prueba 1: Sin argumentos (debe mostrar error y exit 1)
print_header "Prueba 1: Sin argumentos"
OUTPUT=$(./wzip 2>&1)
RESULT=$?
echo "$OUTPUT"
if [ $RESULT -eq 1 ] && [[ "$OUTPUT" == *"wzip: file1 [file2 ...]"* ]]; then
    print_success "Mensaje y código de salida correctos"
else
    print_error "Error: mensaje o código incorrecto (RESULT=$RESULT)"
fi
echo

# Prueba 2: Archivo no existe (debe mostrar error y exit 1)
print_header "Prueba 2: Archivo no existe"
OUTPUT=$(./wzip no_existe.txt 2>&1)
RESULT=$?
echo "$OUTPUT"
if [ $RESULT -eq 1 ] && [[ "$OUTPUT" == *"wzip: cannot open file"* ]]; then
    print_success "Mensaje y código de salida correctos"
else
    print_error "Error: mensaje o código incorrecto (RESULT=$RESULT)"
fi
echo

# Prueba 3: Compresión básica - verificar tamaño del archivo comprimido
print_header "Prueba 3: Compresión básica (aaaaaaaaaabbbb)"
./wzip simple.txt > simple.z
BYTES=$(wc -c < simple.z)
# Esperado: 2 entradas x 5 bytes = 10 bytes
if [ "$BYTES" -eq 10 ]; then
    print_success "Tamaño correcto: $BYTES bytes (2 entradas x 5 bytes)"
else
    print_error "Tamaño incorrecto: esperado 10 bytes, obtenido $BYTES bytes"
fi
echo

# Prueba 4: Sin repeticiones - cada carácter es su propia entrada
print_header "Prueba 4: Sin caracteres repetidos (abcdef)"
./wzip norepeat.txt > norepeat.z
BYTES=$(wc -c < norepeat.z)
# Esperado: 6 entradas x 5 bytes = 30 bytes
if [ "$BYTES" -eq 30 ]; then
    print_success "Tamaño correcto: $BYTES bytes (6 entradas x 5 bytes)"
else
    print_error "Tamaño incorrecto: esperado 30 bytes, obtenido $BYTES bytes"
fi
echo

# Prueba 5: Múltiples archivos comprimidos en una sola salida
print_header "Prueba 5: Múltiples archivos (aaaa + bbbb = 8a seguidos no, son distintos archivos)"
./wzip file1.txt file2.txt > multi.z
BYTES=$(wc -c < multi.z)
# file1=aaaa(1 entrada), file2=bbbb(1 entrada) pero RLE cruza archivos: aaaa+bbbb = 2 entradas = 10 bytes
if [ "$BYTES" -eq 10 ]; then
    print_success "Tamaño correcto: $BYTES bytes (2 entradas x 5 bytes)"
else
    print_error "Tamaño incorrecto: esperado 10 bytes, obtenido $BYTES bytes"
fi
echo

# Prueba 6: Exit code 0 en caso exitoso
print_header "Prueba 6: Código de salida en éxito"
./wzip simple.txt > /dev/null
RESULT=$?
if [ $RESULT -eq 0 ]; then
    print_success "Código de salida correcto (0)"
else
    print_error "Código de salida inesperado: $RESULT"
fi
echo

# ============================================
# 4. Limpieza
# ============================================
print_header "Limpieza"
rm -f simple.txt simple.z multiline.txt norepeat.txt norepeat.z file1.txt file2.txt multi.z
print_success "Archivos de prueba eliminados"
echo

# ============================================
# 5. Resumen
# ============================================
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Todas las pruebas completadas! 🎉   ${NC}"
echo -e "${GREEN}========================================${NC}"
