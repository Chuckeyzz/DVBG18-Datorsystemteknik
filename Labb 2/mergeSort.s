	.globl mergeSort
	
.data
	test: .asciiz "\nit works!!\n"
	ERROR: .asciiz "\nERROR RETURN NOT WORKING\n"
	arrayMsg: .asciiz "\nArray state: "

.text
	mergeSort:

		li $s3 1			#setting comparer	
		move $s1 $a0 			#loading myArray from a0
		move $s2 $a1			#load array size 
		move $s4 $a1			#saving original array size for later use
		
		
				# Print array state before recursion
		la $a0, arrayMsg
		jal print
		move $a0, $s1			      # load base address of the array
		move $a1, $s2			      # load size of the array
		jal printer			      # print array
			
		ble $s2 $s3 return		#if (size <= 1 ){} BASE CASE
		
		addi $sp $sp -32
		sw $ra 0 ($sp)			#saving return address on the stack
		sw $s0 12 ($sp)			#saving s-registers on the stack
		sw $s1 16 ($sp)			#s1 = myArray
		sw $s2 20 ($sp)			#s2 = arraySize
		sw $s3 24 ($sp)			#comparer
		sw $s4 28 ($sp)			#original size

		
		# s1 contains address for myArray
		# s2 contains value for arraySize 
		# s4 contains original arraySize NOT FOR USE IN RECURSION
	
			#leftside merge	
		divu $s2 $s2 2			#int half =  size / 2
		la $a0 ($s1) 			#loading array address as inparameter
		move $a1 $s2			#loading new size as inparameter			
		jal mergeSort			#repeat mergeSort
		
			#mergeSortRight
		addu $s1, $s1, $s2		#move array pointer to the middle (right half)
		subu $a1, $s4, $s2		#calculate size for the right half (size = original size - half)
		jal mergeSort			#recursive call for the right half

		subu $s1 $s1 $s2
		move $a0 $s1			#handing address for base array to merge	
		move $a1 $s4 			#handing original arraysize to merge
		
		jal merge
		
	return:
		lw $ra, 0($sp)              	#restore return address
		lw $s0, 12($sp)			#restore $s0
		lw $s1, 16($sp)			#restore $s1
		lw $s2, 20($sp)			#restore $s2
		lw $s3, 24($sp)			#restore $s3
		lw $s4, 28($sp)			#restore $s4 (original size)
		addi $sp, $sp, 32		#move stack pointer back


		la $a0, arrayMsg
		addi $sp $sp -16
		jal print
		addi $sp $sp 16
		
		move $a0, $s1			      # load base address of the array
		move $a1, $s4			      # load original size of the array
		jal printer			      # print array
		

		
		lw $ra 0($sp)			#restore the return address once again
			#the return address here gets an offset of +1c... WHY????
		jr $ra				#return to caller
		
