.data

#Diccionario Simple tiene 95 caracteres, 
#Diccionario de Parejas tiene 323 caracteres e inicia en 96
 	.align 0
diccionarioSimple: .byte 32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126
	.align 2
diccionarioParejas: .byte 40,41,60,62,91,93,61,61,105,102,99,108,97,115,33,61,112,117,98,108,105,99,112,114,105,118,97,116,110,117,108,108,40,34,114,101,116,117,114, 110,43, 43,41, 59,38, 38,45, 45,43, 61,101, 108,115, 101,118, 111,105, 100,116, 114,117,101,99, 111,110,116,105,110,111,116,116, 104,105, 115,124, 124,115, 119,105, 116,99, 104,99, 97,64,79,100, 101,102, 97,117, 108,114,102,108, 115,98, 114,101 ,97,97,99,114, 111,110, 101,106, 97,118, 97,119, 104,105, 108,100, 111,101, 116,115,116,42,61,46,42,60, 61,62, 61,93, 59,41 ,32,40, 39,117,98,108, 101,102, 111,98,111,111,108,112,108,108,111,110,103,97,114,103, 115,114, 121,47,61,45,61,112, 97,99, 107,97, 103,105, 109,112, 111,114, 116,97, 110,115,104,83,121,101,109,111,117,73, 110,46,108,46,115,46,103,61,32,105,111,117,116,115,99,109,97,83,116,116,111,116,101,110, 100,44,32,32, 40,101, 120,99,101,112,116,101,99,46, 97,65,114,114,99,76,105,101, 110,116,115,47,42,42,47,32,61,47,47,41,41,118,101,114,114,101,114,84,104,97, 100,102,105,110,99,115,117,112,101,120,79,92, 110,114,1155,111,109,111,115,113,115,105,122,101,79,98,106,101,99,116,119,115,73,79,101, 100,67, 111,116,105,111, 110,80,114,87,114,97, 120,106, 117,110,105,64,97,104,111,64,112,97,109,64,116,104,114,111,119,105,101,106, 100,98,99

	.align 2
directorioDiccionario:	.space 15000	

javaFile: .space 200000
directorioJavaFile: .ascii "digram_test.java"

espacio: .asciiz ", "
.text

#Para cargar y almacenar en memoria el Diccionario

	la $s0, directorioDiccionario  		#Direccion  del archivo
	la $a2, diccionarioSimple		#Direccion de la posicion inicial del diccionario simple
	la $a3, diccionarioSimple		#Copia de la direccion en la posicion inicial del diccionario simple
	la $s1, diccionarioParejas 	#Direccion de la posicion inicial del diccionario parejas
	la $s2, diccionarioParejas      #Copia de la direccion en la posicion inicial del diccionario parejas
	
	add $t0, $t0, $zero		#Contador de la posición del diccionario
	addi $t1,$t1,1			#Contador de la posición del archivo
  
  
  	###############################################################
	# Aquí se abre un archivo y se guarda la acción en un registro	
	.macro open_file (%file_address)
	li $v0, 13			# system call for open file
	la $a0, %file_address		# output file name
	li $a1, 0			# Open for writing (flags are 0: read, 1: write)
	li $a2, 0			# mode is ignored
	syscall				# open a file (file descriptor returned in $v0)
	move $s6, $v0 			# save the file descriptor 
	.end_macro
	
	###############################################################
	# Aquí guardamos todo el diccionario en memoria
	.macro read_file (%file_path, %buffer_length)
	li $v0, 14 		# system call for write to file
	move $a0, $s6		# file descriptor
	la $a1, %file_path	# address of buffer from which to write
	li $a2, %buffer_length	# hardcoded buffer length
	syscall			# write to file
	.end_macro
	
	###############################################################
	# Close the file 
	.macro close_active_file
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file
	.end_macro
	
	
	###############################################################
	# Standard for-loop	
	.macro for (%reg_iterator, %from, %to, %body_macro_name)
	add %reg_iterator, $zero, %from
	loop:
		%body_macro_name ()
		add %reg_iterator, %reg_iterator, 1
		ble %reg_iterator, %to, loop
	.end_macro
  
  
#Para leer el archivo Java
  	open_file (directorioJavaFile)
	read_file (javaFile, 200000)
	close_active_file

#Cargamos los "vectores" de la memoria con el javaFile

la $t2, javaFile

#Cargamos los primeros dos bytes del diccionario 
	lb $s3, 0($s1)
	addi $t3, $s3, 0		#$t3  tiene el primero caracter del diccionario pareja
	addi $s1, $s1,1			
	lb $s3, 0($s1)
	addi $t4, $s3, 0		#$t4 tiene el segundo caracter del diccionario pareja
	
#Cargamos los primeros dos bytes del java file 
	lb $s4, 0($t2)
	addi $t5, $s4, 0		#$t5  tiene el primero caracter del java file 
	addi $t2, $t2,1			#Aumentamos en 1 posición el java file 
	lb $s5, 0($t2)
	addi $t6, $s5, 0		#$t6 tiene el segundo caracter del java file 


# CICLO PRINCIPAL
## Indice del principalLoop principal, recorriendo el java file
addi $t8, $zero, 200000

principalLoop: 
	beq $t2,$t8, exit
	jal comparar
	j principalLoop

exit:
	li $v0,10
	syscall	

comparar:
	beq $t0,1, compararDiccionarioSimple #Si $t0 inicia en 1, va a comparar en el diccionario simple
	beq $t3,$t5,compararParejas2 #Compara si el primer el primer caracter dek jF con el primero del diccionario
	addi $s1, $s1,1		 #Aumenta la posicion del diccionaro de parejas
	lb $s4, 0($s1)
	addi $t5, $s4, 0		
	addi $s1, $s1,1		
	lb $s5, 0($s1)
	addi $t6, $s5, 0
		
	addi $t0,$t0,2
	jr $ra
	
	
compararParejas2:
		beq $t4,$t6, imprimirPosParejas
		addi $s1, $s1,1		
		lb $s4, 0($s1)
		addi $t5, $s4, 0		
		addi $s1, $s1,1		
		lb $s5, 0($s1)
		addi $t6, $s5, 0		
		addi $t0,$t0,2
		jal principalLoop
		
compararUnico:
		lb $s4, 0($a2)
		addi $t3, $s4, 0
		beq $t5,$t3,imprimirUnico
		addi $a2, $a2,1		
		lb $s4, 0($a2)
		addi $t3, $s4, 0
		addi $t0,$t0,1
		jal compararUnico
		
imprimirPosParejas: 
	li $v0, 1
	addi $a0, $t0,0
	syscall 				
	addi $t0,$t6,0
	addi $t2,$t2,2
	addi $t2,$t2, 1	
	lb $s2, 0($t2)
	addi $t5, $s2, 0		
	addi $t2, $t2,1	
	lb $s3, 0($t2)
	addi $t6, $s3, 0	
	li $v0, 4
	la $a0, espacio
	syscall 
	addi $s1, $t7,0
	lb $s4, 0($s1)
	addi $t3, $s4, 0		
	addi $s1, $s1,1			
	lb $s5, 0($s1)
	addi t4, $s5, 0
	jal principalLoop		
		
imprimirUnico:
		li $v0, 1
		addi $a0, $t0,0
		syscall 
		addi $t0,$t6,0
		addi $t2,$t2,1
		addi $t5,$t6,0
		addi $t2,$t2,1	
		lb $s3, 0($t2)
		addi $t6, $s3, 0
		addi $s1, $t7,0
		addi $a2,$a3,0
		li $v0, 4
		la $a0, espacio
		syscall 				
		lb $s4, 0(s1)
		addi $t3, $s4, 0		
		addi $s1, $s1,1			
		lb $s5, 0($s1)
		addi $t4, $s5, 0	
		jal principalLoop