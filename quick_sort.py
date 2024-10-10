def quick_sort(arr, inicio, fin):
    if inicio < fin:
        pivote = particionar(arr, inicio, fin)
        quick_sort(arr, inicio, pivote - 1)
        quick_sort(arr, pivote + 1, fin)

def particionar(arr, inicio, fin):
    x = arr[fin]
    i = inicio - 1
    for j in range(inicio, fin):
        if arr[j] <= x:
            i += 1
            arr[i], arr[j] = arr[j], arr[i] #? intercambio
    
    arr[i + 1], arr[fin] = arr[fin], arr[i + 1] #? intercambio
    return i + 1

# Test
arr = [2, 8, 7, 1, 3, 5, 6, 4]
print("Array inicial: ", arr)

n = len(arr)
quick_sort(arr, 0, n - 1)
print("Array ordenado:", arr)