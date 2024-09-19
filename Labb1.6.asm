.data
	prompt: .asciiz "\nPlease enter an integer : "
	answer: .asciiz "\nThe sum of the numbers you have entered is : %d "
.text

		
	loop:   li $v0 4		#laddar prompt och skriver ut i konsoll
		la $a0 prompt
		syscall
		
		li $v0 5		#begär user input för int
		syscall
		
		beqz $v0 ifzero		#om input = 0, branch till ifzero subrutin

		move $t0 $v0		#flytta värdet till register t0
		add $t1 $t1 $t0 	#addera summorna av input och existerande värde i t0, lägg i t1
		
		li $v0 1		#print int
		move $a0 $t1		#flyttar summa till a0
		syscall
		
		j loop			#börja om igen
		
	ifzero: 			#om input = 0 
		la $a0 answer		#laddar answer text
		move $a1 $t1		#flytta värde för summan till a1 för printing
		jal print		#print
		
		li $v0 10		#avsluta program
		syscall
		
	.include "print.s"
