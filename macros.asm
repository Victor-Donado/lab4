; macros.asm — Biblioteca de macros utilitarias (Paso 1 y 2)

; Macro: terminar programa DOS con código de salida 0
%macro fin_dos 0
    mov  ax, 4C00h
    int  21h
%endmacro

; Macro: imprimir nueva línea (CR + LF)
%macro nueva_linea 0
    mov  ah, 02h
    mov  dl, 0Dh
    int  21h
    mov  dl, 0Ah
    int  21h
%endmacro

; Macro: imprimir cadena terminada en "$" (%1 = etiqueta)
%macro print_str 1
    mov  ah, 09h
    mov  dx, %1
    int  21h
%endmacro

; Macro: imprimir un carácter único (%1 = valor ASCII)
%macro print_char 1
    mov  ah, 02h
    mov  dl, %1
    int  21h
%endmacro

; Macro: leer un carácter desde teclado (sin eco) -> AL
%macro leer_char 0
    mov  ah, 07h
    int  21h
%endmacro

; Macro: imprimir una cadena N veces (%1=etiqueta, %2=repeticiones)
%macro repetir_str 2
    mov  cx, %2             ; CX = contador de repeticiones
%%ciclo:                    ; %% genera etiqueta única local
    mov  ah, 09h
    mov  dx, %1
    int  21h
    loop %%ciclo            ; CX--; si CX != 0, repetir
%endmacro

; Macro: imprimir dígito decimal de un valor 0-9 almacenado en AL
%macro print_digito 0
    push ax                 ; Preservar AX
    and  al, 0Fh            ; Asegurar nibble bajo (0-9)
    add  al, 30h            ; Convertir a ASCII
    mov  ah, 02h
    mov  dl, al
    int  21h
    pop  ax                 ; Restaurar AX
%endmacro