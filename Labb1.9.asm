.data
	myArray: .word 5,7,1,9,2,4,8,3,6
	arraySize: .word 9
	prompt: .asciiz "\nPlease entere the number you are searching for : "
	loopCount: .word 0

.text
	main:
		subu $sp $sp 16			#moving stackpointer backwards 4 words

		li $v0 4			#skriver ut prompt för user input
		la $a0 prompt 
		syscall
		
		li $v0 5			#scanf %d
		syscall
		
		li $s0 0			#prepping loop counter
		la $a0 myArray			#loading array
		lw $a1 loopCount		#loading loop counter
		move $a2 $v0			#moving user input to a2
		lw $a3 arraySize		#loading array size
		
		la $t9 linsear			#linsear.s is placed outside of the 26-bit range for the regular jal instruction 
		jalr $t9			#the jalr instruction allows us to jump the entire 32-bit range needed.

	exit: 
		addu $sp $sp 16			#resetting the stackpointer
		li $v0 10			#return 0
		syscall	
.include "print.s"		
.include "linsear.s"
