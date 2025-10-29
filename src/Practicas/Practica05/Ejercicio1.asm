.data

#Como no podemos usar la memoria, no usamos .data

.text
.globl main

	main:
	
		addi $s0, $zero, 13 #Ponemos el valor 13 en el registro $s0.
		
		add $s1, $s0, $zero #Movemos el valor al registro $s1, usando add.
		
		li $v0, 1
		add $a0, $s1, $zero #Verificamos el resultado, imprimiendo el valor.
		syscall
		
		j exit
		
	exit:
		li $v0, 10
		syscall