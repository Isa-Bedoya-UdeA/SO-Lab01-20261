/* Habilitar extensiones POSIX para ssize_t y getline */
#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>  /* Incluye definición de ssize_t en muchos sistemas */

#define EXIT_SUCCESS_CODE 0
#define EXIT_ERROR_CODE 1

/**
 * Busca e imprime líneas que contengan el término de búsqueda en un stream.
 * @param input_stream Archivo o stdin a leer
 * @param search_term Término a buscar (case-sensitive)
 */
void searchAndPrintLines(FILE *input_stream, const char *search_term) {
    char *line_buffer = NULL;     /* Buffer dinámico para getline */
    size_t buffer_capacity = 0;   /* Capacidad actual del buffer */
    ssize_t line_length;          /* Longitud de la línea leída */
    
    /* getline() redimensiona automáticamente para líneas arbitrariamente largas */
    while ((line_length = getline(&line_buffer, &buffer_capacity, input_stream)) != -1) {
        /* strstr realiza búsqueda case-sensitive, como se requiere */
        if (strstr(line_buffer, search_term) != NULL) {
            printf("%s", line_buffer);  /* getline ya incluye el '\n' */
        }
    }
    
    /* Liberar memoria asignada dinámicamente por getline */
    free(line_buffer);
}

/**
 * Imprime mensaje de error y termina el programa con código de error.
 * @param error_message Mensaje exacto a mostrar
 */
void reportErrorAndExit(const char *error_message) {
    printf("%s\n", error_message);
    exit(EXIT_ERROR_CODE);
}

/**
 * Procesa archivos o stdin según los argumentos recibidos.
 * @param arg_count Número de argumentos en línea de comandos
 * @param arg_vector Vector de argumentos
 * @param search_term Término de búsqueda proporcionado por el usuario
 */
void processInputSources(int arg_count, char *arg_vector[], const char *search_term) {
    /* Caso: solo término de búsqueda -> leer desde stdin */
    if (arg_count == 2) {
        searchAndPrintLines(stdin, search_term);
        return;
    }
    
    /* Caso: uno o más archivos -> procesar cada uno en orden */
    for (int file_index = 2; file_index < arg_count; file_index++) {
        FILE *file_ptr = fopen(arg_vector[file_index], "r");
        if (file_ptr == NULL) {
            reportErrorAndExit("wgrep: cannot open file");
        }
        
        searchAndPrintLines(file_ptr, search_term);
        fclose(file_ptr);
    }
}

int main(int argc, char *argv[]) {
    /* Validar argumentos mínimos: se requiere al menos el término de búsqueda */
    if (argc < 2) {
        printf("wgrep: searchterm [file ...]\n");
        return EXIT_ERROR_CODE;
    }
    
    const char *search_term = argv[1];
    
    processInputSources(argc, argv, search_term);
    
    return EXIT_SUCCESS_CODE;
}