.data
	prompt: .asciiz "\nPlease enter a year : \n"
	leap: .asciiz "\nThe year you have entered is a leap year!\n"
	notleap: .asciiz "\nThe year you have entered is NOT a leap year\n"
	space: .asciiz "\n"
	
.text
	main:
		li $v0 4		#skriver ut prompt 
		la $a0 prompt
		syscall
		
		li $v0 5		#promptar user input
		syscall
		move $t0 $v0		#flytta värdet
		
		li $t1 400		#laddar värden för divisioner
		li $t2 100
		li $t3 4
		
		div $t0 $t1 		#divide by 400
		mfhi $t4		#move remainder
		beqz $t4 Leap		#if remainder = 0, go to Leap func
		
		div $t0 $t3		#divide by 4 
		mfhi $t4		#move remainder
		beqz $t4 Leap2		#if remainder = 0, go to Leap2 func för att kolla om årtalet är jamnt delbart med 100
		
		
	
	NotLeap:			#Denna subrutin hanterar läget då årtalet är jämnt delbart med 400 men också med 100
		la $a0 notleap		#load prompt for not leap
		jal print		#call print.s
		
		li $v0 10		#laddar return 0
		syscall			#return 0

	Leap:				#Denna subrutin hanterar läget då årtalet är jämnt delbart med 4
		la $a0 leap		#laddar leap-labeln till a0
		jal print		#printa leap-label
		
		li $v0 10		#laddar return 0
		syscall			#return 0
		
		
	Leap1: 
		div $t0 $t3		#division med 4
		mfhi $t4		#flytta rest
		beqz $t4 Leap2		#om jämnt delbart med 4 brancha till Leap func
		
	Leap2:	
		div $t0 $t2		#divide input by 100
		mfhi $t5		#move remainder
		beqz $t5 NotLeap	#if remainder = 0 move to NotLeap func
		j Leap
		
.include "print.s"