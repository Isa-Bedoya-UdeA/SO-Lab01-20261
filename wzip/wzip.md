# Wzip

Es una herramienta de compresión que utiliza el algoritmo **Run-Length Encoding (RLE)**. Detecta secuencias de caracteres idénticos y las reemplaza por el número de repeticiones seguido del carácter. La salida se escribe en el formato binario específico detallado abajo.

## Detalles de implementación (wzip)

1. La invocación correcta permitira pasar uno o mas archivos a traves de la linea de comandos al programa. Si no se especifican archivos, el programa debera salir empleando la llamada exit con codigo de retorno 1, no sin antes imprimir ”wzip: file1 [file2 ...]” (seguido por una nueva linea).
2. El formato del archivo comprimido debe coincidir con la descripción de arriba exactamente (un entero de 4-bytes seguiro por un caracter).
3. Tenga en cuenta que si se pasan varios archivos a wzip, estos se comprimen en una única salida comprimida y, cuando se descomprimen, estos se convertiran en una única secuencia de texto sin comprimir (por lo tanto, se pierde la información de que varios archivos se ingresaron originalmente en wzip).
