
.data
	thresh: .word 204000
	prompt: .asciiz "\nVänligen mata in din brutto-inkomst : \n"
.text
	main:
		li $v0 4		
		la $a0 prompt
		syscall	
		
		li $v0 5
		syscall
		
		move $t0 $v0
		lw $t1 thresh
		ble $t0 $t1 lowroll	#kollar om t0 ligger under threshold
		bgt $t0 $t1 highroll	#kollar om t0 ligger över threshold
		
		
	lowroll:
		mul $t3 $t0 30 
		div $t4 $t3 100
		sub $t5 $t0 $t4
		move $a0 $t4
		jal print
		
		li $v0 10
		syscall
		
	highroll:
		lw $t2 thresh		#laddar threshold
		sub $t3 $t0 $t2		#subtrahera threshold
		div $t4 $t3 2		#räkna ut högre skattesats på summa över threshold
		
		mul $t5 $t2 30		#kopia på lowroll-funktion
		div $t6 $t5 100
		sub $t9 $t0 $t6
		#sub $t7 $t0 $t6
		
		sub $t8 $t9 $t4		#summera
		move $a0 $t8
		jal print
	
		li $v0 10
		syscall
	
	
.include "print.s"
