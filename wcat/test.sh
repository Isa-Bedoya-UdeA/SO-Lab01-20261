#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Compilando wcat ===${NC}"
gcc -Wall -Wextra -std=c99 -o wcat wcat.c
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error de compilación${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Compilación exitosa${NC}\n"

# Crear archivos de prueba
cat > example.txt << 'EOF'
Esta es la primera línea del archivo example.txt
Segunda línea con contenido de prueba
Tercera línea: probando wcat
Cuarta línea - fin del archivo
EOF

cat > example2.txt << 'EOF'
=== Archivo 2 ===
Línea A del segundo archivo
Línea B del segundo archivo
=== Fin Archivo 2 ===
EOF

python3 -c "print('x' * 5000)" > longline.txt

echo -e "${YELLOW}=== Prueba 1: Un solo archivo ===${NC}"
./wcat example.txt
echo -e "${GREEN}✓ Prueba 1 completada${NC}\n"

echo -e "${YELLOW}=== Prueba 2: Múltiples archivos ===${NC}"
./wcat example.txt example2.txt
echo -e "${GREEN}✓ Prueba 2 completada${NC}\n"

echo -e "${YELLOW}=== Prueba 3: Sin argumentos (exit 0) ===${NC}"
./wcat
RESULT=$?
if [ $RESULT -eq 0 ]; then
    echo -e "${GREEN}✓ Prueba 3: Código de salida correcto ($RESULT)${NC}"
else
    echo -e "${RED}❌ Prueba 3: Esperado 0, obtenido $RESULT${NC}"
fi
echo

echo -e "${YELLOW}=== Prueba 4: Archivo no existe (exit 1) ===${NC}"
./wcat no_existe.txt 2>&1
RESULT=$?
if [ $RESULT -eq 1 ]; then
    echo -e "${GREEN}✓ Prueba 4: Código de salida correcto ($RESULT)${NC}"
else
    echo -e "${RED}❌ Prueba 4: Esperado 1, obtenido $RESULT${NC}"
fi
echo

echo -e "${YELLOW}=== Prueba 5: Error en medio de lista ===${NC}"
OUTPUT=$(./wcat example.txt no_existe.txt example2.txt 2>&1)
RESULT=$?
if [ $RESULT -eq 1 ] && echo "$OUTPUT" | grep -q "wcat: cannot open file"; then
    echo -e "${GREEN}✓ Prueba 5: Error manejado correctamente${NC}"
    # Verificar que example2.txt NO se imprimió
    if ! echo "$OUTPUT" | grep -q "Archivo 2"; then
        echo -e "${GREEN}✓ Prueba 5: Programa se detuvo tras el error${NC}"
    else
        echo -e "${RED}❌ Prueba 5: example2.txt no debería imprimirse${NC}"
    fi
else
    echo -e "${RED}❌ Prueba 5: Falló${NC}"
fi
echo

echo -e "${YELLOW}=== Prueba 6: Líneas largas (buffer) ===${NC}"
BYTES=$(./wcat longline.txt | wc -c)
if [ "$BYTES" -eq 5001 ]; then
    echo -e "${GREEN}✓ Prueba 6: Buffer maneja líneas largas ($BYTES bytes)${NC}"
else
    echo -e "${RED}❌ Prueba 6: Esperado 5001 bytes, obtenido $BYTES${NC}"
fi
echo

echo -e "${YELLOW}=== Prueba 7: Mensaje de error exacto ===${NC}"
ERROR_MSG=$(./wcat no_existe.txt 2>&1)
if [ "$ERROR_MSG" = "wcat: cannot open file" ]; then
    echo -e "${GREEN}✓ Prueba 7: Mensaje de error exacto${NC}"
else
    echo -e "${RED}❌ Prueba 7: Mensaje incorrecto: '$ERROR_MSG'${NC}"
fi
echo

# Limpieza
rm -f example.txt example2.txt longline.txt

echo -e "${GREEN}=== Todas las pruebas completadas ===${NC}"