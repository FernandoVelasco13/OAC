.data

	G_double: .double 6.67384e-11
	mt_double: .double 5.97e24
	ml_double: .double 7.349e22
	r_double: .double 3.84e8
	
	G_float: .float 6.67384e-11
	mt_float: .float 5.97e24
	ml_float: .float 7.349e22
	r_float: .float 3.84e8
	
	Resultado_double: .asciiz "La fuerza gravitacional es(double): "
	Resultado_float: .asciiz "\nLa fuerza gravitacional es(float): "

.text
.globl main

	main:
	# Calculo usando doubles
		l.d $f0, G_double
		l.d $f2, mt_double
		l.d $f4, ml_double
		l.d $f6, r_double
		
		mul.d $f8, $f2, $f4
		mul.d $f10, $f6, $f6
		div.d $f14, $f8, $f10
		mul.d $f12, $f0, $f14
		
		li $v0, 4
		la $a0, Resultado_double
		syscall
		
		li $v0, 3
		syscall
		
	# Calculo usando floats
		l.s $f16, G_float
		l.s $f18, mt_float
		l.s $f20, ml_float
		l.s $f22, r_float
		
		mul.s $f24, $f18, $f20
		mul.s $f26, $f22, $f22
		div.s $f28, $f24, $f26
		mul.s $f30, $f16, $f28
		
		li $v0, 4
		la $a0, Resultado_float
		syscall
		
		li $v0, 2
		mov.s $f12, $f30
		syscall
	
	exit:
		li $v0, 10
		syscall