.data 

	Cociente: .asciiz "El cociente es: "
	Residuo: .asciiz "\nEl residuo es: "
	Error: .asciiz "Error, no puedes dividir por 0."

.text
.globl main

	main:
		li $s0, 20
		li $s1, 6
		
		move $t0, $zero
		move $t1, $s0
		
		beq $s1, $zero, error
		
	loop:
		blt $t1, $s1, output
		
		sub $t1, $t1, $s1
		addi $t0, $t0, 1
		
		j loop
		
	output:
		li $v0, 4
		la $a0, Cociente
		syscall
		
		li $v0, 1
		move $a0, $t0
		syscall
		
		li $v0, 4
		la $a0, Residuo
		syscall
		
		li $v0, 1
		move $a0, $t1
		syscall
		
		j exit
	
	error:
		li $v0, 4
		la $a0, Error
		syscall
	
	exit:
		move $v0, $t0
		move $v1, $t1
	
		li $v0, 10
		syscall