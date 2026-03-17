#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "wzip: file1 [file2 ...]\n");
        exit(1);
    }

    int current_char  = -1;
    int current_count = 0;

    for (int i = 1; i < argc; i++) {
        FILE *fp = fopen(argv[i], "r");
        if (fp == NULL) {
            fprintf(stderr, "wzip: cannot open file\n");
            exit(1);
        }

        int ch;
        while ((ch = fgetc(fp)) != EOF) {
            if (current_char == -1) {
                current_char  = ch;
                current_count = 1;
            } else if (ch == current_char) {
                current_count++;
            } else {
                fwrite(&current_count, sizeof(int), 1, stdout);
                fwrite(&current_char, sizeof(char), 1, stdout);
                current_char  = ch;
                current_count = 1;
            }
        }

        fclose(fp);
    }

    /* Escribir la última secuencia pendiente */
    if (current_char != -1) {
        fwrite(&current_count, sizeof(int), 1, stdout);
        fwrite(&current_char, sizeof(char), 1, stdout);
    }

    return 0;
}
