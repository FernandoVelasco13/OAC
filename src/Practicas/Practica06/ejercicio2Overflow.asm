.data
    msg_titulo: .asciiz "Overflow"
    msg_operacion: .asciiz "Operacion: 1.0e308 * 10.0\n"
    msg_resultado: .asciiz "Valor en el registro: "
    msg_overflow: .asciiz "🚨 ERROR: El registro contiene valor con Overflow\n"
    msg_normal: .asciiz "✅ Valor normal en el registro\n"
    msg_valor_max: .asciiz "El limite maximo: 1.7976931348623157e+308\n"
    linea: .asciiz "\n"

    numero_gran: .double 1.0e308     # numero grande
    multi: .double 10.0        # multiplicador
    double_max: .double 1.7976931348623157e308  #maximo double IEEE 754

.text
.globl main

main:
    li $v0, 4              # imprime el string
    la $a0, msg_titulo      # carga la direccion del mensaje del titulo
    syscall                # ejecuta la llamada al sistema
    
    # operacion que vamos a realizar
    li $v0, 4               
    la $a0, msg_operacion  
    syscall                
    
    # cargamos los valores en los registros
    ldc1 $f0, numero_gran   # Cargamos 1.0e308 en $f0-$f1
    ldc1 $f2, multi   # Cargamos 10.0 en $f2-$f3
    ldc1 $f4, double_max   # Cargamos el double maximo en $f4-$f5
    
    # multiplicacion para el overflow
    mul.d $f6, $f0, $f2    # Multiplicamos 1.0e308 * 10.0 = 1.0e309, esto va a exceder a el máximo double representable
    
    # mostramos el valor del registro
    li $v0, 4              
    la $a0, msg_resultado    
    syscall                
    li $v0, 3              # imprimimos el double
    mov.d $f12, $f6        # movemos el resultado a $f12 para imprimir
    syscall                # ejecutamos la llamada al sistema
    
    li $v0, 4             
    la $a0, linea       
    syscall               
    
    # vamos a detectar el overflow comparandolo con el limite maximo
    abs.d $f8, $f6         # obtenemos el valor absoluto del resultado
    c.le.d $f8, $f4        # Comparamos |resultado| <= máximo_representable
    bc1f es_overflow       # Si es falso entonces es overflow (resultado > máximo)
    
    # muestra el limite maximo
    li $v0, 4             
    la $a0, msg_valor_max  
    syscall                
    
    # si no hay overflow emtonces se muesra el mensaje de valor normal
    li $v0, 4              
    la $a0, msg_normal     
    syscall                
    j fin_programa         # Saltamos al final del programa

es_overflow:
    # se muestra el error de overflow
    li $v0, 4              
    la $a0, msg_overflow  
    syscall                
fin_programa:
    li $v0, 10             # terminar programa
    syscall                # ejecutamos llamada al sistema
