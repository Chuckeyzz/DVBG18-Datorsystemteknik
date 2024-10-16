.data
	arraySize: .word 10
	myArray: .word 4,5,2,2,1,6,7,9,5,10
	mid: .word 0
	sortedArr: .asciiz "\nThe sorted array is :"
	notSortedArr: .asciiz "\nThe unsorted array is : "
	working: .asciiz "\nFINALLY\n"
.text

	main:

		la $a0 notSortedArr 		#printing message
		
		addi $sp $sp -16
		jal print
		addi $sp $sp 16
		
		la $a0 myArray			#loading array to a0
		lw $a1 arraySize		#loading arraysizes value to a1
		jal printer			#jump to printLoop
		
		
		la $a0 sortedArr 		#printing message
		
		addi $sp $sp -16
		jal print
		addi $sp $sp 16
		
	#all of the above is for print array
		
		la $a0 myArray			#loading array to a0
		lw $a1 arraySize		#loading arraysizes value to a1
		jal mergeSort			#jump to mergesort
			

		
		la $a0 myArray			#loading array to a0
		lw $a1 arraySize		#loading arraysizes value to a1
		jal printer			#jump to printLoop
					
		li $v0 10 
		syscall
		
	
	
	.include "mergeSort.s"	
	.include "print.s"
	.include "printLoop.s"
	.include "merge.s"
