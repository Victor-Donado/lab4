; programa2.asm — Laboratorio NASM (Pasos 3 al 6 integrados)

%include "macros.asm"       ; Incluir biblioteca de macros

; ── Segmento de Pila (Obligatorio para ALINK) ─────────────────────────
segment stack stack
    resb 256

; ── Segmento de Datos ───────────────────────────────────────────────────
segment data
    titulo      db "=== Macros y Control de Flujo ===", 0Dh, 0Ah, 24h
    linea_a     db "[Linea A] Primera impresion", 0Dh, 0Ah, 24h
    linea_b     db "[Linea B] Segunda impresion", 0Dh, 0Ah, 24h
    msg_mayor   db "El valor mayor es: ", 24h
    msg_iguales db "Los valores son iguales.", 0Dh, 0Ah, 24h
    msg_fin     db "Fin del programa.", 0Dh, 0Ah, 24h

; ── Segmento de Datos No Inicializados ──────────────────────────────────
segment bss
    valor_a     resw 1
    valor_b     resw 1

; ── Segmento de Código ──────────────────────────────────────────────────
segment code
..start:
    ; 1. Inicializar el segmento de datos
    mov  ax, data
    mov  ds, ax

    ; 2. Encabezado con macro (Paso 3)
    print_str titulo

    ; 3. Demostración de repetir_str (Paso 3)
    repetir_str linea_a, 3
    repetir_str linea_b, 2

    ; 4. Demostración Bucle Acumulador: Suma 1+2+3 = 6 (Paso 4 y 6)
    mov  cx, 3
    call sumar_serie        ; AX = 6
    print_str msg_mayor     ; Se usa este mensaje según la guía
    print_digito            ; Imprime el "6"
    nueva_linea

    ; 5. Demostración Condicional: Comparar 9 vs 4 (Paso 6)
    mov  ax, 9
    mov  bx, 4
    call comparar_e_imprimir

    ; 6. Demostración Condicional: Comparar 5 vs 5 (Paso 6)
    mov  ax, 5
    mov  bx, 5
    call comparar_e_imprimir

    ; 7. Mensaje final y terminación usando macro
    print_str msg_fin
    fin_dos

; ── Procedimientos (Subrutinas) ─────────────────────────────────────────

; Procedimiento: suma acumulativa 1+2+3+...+N (Paso 4)
; Entrada: CX = N  |  Salida: AX = suma total
sumar_serie:
    push cx                 ; Preservar CX 
    xor  ax, ax             ; AX = 0 (Acumulador rápido)
.paso:
    add  ax, cx             ; AX += CX
    loop .paso              ; CX--; si CX != 0, continuar
    pop  cx                 ; Restaurar CX original
    ret

; Procedimiento: comparar AX y BX e imprimir el mayor (Paso 5)
comparar_e_imprimir:
    push ax
    push bx

    cmp  ax, bx             ; Comparar AX - BX
    je   .son_iguales       ; Salta si son iguales (ZF=1)
    jg   .ax_mayor          ; Salta si AX > BX

    ; Si llega aquí, BX es mayor
    print_str msg_mayor     
    mov  al, bl             ; Pasar el valor de BX a AL para imprimirlo
    print_digito            
    nueva_linea
    jmp  .fin_comp

.ax_mayor:
    print_str msg_mayor
    print_digito            ; Imprime AL (que todavía tiene el valor de AX)
    nueva_linea
    jmp  .fin_comp

.son_iguales:
    print_str msg_iguales

.fin_comp:
    pop  bx
    pop  ax
    ret