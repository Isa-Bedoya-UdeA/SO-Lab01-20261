#!/bin/bash

# ============================================
# Script de pruebas para wunzip
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
print_header "Compilando wunzip"
gcc -Wall -Wextra -std=c99 -o wunzip wunzip.c
if [ $? -ne 0 ]; then
    print_error "Error de compilación"
    exit 1
fi
print_success "Compilación exitosa"
echo

# Compilar wzip también para generar archivos comprimidos de prueba
gcc -Wall -Wextra -std=c99 -o wzip ../wzip/wzip.c 2>/dev/null
if [ $? -ne 0 ]; then
    print_error "No se pudo compilar wzip (necesario para las pruebas)"
    exit 1
fi

# ============================================
# 2. Creación de archivos de prueba
# ============================================
print_header "Creando archivos de prueba"

printf "aaaaaaaaaabbbb" > simple.txt
./wzip simple.txt > simple.z
print_success "simple.z creado"

printf "aaabbc\ndddeee" > multiline.txt
./wzip multiline.txt > multiline.z
print_success "multiline.z creado"

printf "abcdef" > norepeat.txt
./wzip norepeat.txt > norepeat.z
print_success "norepeat.z creado"

printf "aaaa" > file1.txt
printf "bbbb" > file2.txt
./wzip file1.txt file2.txt > multi.z
print_success "multi.z creado"
echo

# ============================================
# 3. Ejecución de pruebas
# ============================================

# Prueba 1: Sin argumentos (debe mostrar error y exit 1)
print_header "Prueba 1: Sin argumentos"
OUTPUT=$(./wunzip 2>&1)
RESULT=$?
echo "$OUTPUT"
if [ $RESULT -eq 1 ] && [[ "$OUTPUT" == *"wunzip: file1 [file2 ...]"* ]]; then
    print_success "Mensaje y código de salida correctos"
else
    print_error "Error: mensaje o código incorrecto (RESULT=$RESULT)"
fi
echo

# Prueba 2: Archivo no existe (debe mostrar error y exit 1)
print_header "Prueba 2: Archivo no existe"
OUTPUT=$(./wunzip no_existe.z 2>&1)
RESULT=$?
echo "$OUTPUT"
if [ $RESULT -eq 1 ] && [[ "$OUTPUT" == *"wunzip: cannot open file"* ]]; then
    print_success "Mensaje y código de salida correctos"
else
    print_error "Error: mensaje o código incorrecto (RESULT=$RESULT)"
fi
echo

# Prueba 3: Round-trip básico (comprimir y descomprimir da el original)
print_header "Prueba 3: Round-trip básico (aaaaaaaaaabbbb)"
OUTPUT=$(./wunzip simple.z)
if [ "$OUTPUT" = "aaaaaaaaaabbbb" ]; then
    print_success "Descompresión correcta: '$OUTPUT'"
else
    print_error "Descompresión incorrecta: '$OUTPUT'"
fi
echo

# Prueba 4: Round-trip con múltiples líneas
print_header "Prueba 4: Round-trip con múltiples líneas"
ORIGINAL=$(cat multiline.txt)
OUTPUT=$(./wunzip multiline.z)
if [ "$OUTPUT" = "$ORIGINAL" ]; then
    print_success "Descompresión correcta"
else
    print_error "Descompresión incorrecta"
    echo "Esperado: '$ORIGINAL'"
    echo "Obtenido: '$OUTPUT'"
fi
echo

# Prueba 5: Round-trip sin caracteres repetidos
print_header "Prueba 5: Round-trip sin caracteres repetidos (abcdef)"
OUTPUT=$(./wunzip norepeat.z)
if [ "$OUTPUT" = "abcdef" ]; then
    print_success "Descompresión correcta: '$OUTPUT'"
else
    print_error "Descompresión incorrecta: '$OUTPUT'"
fi
echo

# Prueba 6: Round-trip múltiples archivos comprimidos juntos
print_header "Prueba 6: Round-trip múltiples archivos (aaaa + bbbb)"
OUTPUT=$(./wunzip multi.z)
if [ "$OUTPUT" = "aaaabbbb" ]; then
    print_success "Descompresión correcta: '$OUTPUT'"
else
    print_error "Descompresión incorrecta: '$OUTPUT'"
fi
echo

# Prueba 7: Exit code 0 en caso exitoso
print_header "Prueba 7: Código de salida en éxito"
./wunzip simple.z > /dev/null
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
rm -f simple.txt simple.z multiline.txt multiline.z norepeat.txt norepeat.z file1.txt file2.txt multi.z wzip
print_success "Archivos de prueba eliminados"
echo

# ============================================
# 5. Resumen
# ============================================
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Todas las pruebas completadas! 🎉   ${NC}"
echo -e "${GREEN}========================================${NC}"
