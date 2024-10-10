import random
import string
import time
import sys
sys.setrecursionlimit(100000)

# Tiempos de QS y BS
tmps_qs_asc, tmps_bs_asc = [], []
tmps_qs_desc, tmps_bs_desc = [], []
tmps_qs_rand, tmps_bs_rand = [], []

def tam_arr_pruebas():
    tams = []
    for i in range(20):
        tam = int(input("Ingrese el tamanio " + str(i + 1) + ": "))
        if tam == 0:
            break
        tams.append(tam)
    return tams

def pruebas():
    tams = tam_arr_pruebas()
    n = len(tams)

    print("\nTamaños de arrays:")
    imprimir_arrreglo(tams)

    # Ascendente
    print("\nEjecutando pruebas en arreglos ascendentes...")
    for i in range(n):
        tam = tams[i]
        arr = gen_arr(tam, "ascendente")

        # QuickSort
        inicio = time.time()
        qs_ord = quick_sort(arr, asc=True)
        fin = time.time()
        tiempo_qs = fin - inicio

        # BubbleSort
        inicio = time.time()
        bs_ord = bubble_sort(arr)
        fin = time.time()
        tiempo_bs = fin - inicio

        #print(f"\nARREGLO NRO {i + 1}")
        #print("==================")
        #imprimir_resultados(arr, qs_ord, bs_ord)

        tmps_qs_asc.append(tiempo_qs)
        tmps_bs_asc.append(tiempo_bs)

    # Descendente
    print("\nEjecutando pruebas en arreglos descendentes...")
    for i in range(n):
        tam = tams[i]
        arr = gen_arr(tam, "descendente")

        # QuickSort
        inicio = time.time()
        qs_ord = quick_sort(arr, asc=False)
        fin = time.time()
        tiempo_qs = fin - inicio

        # BubbleSort
        inicio = time.time()
        bs_ord = bubble_sort(arr)
        fin = time.time()
        tiempo_bs = fin - inicio

        #print(f"\nARREGLO NRO {i + 1}")
        #print("==================")
        #imprimir_resultados(arr, qs_ord, bs_ord)

        tmps_qs_desc.append(tiempo_qs)
        tmps_bs_desc.append(tiempo_bs)

    # Desordenado
    print("\nEjecutando pruebas en arreglos desordenados...")
    for i in range(n):
        tam = tams[i]
        arr = gen_arr(tam, "desordenado")

        # QuickSort
        inicio = time.time()
        qs_ord = quick_sort(arr, asc=True)
        fin = time.time()
        tiempo_qs = fin - inicio

        # BubbleSort
        inicio = time.time()
        bs_ord = bubble_sort(arr)
        fin = time.time()
        tiempo_bs = fin - inicio

        #print(f"\nARREGLO NRO {i + 1}")
        #print("==================")
        #imprimir_resultados(arr, qs_ord, bs_ord)

        tmps_qs_rand.append(tiempo_qs)
        tmps_bs_rand.append(tiempo_bs)
    
    return tams, n

def gen_arr(tam, escenario):
    arr = generar_arreglo(tam)
    if escenario == "ascendente":
        arr_asc = quick_sort(arr, asc=True)
        return arr_asc
    elif escenario == "descendente":
        arr_desc = quick_sort(arr, asc=False)
        return arr_desc
    elif escenario == "desordenado":
        return arr

# Generar una lista de caracteres aleatorios
def generar_arreglo(tam):
    return [random.choice(string.ascii_lowercase) for _ in range(tam)]

def imprimir_resultados(arr_gen, arr_bs, arr_qs):
    print("\nArreglo generado:")
    imprimir_arrreglo(arr_gen)

    print("\nArreglo ordenado por Bubble Sort:")
    imprimir_arrreglo(arr_bs)

    print("\nArreglo ordenado por Quick Sort:")
    imprimir_arrreglo(arr_qs)


def imprimir_arrreglo(arr):
    for i in range(len(arr)):
        print(arr[i], end=' ')
    print()

def imprimir_tiempos(tipo_orden, tiempos_bs, tiempos_qs, tamanos, nro_arrays):
    print(f"\n{tipo_orden}:")
    for i in range(nro_arrays):
        print(f"Tamaño {tamanos[i]}: Bubble Sort: {tiempos_bs[i]:.6f}, Quick Sort: {tiempos_qs[i]:.6f}")

def guardar_tiempos(nombre_archivo):
    try:
        with open(nombre_archivo, "w") as archivo:
            for i in range(len(tamanos)):
                archivo.write(f"{tamanos[i]} {tmps_bs_asc[i]:.6f} {tmps_qs_asc[i]:.6f} "
                            f"{tmps_bs_desc[i]:.6f} {tmps_qs_desc[i]:.6f} "
                            f"{tmps_bs_rand[i]:.6f} {tmps_qs_rand[i]:.6f}\n")
        print(f"\nLos tiempos se han guardado exitosamente en '{nombre_archivo}'")
    except IOError:
        print(f"Error al abrir el archivo '{nombre_archivo}' para guardar los tiempos.")

def quick_sort(arr, asc=True):
    arr_ordenado = arr.copy()
    quick_sort_recursivo(arr_ordenado, 0, len(arr_ordenado) - 1, asc)
    return arr_ordenado

def quick_sort_recursivo(arr, inicio, fin, asc):
    if inicio < fin:
        pivote = particionar(arr, inicio, fin, asc)
        quick_sort_recursivo(arr, inicio, pivote - 1, asc)
        quick_sort_recursivo(arr, pivote + 1, fin, asc)

def particionar(arr, inicio, fin, asc):
    x = arr[fin]
    i = inicio - 1
    for j in range(inicio, fin):
        if asc:
            if arr[j] <= x:
                i += 1
                arr[i], arr[j] = arr[j], arr[i] #? intercambio
        
        else:
            if arr[j] >= x:
                i += 1
                arr[i], arr[j] = arr[j], arr[i] #? intercambio
    
    arr[i + 1], arr[fin] = arr[fin], arr[i + 1] #? intercambio
    return i + 1

def bubble_sort(arr):
    arr_ordenado = arr.copy()
    n = len(arr_ordenado)
    for i in range(n):
        for j in range(0, n - i - 1):
            if arr_ordenado[j] > arr_ordenado[j + 1] :
                arr_ordenado[j], arr_ordenado[j + 1] = arr_ordenado[j + 1], arr_ordenado[j]
    return arr_ordenado

tamanos, nro_arrays = pruebas()

print("\nTiempos de ejecución (en segundos):")

imprimir_tiempos("Ascendente", tmps_bs_asc, tmps_qs_asc, tamanos, nro_arrays)
imprimir_tiempos("Descendente", tmps_bs_desc, tmps_qs_desc, tamanos, nro_arrays)
imprimir_tiempos("Aleatorio", tmps_bs_rand, tmps_qs_rand, tamanos, nro_arrays)

# Guardar tiempos en un archivo de texto
guardar_tiempos("tiempos_python.txt")