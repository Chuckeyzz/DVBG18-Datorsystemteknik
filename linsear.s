	.globl linsear
.data 	
	answer: .asciiz "\nThe position of the number is %d. \n"
	nrmissing: .asciiz "\nThe number is missing\n"
.text
linsear:
	sw	$a0, 0($sp)		#array stored here
	sw	$a1, 4($sp)		#loop counter
	sw	$a2, 8($sp)		#user input
	sw	$a3, 12($sp)		#array size

loop:
	lw $t0 0($a0)			#loading first position in array
	beq $t0 $a2 match		#branch to match if the value at the address t0 = input 
	addi $a0 $a0 4			#increment t0 4 bytes for next position 
	bge $a1 $a3 notFound		#if array size = loop counter branch to not found
	addi $a1 $a1 1			#array counter++	
	j loop
match: 
	div $t0 $t0 4			#dividerar positionens offset med 4 för att få fram vilken position som värdet har 
	mflo $t0			#flyttar kvoten till t0
	addi $t0 $t0 1			#adderar 1 till kvoten för att få den "korrekta" positionen 
	la $a0 answer			#laddar answer till a0 inför print
	la $a1 ($t0)			#laddar positionen till a1 inför print
	
	subu $sp $sp 16			#adjusting stackpointer for printfunction
	la $s0 ($ra)			#saving return address to main in $s0
	jal print			#hoppar och länkar till print			
	addu $sp $sp 16			#resetting stackpointer
	la $ra ($s0)			#move return address backt to $ra
	jr $ra				#return to address at $ra
					
notFound:
	la $a0 nrmissing		#load nrmissing to a0 for print
	subu $sp $sp 16			#adjusting stackpointer for print function
	la $s0 ($ra)			#saving return address to main in $s0
	jal print 			#call print
	addu $sp $sp 16			#resetting stack pointer
	la $ra ($s0)			#move return address backt to $ra
	jr $ra				#jump back

