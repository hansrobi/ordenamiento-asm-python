#include <stdio.h>
#include <stdlib.h>   // Para malloc y free
#include <string.h>  // Para memcpy
#include <time.h>    // Para medir los tiempos

// Prototipos de funciones en NASM
extern char gen_char_aleatorio(void);
extern void gen_caracteres(char* arr, int tam);
extern void quick_sort(char* arr, int inicio, int fin, int bandera);
extern void bubble_sort(char* arr, int tam);
extern void guardarTams(void);
extern long nroArrays;
extern long tamanos[20];

double tmps_qs_asc[20], tmps_bs_asc[20];
double tmps_qs_desc[20], tmps_bs_desc[20];
double tmps_qs_rand[20], tmps_bs_rand[20];

void imprimirArr(char* arr, size_t tam) {
    for (size_t i = 0; i < tam; i++) {
        printf("%c ", arr[i]);
    }
    printf("\n");
}

void imprimirTam(long* arr, long tam) {
    printf("\nTamaños de arrays:\n");
    for (long i = 0; i < tam; i++) {
        printf("%ld ", arr[i]);
    }
    printf("\n");
}

void imprimirResultados(char* ptrArr, char* ptrArrBS, char* ptrArrQS, size_t tamArr) {
    printf("\nArreglo generado:\n");
    imprimirArr(ptrArr, tamArr);

    printf("\nArreglo ordenado con Bubble Sort:\n");
    imprimirArr(ptrArrBS, tamArr);

    printf("\nArreglo ordenado con Quick Sort:\n");
    imprimirArr(ptrArrQS, tamArr);
}

void imprimirTiempos(char* tipoOrden, double* tiemposBS, double* tiemposQS, long* tamanos, int nroArrays) {
    printf("\n%s:\n", tipoOrden);
    for (int i = 0; i < nroArrays; i++) {
        printf("Tamaño %ld: Bubble Sort: %.6f, Quick Sort: %.6f\n", tamanos[i], tiemposBS[i], tiemposQS[i]);
    }
}

double medirTiempo(void (*algOrdenamiento)(char*, int), char* arr, int tam) {
    clock_t inicio, fin;
    inicio = clock();
    algOrdenamiento(arr, tam);
    fin = clock();
    return ((double) (fin - inicio)) / CLOCKS_PER_SEC;
}

void quickSortWrap(char* arr, int tam) {
    quick_sort(arr, 0, tam - 1, 1);
}

void guardarTiempos(const char* nombreArchivo) {
    FILE* archivo = fopen(nombreArchivo, "w");

    if (!archivo) {
        printf("Error al abrir el archivo para guardar los tiempos.\n");
        return;
    }

    for (int i = 0; i < nroArrays; i++) {
        // Guardar los tiempos en el archivo (tamaño, BubbleSort, QuickSort)
        fprintf(archivo, "%ld %.6f %.6f %.6f %.6f %.6f %.6f\n", tamanos[i],
                tmps_bs_asc[i], tmps_qs_asc[i], tmps_bs_desc[i], tmps_qs_desc[i], tmps_bs_rand[i], tmps_qs_rand[i]);
    }

    fclose(archivo);
    printf("\nLos tiempos se han guardado exitosamente en %s\n", nombreArchivo);
}

void pruebas() {
    char *ptrArr, *ptrArrBS, *ptrArrQS;
    size_t tamArr;
    int i;

    // Prueba para orden ascendente
    printf("\nEjecutando pruebas en arreglos ascendentes...\n");

    for (i = 0; i < nroArrays; i++) {
        // Asignar tamaño del arreglo actual
        tamArr = tamanos[i];

        // Asignar memoria para los arreglos
        ptrArr = malloc(tamArr);
        ptrArrBS = malloc(tamArr);
        ptrArrQS = malloc(tamArr);

        if (!ptrArr || !ptrArrBS || !ptrArrQS) {
            printf("Error al asignar memoria\n");
            return;
        }

        // Generar caracteres aleatorios
        gen_caracteres(ptrArr, tamArr);

        // Generar array en orden ascendente
        quick_sort(ptrArr, 0, tamArr - 1, 1);

        // Copiar el arreglo generado a los arreglos de burbuja y quicksort
        memcpy(ptrArrBS, ptrArr, tamArr);
        memcpy(ptrArrQS, ptrArr, tamArr);

        tmps_bs_asc[i] = medirTiempo(bubble_sort, ptrArrBS, tamArr);
        tmps_qs_asc[i] = medirTiempo(quickSortWrap, ptrArrQS, tamArr);

        // Imprimir resultados
        printf("\nARREGLO NRO %d \n", (i + 1));
        printf("===============\n");
        imprimirResultados(ptrArr, ptrArrBS, ptrArrQS, tamArr);

        // Liberar la memoria asignada
        free(ptrArr);
        free(ptrArrBS);
        free(ptrArrQS);
    }

    // Prueba para orden descendente
    printf("\nEjecutando pruebas en arreglos descendentes...\n");

    for (i = 0; i < nroArrays; i++) {
        // Asignar tamaño del arreglo actual
        tamArr = tamanos[i];

        // Asignar memoria para los arreglos
        ptrArr = malloc(tamArr);
        ptrArrBS = malloc(tamArr);
        ptrArrQS = malloc(tamArr);

        if (!ptrArr || !ptrArrBS || !ptrArrQS) {
            printf("Error al asignar memoria\n");
            return;
        }

        // Generar caracteres aleatorios
        gen_caracteres(ptrArr, tamArr);

        // Generar array en orden descendente
        quick_sort(ptrArr, 0, tamArr - 1, -1);

        // Copiar el arreglo generado a los arreglos de burbuja y quicksort
        memcpy(ptrArrBS, ptrArr, tamArr);
        memcpy(ptrArrQS, ptrArr, tamArr);

        tmps_bs_desc[i] = medirTiempo(bubble_sort, ptrArrBS, tamArr);
        tmps_qs_desc[i] = medirTiempo(quickSortWrap, ptrArrQS, tamArr);

        // Imprimir resultados
        printf("\nARREGLO NRO %d \n", (i + 1));
        printf("===============\n");
        imprimirResultados(ptrArr, ptrArrBS, ptrArrQS, tamArr);

        // Liberar la memoria asignada
        free(ptrArr);
        free(ptrArrBS);
        free(ptrArrQS);
    }

    // Prueba para orden desordenado
    printf("\nEjecutando pruebas en arreglos desordenados...\n");

    for (i = 0; i < nroArrays; i++) {
        // Asignar tamaño del arreglo actual
        tamArr = tamanos[i];

        // Asignar memoria para los arreglos
        void *ptrArr = malloc(tamArr);
        void *ptrArrBS = malloc(tamArr);
        void *ptrArrQS = malloc(tamArr);

        if (!ptrArr || !ptrArrBS || !ptrArrQS) {
            printf("Error al asignar memoria\n");
            return;
        }

        // Generar array con caracteres aleatorios
        gen_caracteres(ptrArr, tamArr);

        // Copiar el arreglo generado a los arreglos de burbuja y quicksort
        memcpy(ptrArrBS, ptrArr, tamArr);
        memcpy(ptrArrQS, ptrArr, tamArr);

        tmps_bs_rand[i] = medirTiempo(bubble_sort, ptrArrBS, tamArr);
        tmps_qs_rand[i] = medirTiempo(quickSortWrap, ptrArrQS, tamArr);

        // Imprimir resultados
        printf("\nARREGLO NRO %d \n", (i + 1));
        printf("===============\n");
        imprimirResultados(ptrArr, ptrArrBS, ptrArrQS, tamArr);

        // Liberar la memoria asignada
        free(ptrArr);
        free(ptrArrBS);
        free(ptrArrQS);
    }
}

int main() {
    srand(time(NULL));  // Inicializar la semilla para rand()

    guardarTams();

    imprimirTam(tamanos, nroArrays);
    pruebas();

    // Mostrar tiempos de ejcucion
    printf("\nTiempos de ejecución (en segundos):\n");

    imprimirTiempos("Ascendente", tmps_bs_asc, tmps_qs_asc, tamanos, nroArrays);
    imprimirTiempos("Descendente", tmps_bs_desc, tmps_qs_desc, tamanos, nroArrays);
    imprimirTiempos("Aleatorio", tmps_bs_rand, tmps_qs_rand, tamanos, nroArrays);

    // Guardar tiempos de ejecución en un archivo
    guardarTiempos("tiempos_asm.txt");

    return 0;
}