#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 4096

/**
 * Imprime el contenido de un archivo en la salida estándar.
 * @param filename Ruta del archivo a leer
 * @return 0 en éxito, 1 en error
 */
int printFile(const char *filename)
{
    /* 1. Abrir archivo en modo lectura */
    FILE *fp = fopen(filename, "r");
    if (fp == NULL)
    {
        fprintf(stderr, "wcat: cannot open file\n");
        return 1;
    }

    char buffer[BUFFER_SIZE];
    
    /* 2. Leer línea por línea e imprimir */
    while (fgets(buffer, sizeof(buffer), fp) != NULL) {
        /* fgets incluye el '\n' si cabe en el buffer, por eso no agregamos otro */
        printf("%s", buffer);
    }

    fclose(fp); // 3. Cerrar archivo
    return 0;  /* Éxito */
}

int main(int argc, char *argv[]) {
    /* Caso: sin archivos especificados → salir con 0 (comportamiento especificado) */
    if (argc == 1) {
        return 0;
    }

    /* Procesar cada archivo en orden de argumentos */
    for (int i = 1; i < argc; i++) {
        if (printFile(argv[i]) != 0) {
            return 1; /* Error al abrir: salir inmediatamente */
        }
    }

    return 0;  /* Todos los archivos procesados exitosamente */
}