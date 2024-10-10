def bubble_sort(arr):
    n = len(arr)

    for i in range(n):
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1] :
                arr[j], arr[j + 1] = arr[j + 1], arr[j]


# Test
arr = [2, 8, 7, 1, 3, 5, 6, 4]
print("Array inicial: ", arr)

n = len(arr)
bubble_sort(arr)
print("Array ordenado:", arr)