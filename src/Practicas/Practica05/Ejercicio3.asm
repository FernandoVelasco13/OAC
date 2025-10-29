.data

	mensaje: .asciiz "Error, el resultado es negativo."

.text
.globl main

	main:
		li $t0, 5
		li $t1, 6
		
		sub $t2, $t0, $t1
		
		bgtz $t2, positivo
		
		li $v0, 4
		la $a0, mensaje
		syscall
		
		j exit
		
	positivo:
		li $v0, 1
		move $a0, $t2
		syscall
	
	exit:
		li $v0, 10
		syscall
