.globl mergeSort

.text
	mergeSort:
		addi $sp, $sp, -32
		sw $ra, 0($sp)         # Save return address
		sw $s0, 12($sp)
		sw $s1, 16($sp)
		sw $s2, 20($sp)
		sw $s3, 24($sp)
		sw $s4, 28($sp)
		
		li $s3, 1			#comparer variable
		move $s1, $a0			#load base arr
		move $s2, $a1			#load arr size
		move $s4, $a1			#saving original arr size

		
		ble $s2, $s3, base_case_return	#if size <=1 base case hit
		li $t0, 2
		div $s2, $t0			#half = size/2
		mflo $s0
		move $a0, $s1			#load base add for left half
		move $a1, $s0			#load new size for the left half

	aligned_left:
		jal mergeSort			#call recursive


		li $t0, 4			#offset
		mul $t1,$t0, $s0


		addu $a0, $s1, $t1		#move array pointer to middle for right half
		subu $a1, $s4, $s0		#(arr size - left size)

	aligned_right:
		jal mergeSort			#Recursive call,  right half

		move $a0, $s1			#setting base arr add for merge
		move $a1, $s4			#original array size for merge
		jal merge			#merge call
		
	base_case_return:

		lw $ra, 0($sp)
		lw $s0, 12($sp)    
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)        
		addi $sp, $sp, 32      #reset stack pointer
		jr $ra                 