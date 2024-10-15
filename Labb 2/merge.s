.globl merge

.text
	merge:
    		# $a0 = base address of array (a)
    		# $a1 = size

		addi $sp, $sp, -64            #allocate space on the stack for the tempArray
		move $s0, $a0                 #save the base address of the array (a)
		move $s1, $a1                 #save the size of the array (size)
		divu $s2, $s1, 2              #half = size / 2 (s2 = half)

		#copy array a[] to temporary array b[] stored on the stack
		li $t0, 0                    # i = 0 (index for left half)
		move $t6, $sp                # temp pointer to base of stack

	copy_loop:
		bge $t0, $s1, copy_done   	# if i >= size, exit the loop
		lw $t1, 0($s0)            	# load a[i] into $t1
		sw $t1, 0($t6)            	# store b[i] on the stack (using temp pointer)
		addi $s0, $s0, 4          	# increment array pointer a++
		addi $t6, $t6, 4          	# move temp pointer (for b++)
		addi $t0, $t0, 1          	# i++
		j copy_loop              	# jump back
    		
	copy_done:
    		#make loop index correct for merge
		move $s0, $a0			#resetting $s0
	    	li $s3, 0			#i = 0 , left side
    		move $s4, $s2			#j = half,  right side
	    	li $s5, 0			#k = 0 (index for big array)

	merge_loop:
    		bge $s3, $s2, merge_leftover  #if i >= half, merge right half
    		bge $s4, $s1, merge_leftover  #if j >= size, merge left half

   	# Compare elements from left and right half
		addu $t4, $sp, $s4            # Calculate the address for b[j] (right half)
		lw $t3, 0($t4)                # Load b[j] from stack (right half)

		addu $t5, $sp, $s3            # Calculate the address for b[i] (left half)
		lw $t2, 0($t5)                # Load b[i] from stack (left half)


		ble $t2, $t3, merge_left      #if b[i] <= b[j], select from left half
		sw $t3, 0($s0)                #a[k] = b[j] (store value in array a)
		addi $s4, $s4, 1              #j++
		j merge_store                

	merge_left:
		sw $t2, 0($s0)                # a[k] = b[i] (store value in array a)
		addi $s3, $s3, 1              # i++

	merge_store:
		addi $s0, $s0, 4              #go to the next element in a
		addi $s5, $s5, 1              #k++
		j merge_loop                  #AGAIN
	
	merge_leftover:
	    #if the left half has remaining elements
		blt $s3, $s2, merge_remaining_left

	    #iif the right half has remaining elements
		blt $s4, $s1, merge_remaining_right

	merge_remaining_left:
		addu $t5, $sp, $s3            #calculate the address for b[i] (left half)
		lw $t2, 0($t5)                #load b[i] from left half
		sw $t2, 0($s0)                #dtore in a[k]
		addi $s3, $s3, 1              #i++
		addi $s0, $s0, 4              #a++
		j merge_leftover

	merge_remaining_right:
		addu $t6, $sp, $s4            #caclculate the address for b[j] (right half)
		lw $t3, 0($t6)                #load b[j] from right half
		sw $t3, 0($s0)                #store in a[k]
		addi $s4, $s4, 1              #j++
		addi $s0, $s0, 4              #a++
		j merge_leftover

	done:
		addi $sp, $sp, 64             #put the stack back 
		jr $ra                        #Return to caller
