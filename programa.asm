;  Constantes 
CR              EQU  0Dh         ; Retorno de carro
LF              EQU  0Ah         ; Salto de linea
FIN_CADENA      EQU  24h         ; Simbolo "$" para DOS

;  Segmento de Pila (Obligatorio para .EXE) 
segment stack stack
    resb 256        ; Reserva 256 bytes para la pila

;  Segmento de Datos (Inicializados) 
segment data
    titulo      db "=== Calculadora Basica NASM ===", CR, LF, FIN_CADENA
    linea       db "===============================", CR, LF, FIN_CADENA
    
    msg_suma    db "Realizando suma...", CR, LF, FIN_CADENA
    msg_resta   db "Realizando resta...", CR, LF, FIN_CADENA
    msg_exito   db "Operaciones completadas con exito.", CR, LF, FIN_CADENA

    operando1   db  15
    operando2   db  10

;  Segmento de Datos No Inicializados 
segment bss
    res_suma    resb 1
    res_resta   resb 1

;  Segmento de Codigo 
segment code
..start:                     ; Punto de entrada estandar para NASM/ALINK
    ; 1. Inicializar el segmento de datos
    mov  ax, data            
    mov  ds, ax              

    ; 2. Imprimir titulo
    mov  ah, 09h             
    mov  dx, titulo          
    int  21h                 

    mov  dx, linea
    int  21h

    ; 3. Imprimir mensaje de suma
    mov  dx, msg_suma
    int  21h

    ; --- Simulacion de calculo: Suma ---
    mov  al, [operando1]     ; Cargar el valor de operando1 (15) en AL
    add  al, [operando2]     ; Sumar operando2 (10). AL = 25
    mov  [res_suma], al      ; Guardar en res_suma

    ; 4. Imprimir mensaje de resta
    mov  dx, msg_resta
    int  21h

    ; --- Simulacion de calculo: Resta ---
    mov  al, [operando1]     ; Cargar operando1 (15) en AL
    sub  al, [operando2]     ; Restar operando2 (10). AL = 5
    mov  [res_resta], al     ; Guardar en res_resta

    ; 5. Imprimir mensaje de exito
    mov  dx, linea
    int  21h
    
    mov  dx, msg_exito
    int  21h

    ; 6. Salir al DOS limpiamente
    mov  ax, 4C00h           
    int  21h