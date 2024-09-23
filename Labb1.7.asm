.data
	n: .word 10
	prompt: .asciiz "\Please enter an integer : "
	answer: .asciiz "\The largest number is %d and the smallest number is %d"
	
.text
	main:
		li $t1 0		#loop-variabel
		li $t2 1000000		#small-variabel
		li $t3 0 		#big-variabel
		lw $t4 n		#laddar n till t4
											
	loop:	
		beq $t1 $t4 exit	#if n = 10, exit
		li $v0 4		#for i<n (10) take int
		la $a0 prompt
		syscall
		
		li $v0 5		#tar in int
		syscall
		
		move $t0 $v0		#flytta input till t0
		addi $t1 $t1 1 		#n++
		blt $t0 $t2 ifsmall	#om t0 < t2 branch to ifsmall
		bge $t0 $t3 ifbig	#om t0 > t3 branch to ifbig
		j loop	
		
	ifbig:	
		add $t3 $t0 $zero	#om t0 är större än t3
		blt $t0 $t2 ifsmall	#kolla ifall att t0 är mindre än t2 också
		j loop
		
	ifsmall:		
		add $t2 $t0 $zero	#om t0 är mindre än t2
		bge $t0 $t3 ifbig 	#kolla om t0 är större än t3 också
		j loop	
		
	exit: 
		la $a0 answer
		move $a1 $t3
		move $a2 $t2
		subu $sp $sp 16		#adjusting stack pointer for print function
		jal print
		addu $sp $sp 16		#resetting stack pointer after print function
		li $v0 10
		syscall
				 
.include "print.s"
