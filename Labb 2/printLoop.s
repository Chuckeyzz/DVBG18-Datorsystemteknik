.globl printLoop
.data    
	Space: .asciiz " %d"
.text

	printer: 
		addi $sp $sp -40		#gave the stack some extra room to handle jal print
		sw $ra 0($sp)			#saving return address
		sw $a0 4 ($sp)			#saving myArray on the stack
		sw $a1 8 ($sp)			#saving arraysize on the stack
		sw $s0 12 ($sp)			#saving s-registers on the stack
		sw $s1 16 ($sp)
		sw $s2 20 ($sp)
			
		li $s0 0			#setting loop counter
		lw $s1 8($sp)			#load the array size to $s1
		lw $s2 4($sp)			#load array to s2
		

        
	printLoop:
		beq $s1 $s0 printFinished	#check if loop counter == array size

		lw $t2 0($s2)			#load value at the position of array
		move $a1 $t2  
		la $a0 Space			#move the value from array position to $a0 for print
		addi $sp $sp -16
		jal print
		addi $sp $sp 16
		addi $s0 $s0 1			#increment loop counter
		addi $s2 $s2 4			#increment array address by 4 bytes (1 word)
		
		j printLoop			#jump back to the loop
        
	printFinished: 
				
		lw $ra 0($sp)			#restore return address
		lw $a0 4 ($sp)			#restoring a registers
		lw $a1 8 ($sp)			
		lw $s0 12 ($sp)			#restoring s registers
		lw $s1 16 ($sp)
		lw $s2 20 ($sp)			
		addi $sp $sp 40			#resetting stack-pointer 
		jr $ra				#jump to return address 
