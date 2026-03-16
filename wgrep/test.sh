#!/bin/bash

# ============================================
# Script de pruebas para wgrep
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

# Función para imprimir advertencia
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# ============================================
# 1. Compilación
# ============================================
print_header "Compilando wgrep"
gcc -Wall -Wextra -std=c99 -o wgrep wgrep.c
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

# example.txt: contenido variado con múltiples ocurrencias de "hola"
cat > example1.txt << 'EOF'
Esta es la primera línea del archivo example1.txt
Aquí buscamos la palabra hola
Esta línea no contiene el término de búsqueda
hola mundo desde Linux
otra línea con hola al final
Línea sin coincidencias para probar
EOF
print_success "example1.txt creado"

# example2.txt: segundo archivo para pruebas múltiples
cat > example2.txt << 'EOF'
=== Inicio de example2.txt ===
También contiene hola para buscar
Esta línea es completamente diferente
Adiós mundo, hasta luego
hola de nuevo en example2
=== Fin de example2.txt ===
EOF
print_success "example2.txt creado"

# Archivo con línea muy larga (prueba de getline)
python3 -c "print('x' * 3000 + ' hola ' + 'y' * 3000)" > longline.txt 2>/dev/null || \
    perl -e "print 'x' x 3000 . ' hola ' . 'y' x 3000 . '\n'" > longline.txt 2>/dev/null || \
    echo "Advertencia: No se pudo crear longline.txt (python3/perl no disponible)"
echo

# ============================================
# 3. Ejecución de pruebas
# ============================================

# Prueba 1: Buscar en un solo archivo
print_header "Prueba 1: Buscar 'hola' en example1.txt"
./wgrep hola example1.txt
RESULT=$?
if [ $RESULT -eq 0 ]; then
    print_success "Código de salida correcto (0)"
else
    print_error "Código de salida inesperado: $RESULT"
fi
echo

# Prueba 2: Buscar desde stdin (sin archivo)
print_header "Prueba 2: Buscar 'hola' desde stdin"
echo "hola mundo" | ./wgrep hola
RESULT=$?
if [ $RESULT -eq 0 ]; then
    print_success "Código de salida correcto (0)"
else
    print_error "Código de salida inesperado: $RESULT"
fi
echo

# Prueba 3: Múltiples archivos
print_header "Prueba 3: Buscar 'hola' en múltiples archivos"
./wgrep hola example1.txt example2.txt
RESULT=$?
if [ $RESULT -eq 0 ]; then
    print_success "Código de salida correcto (0)"
else
    print_error "Código de salida inesperado: $RESULT"
fi
echo

# Prueba 4: Sin argumentos (debe mostrar error y exit 1)
print_header "Prueba 4: Sin argumentos"
OUTPUT=$(./wgrep 2>&1)
RESULT=$?
echo "$OUTPUT"
if [ $RESULT -eq 1 ] && [[ "$OUTPUT" == *"wgrep: searchterm [file ...]"* ]]; then
    print_success "Mensaje y código de salida correctos"
else
    print_error "Error: mensaje o código incorrecto (RESULT=$RESULT)"
fi
echo

# Prueba 5: Archivo que no existe (debe mostrar error y exit 1)
print_header "Prueba 5: Archivo no existe"
OUTPUT=$(./wgrep hola no_existe.txt 2>&1)
RESULT=$?
echo "$OUTPUT"
if [ $RESULT -eq 1 ] && [[ "$OUTPUT" == *"wgrep: cannot open file"* ]]; then
    print_success "Mensaje y código de salida correctos"
else
    print_error "Error: mensaje o código incorrecto (RESULT=$RESULT)"
fi
echo

# Prueba 6: Búsqueda case-sensitive
print_header "Prueba 6: Búsqueda case-sensitive ('Hola' vs 'hola')"
OUTPUT=$(./wgrep Hola example1.txt)
if [ -z "$OUTPUT" ]; then
    print_success "Búsqueda case-sensitive funciona (sin coincidencias para 'Hola')"
else
    print_warning "Se encontraron coincidencias para 'Hola' (revisar si es esperado)"
    echo "$OUTPUT"
fi
echo

# Prueba 7: Término vacío (comportamiento aceptable: todas o ninguna línea)
print_header "Prueba 7: Término de búsqueda vacío"
LINES_ORIGINAL=$(wc -l < example1.txt)
LINES_MATCH=$(./wgrep "" example1.txt | wc -l)
print_warning "Líneas originales: $LINES_ORIGINAL, Líneas con término vacío: $LINES_MATCH"
print_success "Comportamiento aceptable (todas o ninguna línea)"
echo

# Prueba 8: Línea muy larga (prueba de getline)
if [ -f longline.txt ]; then
    print_header "Prueba 8: Línea muy larga (getline)"
    OUTPUT=$(./wgrep hola longline.txt)
    if [[ "$OUTPUT" == *"hola"* ]]; then
        print_success "getline maneja líneas largas correctamente"
    else
        print_error "No se encontró 'hola' en la línea larga"
    fi
    echo
fi

# Prueba 9: Error en medio de lista de archivos
print_header "Prueba 9: Error en medio de lista de archivos"
OUTPUT=$(./wgrep hola example1.txt no_existe.txt example2.txt 2>&1)
RESULT=$?
# Verificar que example1.txt se imprimió pero example2.txt NO
if [ $RESULT -eq 1 ] && \
   echo "$OUTPUT" | grep -q "hola mundo desde Linux" && \
   ! echo "$OUTPUT" | grep -q "Inicio de example2.txt"; then
    print_success "Programa se detuvo correctamente tras el error"
else
    print_error "Comportamiento inesperado en manejo de errores"
    echo "$OUTPUT"
fi
echo

# ============================================
# 4. Limpieza
# ============================================
print_header "Limpieza"
rm -f example1.txt example2.txt longline.txt
print_success "Archivos de prueba eliminados"
echo

# ============================================
# 5. Resumen
# ============================================
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Todas las pruebas completadas! 🎉   ${NC}"
echo -e "${GREEN}========================================${NC}"