#---------------------------------------------------------------------------------------------------------------------------------------------------------------------

Init:
    blez $a1 devolver #Si $a1 es 0, devuelve -1
    blez $a2 devolver #Si $a2 es 0, devuelve -1

    li $t0 0 #contador
    move $t1 $a0
    mul $t2 $a1 $a2

    while: bge $t0 $t2 exit #mientras el contador sea menor que el n de elementos, bucle
        sw $zero ($t1)
        addi $t1 $t1 4
        addi $t0 $t0 1
        b while
    exit:
        li $a0 0 #devuelve 0
        li $v0 1
        syscall
        jr $ra

    devolver: #devuelve -1
        li $a0 -1
        li $v0 1
        syscall
        jr $ra
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------

Add:
    #Comprueba a1 y a2 sean >0 
    blez $a1 devolver1
    blez $a2 devolver1

    #Comprueba si i,j,k,l están fuera de rango
      #Si son <0
    bltz $a3 devolver1
    lw $t0 8($sp)
    bltz $t0 devolver1
    lw $t0 4($sp)
    bltz $t0 devolver1
    lw $t0 ($sp)
    bltz $t0 devolver1
      #Si son >= que a1 a2
          #para las filas(a1)
    bge $a3 $a1 devolver1
    lw $t0 4($sp)
    bge $t0 $a1 devolver1
          #para las columnas(a2)
    lw $t0 8($sp)
    bge $t0 $a2 devolver1 
    lw $t0 ($sp)
    bge $t0 $a2 devolver1

    lw $t0 4($sp)
    bgt $a3 $t0 devolver1

    beq $a3 $t0 checkcol

    j codigo

    checkcol:
    lw $t0 8($sp)
    lw $t1 ($sp)

    bgt $t0 $t1 devolver1

    codigo:
    #determinamos posicion de memoria pos(i,j)
    mul $t0 $a3 $a2
    lw $t1 8($sp)
    add $t0 $t0 $t1
    mul $t0 $t0 4
    add $t0 $t0 $a0

    #determinamos posicion de memoria pos(k,l)
    lw $t1 4($sp)
    mul $t1 $t1 $a2
    lw $t2 ($sp)
    add $t1 $t1 $t2
    mul $t1 $t1 4
    add $t1 $t1 $a0

    while1: bgt $t0 $t1 exit1
        lw $t3 ($t0)
        add $t4 $t4 $t3
        addi $t0 $t0 4
        b while1

    exit1:
      li $a0 0 #devuelve 0
      li $v0 1
      syscall
      move $a0 $t4 #devuelve la suma de los valores de la matriz
      li $v0 1
      syscall
      jr $ra

    devolver1:  #devuelve -1
        li $a0 -1
        li $v0 1
        syscall
        jr $ra
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------

Compare:
    #Comprueba a1 y a2 sean >0 
    blez $a2 devolver2
    blez $a3 devolver2

    #Comprueba si i,j,k,l están fuera de rango
      #Si son <0
    lw $t0 12($sp)
    bltz $t0 devolver2
    lw $t0 8($sp)
    bltz $t0 devolver2
    lw $t0 4($sp)
    bltz $t0 devolver2
    lw $t0 ($sp)
    bltz $t0 devolver2
      #Si son >= que a2 a3
          #para las filas
    lw $t0 12($sp)
    bge $t0 $a2 devolver2
    lw $t0 4($sp)
    bge $t0 $a2 devolver2
          #para las columnas
    lw $t0 8($sp)
    bge $t0 $a3 devolver2 
    lw $t0 ($sp)
    bge $t0 $a3 devolver2
    
    #Si i es mayor que k
    lw $t0 12($sp) 
    lw $t1 4($sp)
    bgt $t0 $t1 devolver2
    
    #Si i es igual que k se salta a la etiqueta checkcol
    beq $t0 $t1 checkcol1
    
    j codigo1
    
    checkcol1:
    lw $t0 8($sp)
    lw $t1 ($sp)
    
    #si la j es mayor que la l, entonces (i,j) está después de (k,l)
    bgt $t0 $t1 devolver2

	codigo1:
    #determinamos posicion de memoria pos(i,j) de la Matriz A
    lw $t0 12($sp)
	mul $t0 $t0 $a3
    lw $t1 8($sp)
    add $t0 $t0 $t1
    mul $t0 $t0 4
    add $t0 $t0 $a0
    
    #determinamos posicion de memoria pos(i,j) de la Matriz B
    lw $t3 12($sp)
	mul $t3 $t3 $a3
    lw $t4 8($sp)
    add $t3 $t3 $t4
    mul $t3 $t3 4
    add $t3 $t3 $a1

    #determinamos posicion de memoria pos(k,l) de la Matriz A
    lw $t1 4($sp)
    mul $t1 $t1 $a3
    lw $t2 ($sp)
    add $t1 $t1 $t2
    mul $t1 $t1 4
    add $t1 $t1 $a0
	li $t6 0 #contador de veces que aparece el mismo elemento


	 #Apilamos los parametros $aN anteriores para no perderlos al llamar a la subrutina cmp
     addu $sp $sp -16
     sw $a0 12($sp)
     sw $a1 8($sp)
     sw $a2 4($sp)
     sw $a3 ($sp)
     
     #Quitamos los dos parametros innecesarios para llamada a subrutina cmp
	 li $a2 0
	 li $a3 0     
     
    while2: bgt $t0 $t1 exit2
        lw $a0 ($t0) 
        lw $a1 ($t3)
     	
        addu $sp $sp -4 #apila $ra
        sw $ra ($sp)
        
        jal cmp #llamada a subrutina cmp
        
        lw $ra ($sp)
        addu $sp $sp 4 #desapila $ra
    
        bnez $v0 aumentar
        
        j sig
        aumentar:
        addi $t6 $t6 1
        sig:
      	addi $t0 $t0 4
        addi $t3 $t3 4
        b while2

    exit2:
    
    #Recuperamos los parametros de pila anteriores
      lw $a0 12($sp)
      lw $a1 8($sp)
      lw $a2 4($sp)
      lw $a3 ($sp)
      
    #Desapilamos
      addu $sp $sp 12
    
    #Devolvemos 0, programa exitoso
      li $a0 0
      li $v0 1
      syscall
      move $a0 $t6
      li $v0 1
      syscall
      jr $ra

    devolver2:
        li $a0 -1
        li $v0 1
        syscall
        jr $ra
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------

Extract:
    #Comprueba a1 y a2 y P (en pila) sean >0 
    blez $a1 devolver3
    blez $a2 devolver3
    lw $t0 16($sp)
    blez $t0 devolver3

    #Comprueba si i,j,k,l están fuera de rango
      #Si son <0
    lw $t0 12($sp)
    bltz $t0 devolver3
    lw $t0 8($sp)
    bltz $t0 devolver3
    lw $t0 4($sp)
    bltz $t0 devolver3
    lw $t0 ($sp)
    bltz $t0 devolver3
      #Si son >= que a2 a3
          #para las filas
    lw $t0 12($sp)
    bge $t0 $a2 devolver3
    lw $t0 4($sp)
    bge $t0 $a2 devolver3
          #para las columnas
    lw $t0 8($sp)
    bge $t0 $a3 devolver3 
    lw $t0 ($sp)
    bge $t0 $a3 devolver3

	#Comprueba si el valor de la dimensión P no coincide con el número de elementos que realmente hay entre (i,j) y (k,l).
    
    	#calculamos el num de elementos entre los intervalos -- formula deducida por el equipo --> [(k-i+1) x N] - [(j+N-l-1)]	
        
        #(k-i+1) x N
    lw $t0 4($sp) #k
    lw $t1 12($sp) #i
    sub $t2 $t0 $t1
    addi $t2 $t2 1
    mul $t2 $t2 $a2
    
    	#(j+N-l-1)
    lw $t0 8($sp) #j
    lw $t1 ($sp) #l
    add $t3 $t0 $a2
    sub $t3 $t3 $t1
    addi $t3 $t3 -1
    
    	#[(k-i+1) x N] - [(j+N-l-1)]
    sub $t4 $t2 $t3
	lw $t5 16($sp)
    bne $t4 $t5 devolver3 
       
    
    #Si i es mayor que k
    lw $t0 12($sp) 
    lw $t1 4($sp)
    bgt $t0 $t1 devolver3
    
    #Si i es igual que k se salta a la etiqueta checkcol
    beq $t0 $t1 checkcol2
    
    j codigo2
    
    checkcol2:
    lw $t0 8($sp)
    lw $t1 ($sp)
    
    #si la j es mayor que la l, entonces (i,j) está después de (k,l)
    bgt $t0 $t1 devolver3


	codigo2:
    #determinamos posicion de memoria pos(i,j) de la Matriz A
    lw $t0 12($sp)
	mul $t0 $t0 $a2
    lw $t1 8($sp)
    add $t0 $t0 $t1
    mul $t0 $t0 4
    add $t0 $t0 $a0 
    
    lw $t1 16($sp) #P 
    li $t2 0 #counter

    while3: bge $t2 $t1 exit3
		lw $t3 ($t0)
        sw $t3 ($a3)
        addi $t0 $t0 4
        addi $a3 $a3 4
        addi $t2 $t2 1      
        b while3

    exit3:
      li $a0 0
      li $v0 1
      syscall
      jr $ra

    devolver3:
        li $a0 -1
        li $v0 1
        syscall
        jr $ra