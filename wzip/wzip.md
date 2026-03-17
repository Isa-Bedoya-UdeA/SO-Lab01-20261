# Wzip

Es una herramienta de compresión que utiliza el algoritmo **Run-Length Encoding (RLE)**. Detecta secuencias de caracteres idénticos y las reemplaza por el número de repeticiones seguido del carácter. La salida se escribe en el formato binario específico detallado abajo.

## Detalles de implementación (wzip)

1. La invocación correcta permitira pasar uno o mas archivos a traves de la linea de comandos al programa. Si no se especifican archivos, el programa debera salir empleando la llamada exit con codigo de retorno 1, no sin antes imprimir ”wzip: file1 [file2 ...]” (seguido por una nueva linea).
2. El formato del archivo comprimido debe coincidir con la descripción de arriba exactamente (un entero de 4-bytes seguiro por un caracter).
3. Tenga en cuenta que si se pasan varios archivos a wzip, estos se comprimen en una única salida comprimida y, cuando se descomprimen, estos se convertiran en una única secuencia de texto sin comprimir (por lo tanto, se pierde la información de que varios archivos se ingresaron originalmente en wzip).

---

## Ejecución

### Compilación manual con `gcc`

Desde el directorio `wzip/`, compila el programa con:

```bash
gcc -Wall -Wextra -std=c99 -o wzip wzip.c
```

La salida de `wzip` es binaria (formato RLE), por lo que debe redirigirse a un archivo `.z`:

```bash
# Comprimir un archivo (salida binaria → redirigir a .z)
./wzip archivo.txt > archivo.z

# Comprimir múltiples archivos en una sola salida comprimida
./wzip archivo1.txt archivo2.txt > salida.z

# Sin argumentos (imprime uso y sale con código 1)
./wzip

# Archivo inexistente (imprime error y sale con código 1)
./wzip no_existe.txt > salida.z
```

> **Nota:** la salida comprimida puede descomprimirse con `wunzip` para verificar el round-trip.

---

### Ejecución con `wzip_test.sh`

El script `wzip_test.sh` compila automáticamente el programa, crea archivos de prueba, ejecuta 6 pruebas y limpia los archivos generados.

```bash
# Dar permisos de ejecución (solo la primera vez)
chmod +x wzip_test.sh

# Ejecutar todas las pruebas
./wzip_test.sh
```

Las pruebas cubren: sin argumentos, archivo inexistente, compresión básica (verifica tamaño en bytes del archivo `.z`), caracteres sin repetición, múltiples archivos comprimidos en una sola salida y verificación del código de salida 0.
