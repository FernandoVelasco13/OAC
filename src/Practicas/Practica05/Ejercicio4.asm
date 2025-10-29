.data 
	numero1: .asciiz "Ingresa el primer numero: "
	numero2: .asciiz "Ingresa el segundo numero: "
	Suma: .asciiz "Suma: "
	Resta: .asciiz "\nResta: "
	Multiplicacion: .asciiz "\nMultiplicacion: "
	Division: .asciiz "\nDivision: "
	Cociente: .asciiz "\nCociente: "
	Residuo: .asciiz "\nResiduo: "
	Error: .asciiz "\nError, no se puede dividir entre 0."

.text
.globl main

	main:
		li $v0, 4
		la $a0, numero1
		syscall
		
		li $v0, 5
		syscall
		
		move $s0, $v0
		
		li $v0, 4
		la $a0, numero2
		syscall
		
		li $v0, 5
		syscall
		
		move $s1, $v0
		
		li $v0, 4
		la $a0, Suma
		syscall
		
		add $t0, $s0, $s1
		
		li $v0, 1
		move $a0, $t0
		syscall
		
		li $v0, 4
		la $a0, Resta
		syscall
		
		sub $t0, $s0, $s1
		
		li $v0, 1
		move $a0, $t0
		syscall
		
		li $v0, 4
		la $a0, Multiplicacion
		syscall
		
		mult $s0, $s1
		mflo $t0
		
		li $v0, 1
		move $a0, $t0
		syscall
		
		beq $s1, $zero, error
		
		li $v0, 4
		la $a0, Division
		syscall
		
		div $s0, $s1
		mflo $t0
		mfhi $t1
		
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
		li $v0, 10
		syscall