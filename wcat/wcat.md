# Wcat

Este laboratorio consiste en programar `wcat`, una versión simplificada del comando `cat` de UNIX en lenguaje C.

## Resumen del Proyecto

El objetivo es crear un ejecutable que lea archivos y muestre su contenido en la terminal. Para ello, se deben utilizar las funciones de la biblioteca estándar `stdio.h`: **`fopen()`** para abrir el archivo, **`fgets()`** para leer el contenido línea por línea en un buffer, y **`fclose()`** para cerrar el flujo. Es fundamental realizar el manejo de errores verificando si `fopen()` devuelve `NULL` y consultando las páginas de manual (`man`) para entender el comportamiento de estas rutinas.

---

## Detalles de la implementación

1. El programa `wcat` puede invocarse con uno o más archivos en la línea de comandos. Para el caso, solo tiene que imprimir cada archivo por turno.
2. Todos los casos que no generen error, `wcat` debería salir con el código de estado 0, normalmente devolviendo un 0 desde `main()` (o llamando a `exit(0)`).
3. Si no se especifican archivos en la línea de comandos, `wcat` debería salir y devolver 0. Tenga en cuenta que esto es ligeramente diferente al comportamiento del comando `cat` de UNIX normal.
4. Si el programa intenta abrir un archivo y falla, debe imprimir el mensaje exacto `wcat: cannot open file` (seguido de una nueva línea) y salir con el código de estado 1.
5. Si se especifican varios archivos en la línea de comandos, los archivos deben imprimirse en orden hasta que se llegue al final de la lista de archivos o se llegue a un error al abrir un archivo de dicha lista (en dicho momento se debe imprimir el mensaje de error y salir de `wcat`).

## Ejecución

### Compilación manual con `gcc`

Desde el directorio `wcat/`, compila el programa con:

```bash
gcc -Wall -Wextra -std=c99 -o wcat wcat.c
```

Una vez compilado, puedes ejecutarlo de las siguientes maneras:

```bash
# Mostrar el contenido de un archivo
./wcat archivo.txt

# Mostrar múltiples archivos en orden
./wcat archivo1.txt archivo2.txt

# Sin argumentos (sale con código 0, sin output)
./wcat

# Archivo inexistente (imprime error y sale con código 1)
./wcat no_existe.txt
```

---

### Ejecución con `test.sh`

El script `test.sh` compila automáticamente el programa, crea archivos de prueba temporales, ejecuta 7 pruebas y limpia los archivos generados.

```bash
# Dar permisos de ejecución (solo la primera vez)
chmod +x test.sh

# Ejecutar todas las pruebas
./test.sh
```

Las pruebas cubren: un solo archivo, múltiples archivos, sin argumentos, archivo inexistente, error en medio de una lista, líneas largas (buffer) y verificación del mensaje de error exacto.