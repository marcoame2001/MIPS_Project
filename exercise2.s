extractValues:

        lw $t0 4($sp) #M
        lw $t1 ($sp) #N
        blez $t0 devuelve
        blez $t1 devuelve
        mul $t2 $t0 $t1 #tamaño de la matriz
        li $t3 0 #contador


        while:bge $t3 $t2 fin
              lw $t4 ($a0) 
              andi $t5 $t4 0x80000000 #bit de signo
              srl $t5 $t5 31
              sw $t5 ($a1)

              andi $t5 $t4 0x7F800000 #exponente
               srl $t5 $t5 23
               sw $t5 ($a2)

              beqz $t5 no_normalizado #exponente 0000 0000
              beq $t5 0xFF no_normalizado #exponente 1111 1111

              normalizado:
                  andi $t6 $t4 0x7FFFFF #mascara
                  ori $t6 $t6 0x800000 #añade un 1 en bit 23
                j seguimos

              no_normalizado:
                  andi $t6 $t4 0x7FFFFF #mascara

              seguimos:
                  sw $t6 ($a3)

              addi $a0 $a0 4
              addi $a1 $a1 4
              addi $a2 $a2 4
              addi $a3 $a3 4
              addi $t3 $t3 1
              b while
        fin: 
            li $a0 0
            jr $ra
        devuelve:
            li $a0 -1
            jr $ra