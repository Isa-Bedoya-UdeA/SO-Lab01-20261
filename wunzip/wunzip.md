# Wuzip

Es la herramienta de descompresión encargada de realizar la operación opuesta a `wzip`. Lee un archivo comprimido en formato binario y reconstruye la secuencia de texto original enviándola a la salida estándar (`stdout`).

## Detalles de implementación (wunzip)

1. La invocación correcta permitira pasar uno o mas archivos a traves de la linea de comandos al programa. Si no se especifican archivos, el programa debera salir empleando la llamada exit con codigo de retorno 1, no sin antes imprimir ”wunzip: file1 [file2 ...]” (seguido por una nueva linea).
2. El formato del archivo comprimido debe coincidir con la descripción de arriba exactamente (un entero de 4-bytes seguiro por un caracter).
3. Tenga en cuenta que si se pasan varios archivos a wunzip, estos se convertiran en una única secuencia de texto sin comprimir. Lo mismo aplica para wzip.
