
#Como en general no podemos producir un NaN con una mulltiplicación, vamos a generarlo
#a partir de una multiplicacion de un NaN por otro numero, cero, o infinito ya que el resultado tambien es un NaN
.data
    msg_titulo:  .asciiz "NaN"
    msg_resultado: .asciiz "Resultado:\n "
    linea:    .asciiz "\n"
    cero_double:    .double 1.0
    zero_double:   .double 0.0
    nan_esnan: .asciiz "✅Es NaN"
.text
.globl main

main:
    # solo muestra el mensaje de NaN
    li $v0, 4
    la $a0, msg_titulo
    syscall
    
    # Generamos un NaN a partir de una division de cero entre cero 0.0 / 0.0 
    ldc1 $f0, cero_double   # 0.0
    ldc1 $f2, zero_double  # 0.0
    div.d $f4, $f0, $f2    # 0.0 / 0.0 
    
    # multiplicamos NaN × cero
    ldc1 $f6, zero_double  # 0.0
    mul.d $f8, $f4, $f6    # NaN × 0 = NaN
    #mul.d $f8, $f6, $f6 #0 x 0 (no es NaN)
    # Mostramos el resultado
    li $v0, 4
    la $a0, msg_resultado
    syscall
    
    li $v0, 3
    mov.d $f12, $f8
    syscall
    
    # Verificamos que realmente es NaN
    c.eq.d $f8, $f8        # NaN != NaN
    bc1f es_nan
    
    li $v0, 10
    syscall

es_nan:
    li $v0, 4
    la $a0, linea
    syscall
    la $a0, nan_esnan
    syscall
    li $v0, 10
    syscall
