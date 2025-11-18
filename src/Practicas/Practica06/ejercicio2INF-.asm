.data
    msg_titulo: .asciiz "Infinito negativo\n"
    msg_operacion: .asciiz "Operación: -1.8e308 * 1.0e308\n"
    msg_resultado: .asciiz "Valor en el registro: "
    msg_neg_inf: .asciiz "🚨 ERROR: El registro contiene -Infinito\n"
    msg_normal: .asciiz "✅ El valor en el registro es normal\n"
    linea: .asciiz "\n"
    #valores para que generemos el infinito negativo
    neg_gran_num: .double -1.8e308  # numero negativo muy grande
    gran_num: .double 1.0e308   # numero muy grande pero positivo
    neg_uno_double: .double -1.0
    cero_double: .double 0.0

.text
.globl main

main:
    li $v0, 4              # imprimimos string
    la $a0, msg_titulo     #carmamos el mensaje del titulo
    syscall                # ejecutamos la llamada al sistema
    
    # mostramos la operacion que se va a realizar
    li $v0, 4                
    la $a0, msg_operacion  
    syscall                
    
    # cargamos los valores en los registros
    ldc1 $f0, neg_gran_num # Cargamos -1.8e308 en $f0-$f1 (numero grandote negativo)
    ldc1 $f2, gran_num     # Cargamos 1.0e308 en $f2-$f3 (numero grandote positivo)
    
    # generamos el infinito negativo
    mul.d $f4, $f0, $f2    # Multiplicar: -1.8e308 * 1.0e308 = -infinito
                           # $f4-$f5 ahora contienen -Infinito
    
    # mostramos el valor del registro
    li $v0, 4              
    la $a0, msg_resultado    
    syscall               
    
    li $v0, 3              # Imprime el double
    mov.d $f12, $f4        # mueve el resultado a $f12 para imprimir
    syscall                # Ejecutar llamada al sistema
    
    li $v0, 4              
    la $a0, linea        # Cargar salto de línea
    syscall               
    
    # creamos un infinito conocido para poder hacer la comparacion
    ldc1 $f6, neg_uno_double # Cargar -1.0 en $f6-$f7
    ldc1 $f8, cero_double    # Cargar 0.0 en $f8-$f9
    div.d $f10, $f6, $f8     # -1.0 / 0.0 = -infinito (infinito negativo conocido)
    
    # detectamos si el valor del infinito es negativo
    c.eq.d $f4, $f10       # Comparamos nuestro resultado == -infinito conocido
    bc1t es_infinito_neg   # Si son iguales, es infinito negativo
    
    # si no es infinito negativo
    li $v0, 4              
    la $a0, msg_normal     # Cargamos mensaje de valor normal
    syscall                
    j fin_programa         # Saltamos al final del programa

es_infinito_neg:
    # mostramos mensaje de error para el infinito negativo
    li $v0, 4             
    la $a0, msg_neg_inf    # Carga mensaje de error infinito negativo
    syscall                

fin_programa:
   
    li $v0, 10             # termina el programa
    syscall                # Ejecutar llamada al sistema
