.data

	mensaje1: .asciiz "Ingresa el valor n: "
	mensaje2: .asciiz "Poder\n"

.text
.globl main

	main:
		# Se le pide al usuario el numero n.
		li $v0, 4
		la $a0, mensaje1
		syscall
		
		# El usuario ingresa el numero n.
		li $v0, 5
		syscall
		
		move $t0, $v0
		
		loop:
			beq $t0, $zero, exit
			
			# Se imprime el mensaje seleccionado
			li $v0, 4
			la $a0, mensaje2
			syscall
			
			addi $t0, $t0, -1
			
			j loop
		
	exit:
		li $v0, 10
		syscall
