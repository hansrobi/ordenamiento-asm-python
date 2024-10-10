section .data
    msjTamArrLoop db "Ingrese el numero de caracteres del arreglo %d: ", 0x0
    msjTamArr db "Ingrese el numero de caracteres del arreglo: ", 0x0
    fmtNro db "%ld", 0x0
    msjChar db "Ingrese un caracter: ", 0x0
    fmtChar db " %c", 0x0
    msjMostrarArr db "Arreglo inicial:", 0x0a, 0
    msjMostrarArrAscendente db "Arreglos Ascendentes", 0x0a, 0
    msjMostrarArrDescendente db "Arreglos Descendentes", 0x0a, 0
    msjMostrarArrDesordenado db "Arreglos Desordenados", 0x0a, 0
    msjLineas db "======================", 0x0a, 0
    msjMostrarArrOrdQS db "Arreglo ordenado por quick sort:", 0x0a, 0
    msjMostrarArrOrdBS db "Arreglo ordenado por bubble sort:", 0x0a, 0
    saltoLinea db 0x0a, 0
    ;tamArrPrueba dq 20      ; Número de pruebas a realizar

section .bss
    char resb 1           ; Variable para almacenar un carácter temporal
    tamArr resq 1
    tamanos resq 20         ; Array to store 20 sizes (8 bytes each)
    nroArrays resq 1
    ptrArr resq 1
    ptrArrQS resq 1
    ptrArrBS resq 1

section .text
    extern printf, scanf, malloc, free, rand, srand, time, memcpy ; Declarar las funciones externas
    global gen_semilla
    global gen_char_aleatorio               ; Punto de entrada del programa
    global gen_caracteres
    global bubble_sort
    global quick_sort
    global guardarTams
    global tamanos
    global nroArrays

imprimir:
    push rbp
    mov rbp, rsp

    push rcx
    push rsi

    xor rax, rax
    call printf

    pop rsi
    pop rcx

    mov rsp, rbp
    pop rbp
    ret

asignar_mem:
    push rbp
    mov rbp, rsp

    mov rsi, 1                   ; Tamaño de cada carácter (1 byte)
    imul rdi, rsi                ; Multiplicar para obtener el total de bytes

    ; Llamada a malloc para reservar memoria
    ; void* malloc(size_t size);
    xor rax, rax
    mov rax, rdi       ; Número de bytes a asignar
    call malloc        ; Llamar a malloc

    ; Verificar si malloc falló (resultado es NULL)
    ;test rax, rax
    ;jz fin_programa    ; Si es NULL, termina el programa

    mov rsp, rbp
    pop rbp
    ret

gen_semilla:
    push rbp
    mov rbp, rsp

    ; Inicializar la semilla con la hora actual
    push rcx
    push rsi

    xor rdi, rdi            ; Argumento para time(0)
    call time               ; Llamar a time(0) para obtener la hora actual
    mov rdi, rax
    call srand              ; Inicializar la semilla para rand()

    pop rsi
    pop rcx

    mov rsp, rbp
    pop rbp
    ret

gen_char_aleatorio:
    push rbp
    mov rbp, rsp

    ; Llamar a la función rand()
    call rand            ; El resultado de rand() queda en rax

    ; Limitar el valor al rango de caracteres alfabéticos (97-122 -> 'a'-'z')
    mov rbx, 26          ; Tamaño del alfabeto ('a'-'z')
    xor rdx, rdx         ; Limpiar rdx para la división
    div rbx              ; rax = rax / 26, el residuo queda en rdx
    add dl, 97           ; Convertir el valor en un carácter ('a' = 97)
    mov [char], dl       ; Almacenar el carácter generado
    movzx rax, byte [char] ; Devolver el carácter generado en rax

    mov rsp, rbp
    pop rbp
    ret

gen_caracteres:
    push rbp
    mov rbp, rsp

    ; Los argumentos:
    ; rdi: puntero al arreglo
    ; rsi: tamaño del arreglo
    ; Guardar los registros que vamos a usar
    push rbx
    push r12
    push r13

    ; Inicializar registros
    mov r12, rdi  ; Puntero al arreglo
    mov r13, rsi  ; Tamaño del arreglo

loop_gen_caracteres:
    test r13, r13
    jz fin_gen_caracteres

    call gen_char_aleatorio

    mov [r12], al

    inc r12
    dec r13
    jmp loop_gen_caracteres

fin_gen_caracteres:
    ; Restaurar registros
    pop r13
    pop r12
    pop rbx

    mov rsp, rbp
    pop rbp
    ret

imprimir_arreglo:
    push rbp
    mov rbp, rsp

loop_imprimir_arreglo:
    cmp rcx, 0
    je fin_loop

    push rsi
    push rcx

    mov al, [rsi]
    mov [char], al

    mov rdi, fmtChar
    mov rsi, [char]
    xor rax, rax
    call printf

    pop rcx
    pop rsi

    inc rsi
    loop loop_imprimir_arreglo

fin_loop:
    mov rdi, saltoLinea
    call imprimir

    mov rsp, rbp
    pop rbp
    ret

liberar_memoria:
    push rbp
    mov rbp, rsp

    test rdi, rdi      ; Comprobar si el puntero es NULL
    jz skip_free     ; Si es NULL, saltar la liberación
    call free          ; Liberar la memoria

skip_free:
    mov rsp, rbp
    pop rbp
    ret

bubble_sort:
    push rbp
    mov rbp, rsp

    ; Preservar registros no volátiles
    push rbx
    push r12
    push r13
    push r14
    push r15

    ; rdi = puntero al array
    ; rsi = tamaño del array
    mov r12, rdi        ; r12 = puntero al array
    mov r13, rsi        ; r13 = tamaño del array
    dec r13             ; n - 1 para el bucle externo

loop_externo:
    xor r14, r14        ; r14 = j = 0 para el bucle interno

loop_interno:
    movzx r15d, byte [r12 + r14]      ; r15d = primer elemento
    movzx ebx, byte [r12 + r14 + 1]   ; ebx = segundo elemento
    cmp r15d, ebx
    jle no_intercambio

    ; Intercambiar elementos
    mov [r12 + r14], bl
    mov [r12 + r14 + 1], r15b

no_intercambio:
    inc r14
    cmp r14, r13
    jl loop_interno

    dec r13
    jnz loop_externo

    ; Restaurar registros no volátiles
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx

    mov rsp, rbp
    pop rbp
    ret

quick_sort:
    push rbp
    mov rbp, rsp
    sub rsp, 40         ; Local variables

    mov [rbp-8], rdi    ; arr
    mov [rbp-16], rsi   ; inicio
    mov [rbp-24], rdx   ; fin
    mov [rbp-32], rcx   ; bandera

    cmp rsi, rdx
    jge .done

    ; Call particionar
    mov rdi, [rbp-8]
    mov rsi, [rbp-16]
    mov rdx, [rbp-24]
    mov rcx, [rbp-32]
    call particionar
    mov r8, rax        ; pivote

    ; Recursive calls
    mov rdi, [rbp-8]
    mov rsi, [rbp-16]
    lea rdx, [r8-1]
    mov rcx, [rbp-32]   ; Pasar la bandera
    call quick_sort

    mov rdi, [rbp-8]
    lea rsi, [r8+1]
    mov rdx, [rbp-24]
    mov rcx, [rbp-32]   ; Pasar la bandera
    call quick_sort

.done:
    leave
    ret

particionar:
    push rbp
    mov rbp, rsp
    sub rsp, 40         ; Local variables

    mov [rbp-8], rdi    ; arr
    mov [rbp-16], rsi   ; inicio
    mov [rbp-24], rdx   ; fin
    mov [rbp-32], rcx   ; bandera

    ; x = arr[fin]
    movzx rax, byte [rdi+rdx]
    mov [rbp-40], al    ; x

    ; i = inicio - 1
    mov r9, rsi
    dec r9             ; i

    ; for j in range(inicio, fin):
    mov r8, rsi         ; j = inicio

.loop:
    cmp r8, rdx
    jge .endloop

    ; if arr[j] <= x:
    movzx rax, byte [rdi+r8]
    mov r10, [rbp-32]    ; orden
    cmp r10, 1           ; Si orden es 1, compara para ascendente
    je .ascendente
    jmp .descendente

.ascendente:
    ; if arr[j] <= x:
    cmp al, [rbp-40]
    jg .continue
    jmp .comparar_fin

.descendente:
    ; if arr[j] >= x:
    cmp al, [rbp-40]
    jl .continue
    ; Si es igual o mayor, hacemos el swap

.comparar_fin:
    ; i += 1
    inc r9

    ; arr[i], arr[j] = arr[j], arr[i]
    mov r10b, [rdi+r9]
    mov r11b, [rdi+r8]
    mov [rdi+r9], r11b
    mov [rdi+r8], r10b

.continue:
    inc r8
    jmp .loop

.endloop:
    ; arr[i + 1], arr[fin] = arr[fin], arr[i + 1]
    lea r10, [r9+1]
    mov r11b, [rdi+r10]
    mov r12b, [rdi+rdx]
    mov [rdi+r10], r12b
    mov [rdi+rdx], r11b

    ; return i + 1
    lea rax, [r9+1]

    leave
    ret

guardarTams:
    push rbp
    mov rbp, rsp

    ; Preservar registros no volátiles
    push rbx
    push r12
    push r13
    push r14
    ; r12 será nuestro contador de tamaños ingresados
    xor r12, r12

pedir_tam:
    ; Solicitar el número de caracteres
    mov rdi, msjTamArrLoop
    mov rsi, r12
    inc rsi
    xor eax, eax
    call printf

    ; Leer el número de caracteres
    mov rdi, fmtNro
    lea rsi, [tamanos + r12*8]
    xor eax, eax
    call scanf

    ; Verificar si el usuario ingresó 0 para terminar
    cmp dword [tamanos + r12*8], 0
    je fin_ingreso
    inc r12
    cmp r12, 20
    jl pedir_tam

fin_ingreso:
    ; Guardar el número total de tamaños ingresados
    mov [nroArrays], r12
    ; Restaurar registros no volátiles
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits