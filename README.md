# SO - Lab01 - 20261

## Equipo

* Rafael Angel Alemán Castillo. [rafael.aleman@udea.edu.co](rafael.aleman@udea.edu.co). CC. 1001560844
* Isabela Bedoya Gaviria. [isabela.bedoya@udea.edu.co](isabela.bedoya@udea.edu.co). 1020106520

## Documentación

A continuación se documentan las funciones desarrolladas en cada programa:

### `wcat`

| Función                               | Descripción                                                                                                                                                                                                                                                                                                                            |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `int printFile(const char *filename)` | Abre el archivo indicado en modo lectura con `fopen()`. Lee su contenido línea por línea usando `fgets()` sobre un buffer de 4096 bytes e imprime cada línea en `stdout` con `printf()`. Cierra el archivo con `fclose()`. Retorna `0` en éxito o `1` si el archivo no pudo abrirse, imprimiendo `wcat: cannot open file` en `stderr`. |
| `int main(int argc, char *argv[])`    | Punto de entrada. Si no se recibe ningún argumento, retorna `0` inmediatamente. De lo contrario, llama a `printFile()` para cada archivo pasado en la línea de comandos, en orden. Si alguna llamada retorna error, el programa termina de inmediato con código `1`.                                                                   |

### `wgrep`

| Función                                                                                | Descripción                                                                                                                                                                                                                                                                                                                                         |
| -------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `void searchAndPrintLines(FILE *input_stream, const char *search_term)`                | Lee líneas de manera dinámica usando `getline()` (que redimensiona el buffer automáticamente para soportar líneas arbitrariamente largas). Por cada línea leída, usa `strstr()` para verificar si contiene el término de búsqueda (case-sensitive). Si hay coincidencia, imprime la línea con `printf()`. Libera la memoria del buffer al terminar. |
| `void reportErrorAndExit(const char *error_message)`                                   | Imprime un mensaje de error por `stdout` seguido de salto de línea y termina el programa con `exit(1)`.                                                                                                                                                                                                                                             |
| `void processInputSources(int arg_count, char *arg_vector[], const char *search_term)` | Determina la fuente de entrada: si solo se pasó el término de búsqueda (sin archivos), llama a `searchAndPrintLines()` sobre `stdin`. Si se especificaron archivos, los recorre en orden, abre cada uno con `fopen()` y llama a `searchAndPrintLines()`. Si algún archivo no puede abrirse, invoca `reportErrorAndExit()`.                          |
| `int main(int argc, char *argv[])`                                                     | Punto de entrada. Valida que se haya pasado al menos el término de búsqueda; si no, imprime el mensaje de uso `wgrep: searchterm [file ...]` y retorna `1`. En caso contrario, extrae el término y delega en `processInputSources()`.                                                                                                               |

### `wzip`

`wzip` no define funciones auxiliares; toda la lógica reside en `main`.

| Función                            | Descripción                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `int main(int argc, char *argv[])` | Valida que se haya pasado al menos un archivo; si no, imprime `wzip: file1 [file2 ...]` y termina con `exit(1)`. Mantiene dos variables de estado: `current_char` (carácter actual de la secuencia RLE) y `current_count` (número de repeticiones acumuladas). Lee carácter a carácter con `fgetc()` de cada archivo. Cuando el carácter cambia, escribe el par `(count, char)` en formato binario a `stdout` con `fwrite()` (entero de 4 bytes + carácter de 1 byte). Al terminar todos los archivos, escribe la última secuencia pendiente. Si algún archivo no puede abrirse, imprime `wzip: cannot open file` y termina con `exit(1)`. |

### `wunzip`

`wunzip` tampoco define funciones auxiliares; toda la lógica reside en `main`.

| Función                            | Descripción                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `int main(int argc, char *argv[])` | Valida que se haya pasado al menos un archivo; si no, imprime `wunzip: file1 [file2 ...]` en `stderr` y termina con `exit(1)`. Abre cada archivo en modo binario (`"rb"`) con `fopen()`. Lee pares `(count, char)` consecutivos usando `fread()` (4 bytes para el entero, 1 byte para el carácter). Por cada par, imprime el carácter `count` veces en `stdout` con `putchar()`. Cierra cada archivo con `fclose()` al terminar. Si algún archivo no puede abrirse, imprime `wunzip: cannot open file` en `stderr` y termina con `exit(1)`. |

---

## Problemas

El único problema significativo encontrado durante el desarrollo fue relacionado con el **formato de fin de línea de los archivos**. Los scripts de prueba (`.sh`) fueron creados y editados desde Windows, por lo que quedaron guardados con finales de línea **CRLF** (`\r\n`). Al intentar ejecutarlos en WSL (Linux), el sistema operativo interpretaba el carácter `\r` como parte del path del intérprete en la línea shebang (`#!/bin/bash\r`), generando el error:

```
-bash: ./test.sh: cannot execute: required file not found
```

**Solución:** se convirtieron todos los scripts al formato **LF** (`\n`) cambiando la configuración de fin de línea en el editor (VS Code: de `CRLF` a `LF`). De forma alternativa, el problema puede corregirse con el comando `dos2unix test.sh` o ejecutando el script directamente con `bash test.sh` para evitar que el shebang sea interpretado.

---

## Pruebas

Las pruebas se realizaron inicialmente de forma manual, ejecutando cada programa con distintos argumentos y verificando su salida y código de retorno directamente en la terminal. Posteriormente, los casos de prueba se consolidaron en scripts `.sh` que automatizan la compilación, la creación de archivos de entrada, la ejecución de los casos de prueba, la verificación de resultados y la limpieza de archivos temporales.

### `wcat` — `test.sh` (7 pruebas)

| #   | Prueba                      | Qué verifica                                                                       |
| --- | --------------------------- | ---------------------------------------------------------------------------------- |
| 1   | Un solo archivo             | Imprime correctamente el contenido de `example.txt`                                |
| 2   | Múltiples archivos          | Imprime `example.txt` y `example2.txt` en orden                                    |
| 3   | Sin argumentos              | El programa termina con código de salida `0`                                       |
| 4   | Archivo inexistente         | Imprime el mensaje de error y sale con código `1`                                  |
| 5   | Error en medio de una lista | El programa se detiene al encontrar el error y no imprime los archivos posteriores |
| 6   | Líneas largas (buffer)      | El buffer de 4096 bytes maneja correctamente una línea de 5000 caracteres          |
| 7   | Mensaje de error exacto     | La salida de error es exactamente `wcat: cannot open file`                         |

### `wgrep` — `test.sh` (9 pruebas)

| #   | Prueba                      | Qué verifica                                                                            |
| --- | --------------------------- | --------------------------------------------------------------------------------------- |
| 1   | Búsqueda en un solo archivo | Imprime solo las líneas que contienen `hola` en `example1.txt`                          |
| 2   | Lectura desde stdin         | Lee de la entrada estándar cuando no se especifica archivo                              |
| 3   | Múltiples archivos          | Busca en `example1.txt` y `example2.txt` consecutivamente                               |
| 4   | Sin argumentos              | Imprime `wgrep: searchterm [file ...]` y sale con código `1`                            |
| 5   | Archivo inexistente         | Imprime `wgrep: cannot open file` y sale con código `1`                                 |
| 6   | Case-sensitivity            | Buscar `Hola` no devuelve coincidencias donde solo existe `hola`                        |
| 7   | Término vacío               | El comportamiento (ninguna o todas las líneas) es aceptable según la especificación     |
| 8   | Línea muy larga             | `getline()` encuentra `hola` incrustado en una línea de 6000+ caracteres                |
| 9   | Error en medio de lista     | El programa procesa el primer archivo, falla en el inexistente y no continúa al tercero |

### `wzip` — `wzip_test.sh` (6 pruebas)

| #   | Prueba                    | Qué verifica                                                                 |
| --- | ------------------------- | ---------------------------------------------------------------------------- |
| 1   | Sin argumentos            | Imprime `wzip: file1 [file2 ...]` y sale con código `1`                      |
| 2   | Archivo inexistente       | Imprime `wzip: cannot open file` y sale con código `1`                       |
| 3   | Compresión básica         | `aaaaaaaaaabbbb` genera exactamente 10 bytes (2 entradas × 5 bytes)          |
| 4   | Sin caracteres repetidos  | `abcdef` genera 30 bytes (6 entradas × 5 bytes)                              |
| 5   | Múltiples archivos        | `aaaa` + `bbbb` se comprimen como una sola secuencia RLE continua (10 bytes) |
| 6   | Código de salida en éxito | Retorna `0` tras comprimir exitosamente                                      |

### `wunzip` — `wunzip_test.sh` (7 pruebas)

El script también compila `wzip` automáticamente para poder generar los archivos `.z` de prueba.

| #   | Prueba                         | Qué verifica                                                            |
| --- | ------------------------------ | ----------------------------------------------------------------------- |
| 1   | Sin argumentos                 | Imprime `wunzip: file1 [file2 ...]` y sale con código `1`               |
| 2   | Archivo inexistente            | Imprime `wunzip: cannot open file` y sale con código `1`                |
| 3   | Round-trip básico              | Descomprimir `aaaaaaaaaabbbb.z` devuelve el texto original              |
| 4   | Round-trip multilinea          | El texto con saltos de línea se reconstruye correctamente               |
| 5   | Sin caracteres repetidos       | `abcdef` comprimido y descomprimido da el original                      |
| 6   | Múltiples archivos comprimidos | Dos archivos comprimidos juntos se descomprimen como una sola secuencia |
| 7   | Código de salida en éxito      | Retorna `0` tras descomprimir exitosamente                              |

---

## Vídeo

Vídeo: [https://drive.google.com/file/d/1OHYu8-22Q8Xau1gBX7YmoGiS7eYBMQiH/view?usp=sharing](https://drive.google.com/file/d/1OHYu8-22Q8Xau1gBX7YmoGiS7eYBMQiH/view?usp=sharing)

---

## Manifiesto de transparencia

Se utilizó IA generativa (Antigravity usando el modelo Claude Sonnet 4.6) en los siguientes puntos del desarrollo:

- **Creación y formato de los scripts de prueba (`.sh`):** los casos de prueba se diseñaron manualmente, pero se usó la IA para reunirlos en archivos shell con formato enriquecido: colores ANSI en la salida (verde/rojo/amarillo/azul), separadores visuales, títulos por sección, compilación automática del programa al inicio de cada script, creación de archivos de prueba temporales y eliminación automática de estos al finalizar.

- **Resolución del problema de CRLF:** al intentar ejecutar los scripts en WSL y obtener el error `cannot execute: required file not found`, se consultó a la IA para identificar la causa raíz (finales de línea Windows `\r\n` en el shebang) y las posibles soluciones (`dos2unix`, `sed`, cambio en VS Code, o uso de `bash` explícito).
