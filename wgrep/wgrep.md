# Wgrep

El objetivo es desarrollar `wgrep`, una variante de la herramienta `grep` de UNIX que busca un término específico línea por línea dentro de uno o más archivos. Si una línea contiene el término buscado, se imprime en pantalla; de lo contrario, se ignora.

## Detalles de implementación

1. Al programa wgrep siempre debe pasarse un termino de búsqueda y zero o mas archivos para buscar el patrón deseado (por lo tanto, mas de un archivo es posible).
2. El programa debera moverse por cada una de las lineas de los archivos pasados para ver si el termino de búsqueda se encuentra en estas. Si es asi, el programa imprimirá la linea; sino, no la mostrará.
3. El matching (comparación) es case sensitive. Por tanto, buscar el patrón foo no será lo mismo que buscar el patrón Foo.
4. Las lineas pueden ser arbitrariamente largas (de decir, podrán tener muchos caracteres antes de que se encuentre el caracter de nueva linea) de modo que wgrep deberá funcionar tal y como se espera incluso para lineas muy largas. Para esto se recomienda mirar la función getline() (en lugar de otras funciones como fgets()).
5. Si wgrep es pasado sin argumentos, el programa deberá imprimir el mensaje ”wgrep: searchterm [file ...]” (seguido por una nueva linea) y la llamada exit con status 1.
6. Si wgrep encuentra un archivo que no puede ser abierto, deberá imprimir ”wgrep: cannot open file” (seguido por una nueva linea) y la llamada exit con status 1.
7. Para todos los otros casos, wgrep funcionará con la llamada exit con status 0.
8. Si se especifica un término de búsqueda pero no un archivo, wgrep debería funcionar, pero en lugar de leer desde un archivo, wgrep debería leer desde la entrada estándar (stdin). Hacerlo asi es mas fácil. ya que el flujo de archivos stdin abierto de modo que podrá usar fgets() o rutinas especiales para leerlo.
9. Por simplicidad, si se pasa una cadena vacia como parametro de busqueda, wgrep puede mostrar ninguna linea o todas las lineas; cualquiera de las dos formas anteriores es aceptable.

---

## Ejecución

### Compilación manual con `gcc`

Desde el directorio `wgrep/`, compila el programa con:

```bash
gcc -Wall -Wextra -std=c99 -o wgrep wgrep.c
```

Una vez compilado, puedes ejecutarlo de las siguientes maneras:

```bash
# Buscar un término en un archivo
./wgrep hola archivo.txt

# Buscar en múltiples archivos
./wgrep hola archivo1.txt archivo2.txt

# Leer desde stdin (sin archivo)
echo "hola mundo" | ./wgrep hola

# Sin argumentos (imprime uso y sale con código 1)
./wgrep

# Archivo inexistente (imprime error y sale con código 1)
./wgrep hola no_existe.txt
```

> **Nota:** la búsqueda es *case-sensitive*: `hola` y `Hola` son términos distintos.

---

### Ejecución con `test.sh`

El script `test.sh` compila automáticamente el programa, crea archivos de prueba, ejecuta 9 pruebas y limpia los archivos generados.

```bash
# Dar permisos de ejecución (solo la primera vez)
chmod +x test.sh

# Ejecutar todas las pruebas
./test.sh
```

Las pruebas cubren: búsqueda en un archivo, desde stdin, en múltiples archivos, sin argumentos, archivo inexistente, case-sensitivity, término vacío, líneas muy largas (prueba de `getline`) y error en medio de una lista de archivos.
