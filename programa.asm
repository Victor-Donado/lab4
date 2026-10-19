; ── Constantes ───────────────────────────────────────────────────────────
CR              EQU  0Dh         
LF              EQU  0Ah         
TERMINADOR      EQU  24h         
ITERACIONES     EQU  5           

; ── Segmento de Pila (Obligatorio para .EXE) ─────────────────────────────
segment stack stack
    resb 256        

; ── Segmento de Datos (Inicializados) ────────────────────────────────────
segment data
    bienvenida  db "=== Laboratorio NASM - Unidad 4 ===", CR, LF, TERMINADOR
    separador   db "----------------------------------------", CR, LF, TERMINADOR
    etiqueta_a  db "Variable A (word):  ", TERMINADOR
    etiqueta_b  db "Variable B (dword): ", TERMINADOR
    fin_msg     db "Programa finalizado correctamente.", CR, LF, TERMINADOR

    var_byte    db  42           ; 1 byte con valor 42
    var_word    dw  1234h        ; 2 bytes con valor 0x1234
    var_dword   dd  0DEADBEEFh   ; 4 bytes
    
    ; NOTA: Cambié los valores a un solo dígito (1 al 5) para que 
    ; la conversión ASCII (add al, 30h) funcione y se vean bien en pantalla.
    tabla_bytes db  1, 2, 3, 4, 5  

; ── Segmento de Datos No Inicializados ───────────────────────────────────
segment bss
    buffer      resb 80      
    resultado   resw 1       

; ── Segmento de Código ───────────────────────────────────────────────────
segment code
..start:
    ; 1. Inicializar el segmento de datos
    mov  ax, data
    mov  ds, ax

    ; 2. Imprimir bienvenida y separador (Función 09h)
    mov  ah, 09h
    mov  dx, bienvenida
    int  21h

    mov  dx, separador
    int  21h

    ; 3. Imprimir etiqueta A
    mov  ah, 09h
    mov  dx, etiqueta_a
    int  21h

    ; === Función 02h: imprimir un carácter ===
    ; Imprimir el valor de var_byte convertido (Solo para demo)
    mov  al, [var_byte]      ; AL = 42
    add  al, 30h             ; 42 + 48 = 90 ("Z" en ASCII)
    mov  ah, 02h             
    mov  dl, al
    int  21h

    ; Imprimir nueva línea manual con Función 02h
    mov  ah, 02h
    mov  dl, CR
    int  21h
    mov  dl, LF
    int  21h

    ; === Recorrer tabla de bytes e imprimir cada elemento ===
    lea  si, tabla_bytes     ; SI apunta al inicio de la tabla
    mov  cx, ITERACIONES     ; CX = 5 iteraciones (Controla el loop)

imprimir_tabla:
    mov  al, [si]            ; AL = byte actual de la tabla
    add  al, 30h             ; Conversión a ASCII (Válida para 0-9)
    mov  ah, 02h
    mov  dl, al
    int  21h

    mov  ah, 02h             ; Imprimir espacio entre elementos
    mov  dl, 20h             ; 20h es el código ASCII del espacio
    int  21h

    inc  si                  ; Avanzar al siguiente byte en la memoria
    loop imprimir_tabla      ; Resta 1 a CX; si CX no es 0, salta a imprimir_tabla

    ; Imprimir nueva línea después de la tabla
    mov  ah, 02h
    mov  dl, CR
    int  21h
    mov  dl, LF
    int  21h

    ; 4. Imprimir mensaje final
    mov  ah, 09h
    mov  dx, fin_msg
    int  21h

    ; 5. Terminar programa y salir a DOS
    mov  ax, 4C00h           
    int  21h