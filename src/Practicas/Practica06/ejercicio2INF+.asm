.data
    msg_titulo: .asciiz "Deteccion de infinito positivo"
    msg_operacion: .asciiz "Operacion 1.8e308 * 1.0e308"
    msg_resultado: .asciiz "es el valor en el registro "
    msg_inf: .asciiz "🚨 ERROR: El registro contiene +Infinito\n"
    msg_normal: .asciiz "✅ Valor normal en el registro\n"
    linea: .asciiz "\n"
    uno_double: .double 1.0
    cero_double: .double 0.0
    # Valores que generaran infinito
    num1: .double 1.8e308   # Numero muy cercano al limite
    num2: .double 1.0e308   # Otro numero grandote

.text
.globl main

main:
    li $v0, 4              # imprimimos el string
    la $a0, msg_titulo     
    syscall                
    
    #Operacion que vamos a realizar
    li $v0, 4              # Imprime el string  
    la $a0, msg_operacion
    syscall                
    
    # cargamos los valores
    ldc1 $f0, num1    # Cargamos 1.8e308 en $f0-$f1
    ldc1 $f2, num2    # Cargamos 1.0e308 en $f2-$f3
    
    # Operacion que genera infinito
    mul.d $f4, $f0, $f2    # Multiplicar: 1.8e308 * 1.0e308 = +infinito
                           # $f4-$f5 ahora contienen +Infinito
    
    # mostramos el valor del registro
    li $v0, 4              # Imprimimos el string
    la $a0, msg_resultado     #cargamos el mensaje
    syscall                
    
    li $v0, 3              # Imprimimos el double
    mov.d $f12, $f4        # Movemos el resultado a $f12 para imprimir
    syscall              
    
    li $v0, 4              
    la $a0, linea        
    syscall                
    
    # creamos un infinito conocido para poder compararlos 
    ldc1 $f6, uno_double   # Cargamos 1.0 en $f6-$f7
    ldc1 $f8, cero_double  # Cargamos 0.0 en $f8-$f9
    div.d $f10, $f6, $f8   # 1.0 / 0.0 = +infinito (infinito conocido)
    
    # Detectamos si es infinito
    c.eq.d $f4, $f10       # comparamos nuestro resultado == +infinito conocido
    bc1t es_infinito       # Si son iguales, es infinito positivo
    
    # Si no es infinito mostramos que es un nuemro normal
    li $v0, 4             
    la $a0, msg_normal     
    syscall                # Ejecutamos llamada al sistema
    j fin_programa         # Saltamos al final del programa

es_infinito:
    # muestra mensaje de error para el infinito
    li $v0, 4            
    la $a0, msg_inf       
    syscall                

fin_programa:
    # termina el programa
    li $v0, 10             # termina el programa
    syscall                # ejecutar llamada al sistema
