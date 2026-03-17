# Wuzip

Es la herramienta de descompresión encargada de realizar la operación opuesta a `wzip`. Lee un archivo comprimido en formato binario y reconstruye la secuencia de texto original enviándola a la salida estándar (`stdout`).

## Detalles de implementación (wunzip)

1. La invocación correcta permitira pasar uno o mas archivos a traves de la linea de comandos al programa. Si no se especifican archivos, el programa debera salir empleando la llamada exit con codigo de retorno 1, no sin antes imprimir ”wunzip: file1 [file2 ...]” (seguido por una nueva linea).
2. El formato del archivo comprimido debe coincidir con la descripción de arriba exactamente (un entero de 4-bytes seguiro por un caracter).
3. Tenga en cuenta que si se pasan varios archivos a wunzip, estos se convertiran en una única secuencia de texto sin comprimir. Lo mismo aplica para wzip.

---

## Ejecución

### Compilación manual con `gcc`

Desde el directorio `wunzip/`, compila el programa con:

```bash
gcc -Wall -Wextra -std=c99 -o wunzip wunzip.c
```

`wunzip` trabaja con archivos comprimidos generados por `wzip`. El flujo típico es:

```bash
# 1. Comprimir un archivo con wzip (compilar wzip primero si es necesario)
gcc -Wall -Wextra -std=c99 -o wzip ../wzip/wzip.c
./wzip archivo.txt > archivo.z

# 2. Descomprimir con wunzip
./wunzip archivo.z

# Descomprimir múltiples archivos (salida concatenada en stdout)
./wunzip archivo1.z archivo2.z

# Sin argumentos (imprime uso y sale con código 1)
./wunzip

# Archivo inexistente (imprime error y sale con código 1)
./wunzip no_existe.z
```

---

### Ejecución con `wunzip_test.sh`

El script `wunzip_test.sh` compila automáticamente `wunzip` **y** `wzip` (requerido para generar los archivos de prueba), ejecuta 7 pruebas y limpia los archivos generados.

```bash
# Dar permisos de ejecución (solo la primera vez)
chmod +x wunzip_test.sh

# Ejecutar todas las pruebas
./wunzip_test.sh
```

> **Requisito:** el script compila `../wzip/wzip.c` automáticamente para crear los archivos `.z` de prueba. Asegúrate de que `wzip.c` exista en el directorio hermano `wzip/`.

Las pruebas cubren: sin argumentos, archivo inexistente, round-trip básico, múltiples líneas, sin caracteres repetidos, múltiples archivos comprimidos juntos y verificación del código de salida 0.
