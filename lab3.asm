# Leer archivo
# Nota: El archivo debe residir en la misma ubicaciï¿½n que MARS
.data  
#final parejas 313
#inicio individual 314
	.align 2
diccionarioParejas: .byte 105,102,101,108,115,101,119,104,105,108,102,111,105,110,115,121,115,116,101,109,105,109,112,111,114,116,111,117,112,117,98,108,105,99,112,114,105,118,97,116,106,97,100,111,114,101,116,117,114,110,99,108,97,115,73,110,110,101,109,97,83,116,114,105,110,103,117,98,108,101,112,97,99,107,97,103,118,111,105,100,98,111,111,108,101,97,116,104,114,97,110,100,111,109,116,114,99,97,116,99,102,108,111,97,120,116,80,97,114,115,101,120,99,101,112,116,105,111,97,98,97,99,98,114,98,121,116,101,99,104,97,114,100,101,102,97,117,108,108,115,117,101,114,102,115,116,41,59,114,111,40,34,33,61,38,38,61,61,101,113,117,97,40,41,98,117,102,102,101,114,112,108,110,116,105,115,103,101,108,111,115,104,111,114,115,117,112,101,117,116,99,111,117,109,102,105,110,97,108,108,111,116,101,99,110,117,97,105,116,121,114,121,76,105,91,93,101,107,111,110,116,111,110,111,116,105,102,121,65,108,119,97,105,116,122,101,116,67,108,97,115,115,104,97,67,111,121,76,68,97,84,105,109,101,97,109,109,112,101,84,114,109,65,116,80,111,116,65,47,47,47,42,42,47,110,99,120,79,115,112,108,105,109,105,118,97,108,117,101,79,115,105,43,61,45,61,60,61,62,61,108,110,116,86,97,108,116,84,76,111,119,101,114,67	
	.align 0
diccionarioIndividual: .byte 32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126

space: .asciiz ", "

	.align 2
filename: .asciiz "digram_test.java"	# Nombre del archivo y el formato

	.align 2
buffer:	.space 10000		# Ubicacion
				# Nota: Sïmbolo es asignarle un label, los datos se almacenan de manera automï¿½tica
	.text	
		
	
	add $t0, $zero, 0
	li $v0, 13		# $v0 = 13 equivale a abrir un archivo
	la $a0, filename	# direccion de la cadena del nombre del archivo (reside en filename)
	li $a1, 0		# marca: 0 = leer, 1 = escribir
	li $a2, 0		# Esto es necesario pero al poner cero se ignora
	syscall			# Llamada al sistema a que haga lo que $v0 indique
	move $s6, $v0		# $v0 actua como la direccion correspondiente para manipular el archivo, pero esta se debe llevar a otro registro para
				# no perderlo (eso creo), descriptor de archivo
	
	li $v0, 14		# Cuando $v0 = 14 se lee el contenido del archivo
	move $a0, $s6		# Se obtiene el descriptor del archivo
	la $a1, buffer		# Direccion donde se almacena el contenido del archivo
	la $a2, 30000		# $a2 tendra la cantidad de caracteres del archivo
	syscall			# Llamada al sistema para que se lea el archivo
	
	addi $t9,$v0,1
	

	la $s0, buffer  		#Direccion de inicio del archivo
	la $s1, diccionarioParejas 	#Direccion de inicio del diccionario parejas
	la $t7, diccionarioParejas      #Copia de la direccion inicial del diccionario parejas
	la $a2, diccionarioIndividual		#Direccion de inicio del diccionario
	la $a3, diccionarioIndividual		#Copia de la direccion en la posicion inicial
	add $t0, $t0, $zero		#Contador a imprimir (posicion del diccionario)
	addi $t1,$t1,1			#Contador del archivo
	
	lb $s2, 0($s0)
	addi $t2, $s2, 0		#$t2  tiene el primero caracter del archivo
	addi $s0, $s0,1			
	lb $s3, 0($s0)
	addi $t3, $s3, 0		#$t3 tiene el segundo caracter del archivo

	lb $s4, 0($s1)
	addi $t4, $s4, 0		#$t4  tiene el primero caracter del diccionario pareja
	addi $s1, $s1,1			
	lb $s5, 0($s1)
	addi $t5, $s5, 0		#$t5 tiene el segundo caracter del diccionario pareja
	

final:	li $v0, 16		# Cerrar el archivo
	move $a0, $s6		# descriptor del archivo
	syscall			# llamada al sistema

	
			
ciclo: 
	beq $t1,$t9, exit
	jal compararParte1Parejas
	j ciclo



compararParte1Parejas: 
		
		beq $t0,314, compararindividual
		beq $t2,$t4,compararParte2Parejas
		addi $s1, $s1,1		
		lb $s4, 0($s1)
		addi $t4, $s4, 0		
		addi $s1, $s1,1		
		lb $s5, 0($s1)
		addi $t5, $s5, 0
		
		addi $t0,$t0,2
		jr $ra
		
compararParte2Parejas:
		beq $t3,$t5,escribirParejas
		addi $s1, $s1,1		
		lb $s4, 0($s1)
		addi $t4, $s4, 0		
		addi $s1, $s1,1		
		lb $s5, 0($s1)
		addi $t5, $s5, 0		
		addi $t0,$t0,2
		jal ciclo
####
escribirParejas: 
	li $v0, 1
	addi $a0, $t0,0
	syscall 				

	addi $t0,$t6,0
	addi $t1,$t1,2
	
	addi $s0, $s0, 1	
	lb $s2, 0($s0)
	addi $t2, $s2, 0		
	
	addi $s0, $s0,1	
	lb $s3, 0($s0)
	addi $t3, $s3, 0	
	
	li $v0, 4
	la $a0, space
	syscall 
	
	addi $s1, $t7,0
	lb $s4, 0($s1)
	addi $t4, $s4, 0		
	addi $s1, $s1,1			
	lb $s5, 0($s1)
	addi $t5, $s5, 0
	
	jal ciclo
	
				

compararindividual:
		
		lb $s4, 0($a2)
		addi $t4, $s4, 0
		beq $t2,$t4,escribirindividual
		
		addi $a2, $a2,1		
		lb $s4, 0($a2)
		addi $t4, $s4, 0
		addi $t0,$t0,1
		jal compararindividual
		
		
escribirindividual:

		li $v0, 1
		addi $a0, $t0,0
		syscall 
		
		addi $t0,$t6,0
		addi $t1,$t1,1
		
		addi $t2,$t3,0
		
		addi $s0, $s0,1	
		lb $s3, 0($s0)
		addi $t3, $s3, 0
		
		addi $s1, $t7,0
		addi $a2,$a3,0

		li $v0, 4
		la $a0, space
		syscall 				
		
		lb $s4, 0($s1)
		addi $t4, $s4, 0		
		addi $s1, $s1,1			
		lb $s5, 0($s1)
		addi $t5, $s5, 0
				
		jal ciclo	
		
						
exit: 
	li $v0,10
	syscall	

	

