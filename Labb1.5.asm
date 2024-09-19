.data
	prompt: .asciiz "\nPlease enter an integer that you want to calulate the sum up to : \n"
	answer: .asciiz "\nThe sum is %d and the last added number was: %d"
	
.text

	main:
		li $v0 4		#printa promt
		la $a0 prompt
		syscall
		
		li $v0 5		#prompta user input
		syscall
		move $t0 $v0
		
	
	loop:	
		bge $t1 $t0 printsum	#när t1 är större eller lika med t0, brancha till print
		addi $t2 $t2 1	 	#loop counter		
		add $t1 $t1 $t2		#lägg till t2 till summan 
		j loop
		
	printsum: 
		la $a0 answer
		move $a1 $t1
		move $a2 $t2
		jal print
	
.include "print.s"