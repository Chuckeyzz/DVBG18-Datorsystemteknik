.include "print.s"

.data
	prompt: .asciiz "Please enter a letter: "
	answer: .asciiz "The neighbouring letters are: "
	space: .asciiz "\n"
.text
main:

	li $v0 4  		#printf promt
	la $a0 prompt
	syscall
	
	li $v0 12		#scanf till v0
	syscall
	
	move $t0 $v0		#t0 = v0 
	addi $t1 $t0 -1		#t1 = ascii-värde +1
	addi $t2 $t0 1		#t2 = ascii-värde -1
 	
	li $v0 4
	la $a0 space
	syscall
	
 	li $v0 4
 	la $a0 answer
 	syscall	

 	li $v0 4
	la $a0 space
	syscall
		
	li $v0 11
	la $a0 ($t1)
	syscall

	li $v0 11
	la $a0 ($t2)
	syscall	
	
	li $v0 10
	syscall