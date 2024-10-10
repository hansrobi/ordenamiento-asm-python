section .data
    msjTamArr db "Ingrese el numero de caracteres del arreglo: ", 0x0
    fmtNro db "%ld", 0x0
    msjChar db "Ingrese un caracter: ", 0x0
    fmtChar db " %c", 0x0
    msjMostrarArr db "Arreglo inicial:", 0x0a, 0
    msjMostrarArrOrd db "Arreglo ordenado:", 0x0a, 0
    saltoLinea db 0x0a, 0

section .bss
    char resb 1           ; Variable para almacenar un carácter temporal
    tamArr resq 1
    ptrArr resq 1

section .text
    extern printf, scanf, malloc, free, rand, srand, time    ; Declarar las funciones externas
    global main               ; Punto de entrada del programa

%macro gen_char_aleatorio 1
    ; Llamar a la función rand()
    call rand            ; El resultado de rand() queda en rax

    ; Limitar el valor al rango de caracteres alfabéticos (97-122 -> 'a'-'z')
    mov rbx, 26          ; Tamaño del alfabeto ('a'-'z')
    xor rdx, rdx         ; Limpiar rdx para la división
    div rbx              ; rax = rax / 26, el residuo queda en rdx
    add dl, 97           ; Convertir el valor en un carácter ('a' = 97)
    mov [%1], dl       ; Almacenar el carácter generado
%endmacro

%macro imprimir 1
    push rcx
    push rsi

    mov rdi, %1
    xor rax, rax
    call printf

    pop rsi
    pop rcx
%endmacro

solicitar_tam:
    push rbp
    mov rbp, rsp

    ; Solicitar el número de caracteres
    mov rdi, msjTamArr
    xor rax, rax
    call printf

    ; Leer el número de caracteres
    mov rdi, fmtNro
    mov rsi, tamArr              ; Segundo argumento: dirección de num
    xor rax, rax              ; 0 argumentos vectoriales para scanf
    call scanf

    mov rsp, rbp
    pop rbp
    ret

asignar_mem:
    push rbp
    mov rbp, rsp

    ; Calcular el tamaño de memoria a asignar (en bytes)
    mov rdi, [tamArr]            ; Número de caracteres
    mov rsi, 1                   ; Tamaño de cada carácter (1 byte)
    imul rdi, rsi                ; Multiplicar para obtener el total de bytes

    ; Llamada a malloc para reservar memoria
    ; void* malloc(size_t size);
    xor rax, rax
    mov rax, rdi       ; Número de bytes a asignar
    call malloc        ; Llamar a malloc

    ; Verificar si malloc falló (resultado es NULL)
    test rax, rax
    jz fin_programa    ; Si es NULL, termina el programa

    ; Guardar el puntero a la memoria asignada en rsi (para el uso del arreglo)
    mov [ptrArr], rax

    mov rsp, rbp
    pop rbp
    ret

leer_caracteres:
    push rbp
    mov rbp, rsp

loop_leer_caracteres:
    cmp rcx, 0
    je fin_lectura

    push rcx
    push rsi
    push rdi

    ; Solicitar un carácter
    ;mov rdi, msjChar
    ;xor rax, rax
    ;call printf

    ; Leer un carácter
    ;mov rdi, fmtChar
    ;mov rsi, char
    ;xor rax, rax
    ;call scanf

    gen_char_aleatorio char

    pop rdi
    pop rsi
    pop rcx

    ; Almacenar el carácter en el arreglo
    xor rax, rax
    mov al, [char]

    mov [rsi], al
    inc rsi
    loop loop_leer_caracteres

fin_lectura:
    mov rcx, [tamArr]
    mov rsi, [ptrArr]

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
    imprimir saltoLinea
    mov rsp, rbp
    pop rbp
    ret

liberar_memoria:
    push rbp
    mov rbp, rsp

    ; Obtener el puntero a la memoria
    mov rdi, [ptrArr]  ; Puntero a liberar
    call free          ; Liberar la memoria

    mov rsp, rbp
    pop rbp
    ret

quick_sort:
    push rbp
    mov rbp, rsp
    sub rsp, 32         ; Local variables

    mov [rbp-8], rdi    ; arr
    mov [rbp-16], rsi   ; inicio
    mov [rbp-24], rdx   ; fin

    cmp rsi, rdx
    jge .done

    ; Call particionar
    call particionar
    mov rcx, rax        ; pivote

    ; Recursive calls
    mov rdi, [rbp-8]
    mov rsi, [rbp-16]
    lea rdx, [rcx-1]
    call quick_sort

    mov rdi, [rbp-8]
    lea rsi, [rcx+1]
    mov rdx, [rbp-24]
    call quick_sort

.done:
    leave
    ret

particionar:
    push rbp
    mov rbp, rsp
    sub rsp, 32         ; Local variables

    mov [rbp-8], rdi    ; arr
    mov [rbp-16], rsi   ; inicio
    mov [rbp-24], rdx   ; fin

    ; x = arr[fin]
    movzx rax, byte [rdi+rdx]
    mov [rbp-32], al    ; x

    ; i = inicio - 1
    mov rcx, rsi
    dec rcx             ; i

    ; for j in range(inicio, fin):
    mov r8, rsi         ; j = inicio
.loop:
    cmp r8, rdx
    jge .endloop

    ; if arr[j] <= x:
    movzx rax, byte [rdi+r8]
    cmp al, [rbp-32]
    jg .continue

    ; i += 1
    inc rcx

    ; arr[i], arr[j] = arr[j], arr[i]
    mov r9b, [rdi+rcx]
    mov r10b, [rdi+r8]
    mov [rdi+rcx], r10b
    mov [rdi+r8], r9b

.continue:
    inc r8
    jmp .loop

.endloop:
    ; arr[i + 1], arr[fin] = arr[fin], arr[i + 1]
    lea r9, [rcx+1]
    mov r10b, [rdi+r9]
    mov r11b, [rdi+rdx]
    mov [rdi+r9], r11b
    mov [rdi+rdx], r10b

    ; return i + 1
    lea rax, [rcx+1]

    leave
    ret

main:
    ; Prólogo de la función
    push rbp
    mov rbp, rsp

    call solicitar_tam
    call asignar_mem

    mov rsi, [ptrArr]
    mov rcx, [tamArr]            ; Número de caracteres a leer

    ; Inicializar la semilla con la hora actual
    push rcx
    push rsi

    xor rdi, rdi            ; Argumento para time(0)
    call time               ; Llamar a time(0) para obtener la hora actual
    mov rdi, rax
    call srand              ; Inicializar la semilla para rand()

    pop rsi
    pop rcx

    call leer_caracteres
    imprimir msjMostrarArr
    call imprimir_arreglo

    mov rdi, [ptrArr]       ; array
    xor rsi, rsi            ; inicio = 0
    mov rdx, [tamArr]
    dec rdx                 ; fin = tamArr - 1
    call quick_sort

    mov rsi, [ptrArr]
    mov rcx, [tamArr]            ; Número de caracteres a leer

    imprimir msjMostrarArrOrd
    call imprimir_arreglo
    call liberar_memoria

    call fin_programa

fin_programa:
    ; Epílogo de la función y retorno
    mov rsp, rbp
    pop rbp
    xor rax, rax              ; Retornar 0
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
