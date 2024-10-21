    .globl merge
    .text

	merge:
						#a0 holds array address 
						#a1 holds arrsize
		subu $sp, $sp, 32		#make space on the stack
		sw $s0, 0($sp)             
		sw $s1, 4($sp)               
		sw $s2, 8($sp)               
		sw $s3, 12($sp)              
		sw $s4, 16($sp)
		sw $s5, 20($sp)           
		sw $s6, 24($sp)             
		sw $ra, 28($sp)			#save ra

		srl $s0 $a1 1			#s0 = half (size/2)
		li $s1 0			#i = 0
		move $s2 $s0			#j = half
		li $s3 0			#k = 0
		move $s4 $a0			#address for array
		li $s5 0			#loop-counter
		
		sll $t0 $a1 2			#t0 = size *  4 for array address offset
		subu $sp $sp $t0		#dynamically adjust stack to fit arr b[]
		move $s6 $sp			#moving stack pointer value to s6	

	merge_loop: 
		bge $s5 $a1 while1		#if i <= size branch to while
		sll $t1 $s5 2 			#set t1 to i * 4
		add $t2 $s4 $t1			#increment arr address
		lw $t3 ($t2)			#t2 = a[i]
		add $t4 $s6 $t1			#increment temp arr address
		sw $t3 ($t4)			#b[i] = a[i] (t2)
		addi $s5 $s5 1			#i++
		j merge_loop
		
	while1:
		bge $s1 $s0 while2
		bge $s2 $a1 while2
		
		sll $t1 $s1 2 			#i set to i*4 for adress offset
		add $t1 $t1 $s6			#add offset to temp arr pointer on stack
		lw $t2 ($t1)			#load b[i] to t2
		sll $t3 $s2 2 			#setting j*4 for address offset
		add $t3 $t3 $s6			#add offset to temp arr pointer on stack
		lw $t4 ($t3)			#load b[j] to t4
		ble $t2 $t4 if1			#if b[i] <= b[j], branch to if1
	#else condition
		sll $t5 $s3 2			#k*4 for offset
		add $t5 $t5 $s4			#add offset to base array address
		sw $t4 ($t5)			#store value from arr
		addi $s2 $s2 1			#j++
			
		j k_incr		


	if1: 
		sll $t5 $s3 2 			#k*4 for arr offset
		add $t5 $t5 $s4			#increment base arr by offse
		sw $t2 ($t5)			# a[k] = b[j]
		addi $s1 $s1 1			#i++
	
	k_incr:
		addi $s3 $s3 1			#k++ instead of k_increment
		j while1	
		
	while2:
		bge $s1 $s0 while3
		sll $t1 $s1 2			#i*4 for offset
		add $t1 $t1 $s6 		#increment temp arr address
		lw $t2 0($t1)			#load word to b[i]
		sll $t3 $s3 2			#k*3 for offset
		add $t3 $t3 $s4			#increment base arr
		sw $t2 0($t3)
		addi $s1 $s1 1 			#i++
		addi $s3 $s3 1			#k++
		j while2
		
	while3:
		bge $s2 $a1 merge_done		#if j >= size, merge_done
		sll $t1 $s2 2 			#j *4 for array offset
		add $t1 $t1 $s6 		#increment temp arr address
		lw $t2 ($t1)			#lw to b[i]
		sll $t3 $s3 2			#k*4 for array offset
		add $t3 $t3 $s4			#increment base arr address
		sw $t2 ($t3)			#a[k] = b[j]
		addi $s2 $s2 1			#j++
		addi $s3 $s3 1 			#k++
		j while3

	merge_done:
		sll $t0, $a1, 2			#t0 = size * 4
		addu $sp, $sp, $t0		#restore stack allocation for b[]
		
		lw $s0, 0($sp)                       
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $ra, 28($sp)
		addu $sp, $sp, 32		#reset stack pointer
		jr $ra