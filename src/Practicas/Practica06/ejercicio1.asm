#EJERCICIO 1
.data
     resultado: .float 0.0 #Aproximación a pi
     cuatro: .float 4.0 
     uno: .float 1.0
     menos_uno: .float -1.0
     dos: .float 2.0
     cero: .float 0.0
     iteraciones: .word 1000000 #Numero de iteraciones (m)
     msg_resultado: .ascii "Aproximacion de pi: "
     
.text
.globl main 

       main:
           #Vamos a inicializar los registros
           lwc1 $f0, cuatro # $f0=4.0
           lwc1 $f1, uno # $f1=1.0
           lwc1 $f2, menos_uno #f2=-1.0
           lwc1 $f3, dos # $f3 =2.0
           #Inicializamos las variables
           lw $t0, iteraciones #$to =m (el contador de las iteraciones)
           li $t1, 0 # $t1=n (contador del bucle)
           lwc1 $f4, cero # $f4=suma=0.0
           lwc1 $f5, uno # $f5=signo_actual=1,0
 
    loop:
        # Verificamos si ya llegamos a las m iteraciones
        bge $t1, $t0, end_loop
        
        #Calculamos el denominador: 2*n+1
        mtc1 $t1, $f6 # transfiere el dato de $T1 a un registro de punto flotante $f6
        cvt.s.w $f6, $f6 #convierte de entero a flotante $f6=n 
        
        mul.s $f7, $f6, $f3  # $f7=2*n
        add.s $f7, $f7, $f1  #$f7=2*n+1
        
        #Calculamos el signo actual y el denominador
        div.s $f8, $f5, $f7  # $f8=término actual
        
        #Sumatoria
        add.s $f4, $f4, $f8 #suma += termino
        
        #Cambiamos el signo para la siguiente iteración
        mul.s $f5, $f5, $f2 #signo_actual *= -1.0
        
        #Incrementamos el contador
        addi $t1, $t1, 1 #n++
        
        j loop
        
     end_loop:
     
        #Multiplicamos la suma por 4 para ontener la aproximacion a pi
        mul.s $f12, $f4, $f0 #$f12=4*sumatoria
        
        #Guardardamos el resultado en memoria
        swc1 $f12, resultado
        
        #Imorimimos el mensaje
        li $v0, 4
        la $a0, msg_resultado
        syscall
        
        #Imprimimos el resultado
        li $v0,2
        syscall
        
        #Terminamos el programa
        li $v0, 10
        syscall
