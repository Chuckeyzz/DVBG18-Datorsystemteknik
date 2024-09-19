.data
	prompt: .asciiz "\nPlease enter a number to find out if it's odd or even : \n"
	nr_even: .asciiz "\nThe number you have entered is even."
	nr_odd: .asciiz "\nThe number you have entered is odd"
	not_nr: .asciiz "\nPlease enter an integer : \n"
.text

	main:
		li $v0 4
		la $a0 prompt
		syscall
		
		li $v0 5
		syscall
		move $t1 $v0
		
		#aritmetik här
		li $t2 2
		div $t1 $t2
		mfhi $t2		#flytta rest från divsion: t1/2 till t2 
		bgtz $t2 nrisodd	#om rest != 0, kör subrutin
		beqz $t2 nriseven 	#om rest = 0, kör subrutin
 
	
		.include "print.s"
		
	nriseven:
		la $a0 nr_even
		jal print
		li $v0 10
		syscall
	
		
	nrisodd:
		la $a0 nr_odd
		jal print
		li $v0 10
		syscall