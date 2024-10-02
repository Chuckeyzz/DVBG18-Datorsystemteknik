.globl printLoop
.data    
	Space: .asciiz " "
.text

	printer: 

		sw $ra 0($sp)		
		sw $a0 4 ($sp)			#saving myArray on the stack
		sw $a1 8 ($sp)			#saving arraysize on the stack
			
		li $s0 0			#loop counter + 1 for off by one error
		lw $s1 8($sp)			#load the array size to $s1
		la $t1 ($s1)
		lw $s2 4($sp)			#load array to s2
		

        
	printLoop:
		beq $t1 $s0 printFinished	#check if loop counter == array size

		lw $t2 0($s2)			#load value at the position of array
		move $a0 $t2  			#move the value from array position to $a0 for print

		li $v0 1			#temp soloution until print.shit works
		syscall
		
		li $v0 4
		la $a0 Space
		syscall
		
		addi $s0 $s0 1			#increment loop counter
		addi $s2 $s2 4			#increment array address by 4 bytes (1 word)
		
		j printLoop			#jump back to the loop
        
	printFinished: 
		li $s0 0 			#reset loop counter
		li $s1 0 			#resetting s-reg that held array size
		lw $ra 0($sp)			#restore return address

		jr $ra				#jump to return address
