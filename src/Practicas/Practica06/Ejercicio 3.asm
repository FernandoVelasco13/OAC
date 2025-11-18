.data
	a: .asciiz "Ingrese el coeficiente (a): "
	b: .asciiz "Ingrese el coeficiente (b): "
	c: .asciiz "Ingrese el coeficiente (c): "
	Resultado: .asciiz "El resultado es: \n"
	x1: .asciiz "x_1 es: "
	x2: .asciiz "\nx_2 es: "
	Discriminante: .asciiz "No hay solucion en los reales. "
	Indeterminado: .asciiz "No se puede encontrar una solucion, pues a = 0.0."
	
	constante_4: .double 4.0
	constante_2: .double 2.0
	constante_0: .double 0.0
	

.text
.globl main

	main:
		li $v0, 4
		la $a0, a
		syscall
		
		li $v0, 7
		syscall
		
		mov.d $f2, $f0 # Se guarda el valor de a en f2
		
		li $v0, 4
		la $a0, b
		syscall
		
		li $v0, 7
		syscall
		
		mov.d $f4, $f0 # Se guarda el valor de b en f4
		
		li $v0, 4
		la $a0, c
		syscall
		
		li $v0, 7
		syscall
		
		l.d $f20, constante_0
		l.d $f22, constante_2
		l.d $f24, constante_4
		
		c.eq.d $f2, $f20
		
		bc1t indeterminado
		
		mul.d $f6, $f4, $f4 # Se guarda el valor de b^2 en f6
		mul.d $f8, $f0, $f2 # Se guarda el valor de ac en f8 
		mul.d $f10, $f24, $f8 # Se guarda el valor de 4ac en f10
		sub.d $f14, $f6, $f10 # Se guarda el valor de b^2 - 4ac en f10
		
		c.lt.d $f14, $f20
		
		bc1t discriminante
		
		sqrt.d $f16, $f14
		sub.d $f4, $f20, $f4
		sub.d $f18, $f4, $f16 # Se guarda x1
		add.d $f26, $f4, $f16 # se guarda x2
		mul.d $f28, $f22, $f2
		
		li $v0, 4
		la $a0, Resultado
		syscall
		
		li $v0, 4
		la $a0, x1
		syscall
		
		div.d $f12, $f18, $f28
		
		li $v0, 3
		syscall
		
		li $v0, 4
		la $a0, x2
		syscall
		
		div.d $f12, $f26, $f28
		
		li $v0, 3
		syscall
		
		j exit
		
	indeterminado:
		li $v0, 4
		la $a0, Indeterminado
		syscall
		
		j exit
		
	discriminante:
		li $v0, 4
		la $a0, Discriminante
		syscall
	
	exit:
		li $v0, 10
		syscall