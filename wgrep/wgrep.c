#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h> 

#define EXIT_SUCCESS_CODE 0
#define EXIT_ERROR_CODE 1

void searchAndPrintLines(FILE *input_stream, const char *search_term) {
    char *line_buffer = NULL;
    size_t buffer_capacity = 0;
    ssize_t line_length;
    
    while ((line_length = getline(&line_buffer, &buffer_capacity, input_stream)) != -1) {
        if (strstr(line_buffer, search_term) != NULL) {
            printf("%s", line_buffer);
        }
    }
    
    free(line_buffer);
}

void reportErrorAndExit(const char *error_message) {
    printf("%s\n", error_message);
    exit(EXIT_ERROR_CODE);
}

void processInputSources(int arg_count, char *arg_vector[], const char *search_term) {
    if (arg_count == 2) {
        searchAndPrintLines(stdin, search_term);
        return;
    }
    
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
    if (argc < 2) {
        printf("wgrep: searchterm [file ...]\n");
        return EXIT_ERROR_CODE;
    }
    
    const char *search_term = argv[1];
    
    processInputSources(argc, argv, search_term);
    
    return EXIT_SUCCESS_CODE;
}