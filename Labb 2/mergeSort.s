    .globl mergeSort

.text
mergeSort:
    # Initialize variables
    li $s3, 1              # Setting comparer (1)
    move $s1, $a0          # Load base address of the array from $a0
    move $s2, $a1          # Load array size from $a1
    move $s4, $a1          # Save original array size for later use

    # Base case: if size <= 1, return
    ble $s2, $s3, base_case_return

    # Stack management for recursive calls
    addi $sp, $sp, -32
    sw $ra, 0($sp)         # Save return address
    sw $s0, 12($sp)        # Save $s0
    sw $s1, 16($sp)        # Save $s1 (array pointer)
    sw $s2, 20($sp)        # Save $s2 (array size)
    sw $s3, 24($sp)        # Save $s3 (comparer)
    sw $s4, 28($sp)        # Save $s4 (original size)

    # Recursive call for the left half
    divu $s0, $s2, 2       # Calculate half = size / 2 (left half)
    move $a0, $s1          # Load base address of the left half
    move $a1, $s0          # Load new size for the left half (half size)
    
    # Ensure $a0 is word-aligned
    andi $t0, $a0, 3       # Check if the last 2 bits of $a0 are 0
    beqz $t0, aligned_left # If aligned, proceed
    # If not aligned, adjust $a0
    addi $a0, $a0, 3
    andi $a0, $a0, 0xFFFFFFFC

aligned_left:
    jal mergeSort          # Recursive call for the left half

    # Prepare for the right half
    lw $s2, 20($sp)        # Restore the original size of the array
    lw $s4, 28($sp)        # Restore the original total size

    addu $s1, $s1, $s0     # Move array pointer to the middle (right half)
    subu $a1, $s4, $s0     # Calculate size for the right half (total size - left size)

    # Ensure $s1 (right half pointer) is word-aligned
    andi $t0, $s1, 3       # Check if the last 2 bits of $s1 are 0
    beqz $t0, aligned_right # If aligned, proceed
    # If not aligned, adjust $s1
    addi $s1, $s1, 3
    andi $s1, $s1, 0xFFFFFFFC

aligned_right:
    move $a0, $s1          # Load base address of the right half
    jal mergeSort          # Recursive call for the right half

    # After recursion: Restore array pointer and prepare to call merge
    lw $s1, 16($sp)        # Restore original base address
    lw $s4, 28($sp)        # Restore original size for merging

    # Call merge function
    move $a0, $s1          # Pass base address of the array to merge
    move $a1, $s4          # Pass original array size to merge
    jal merge              # Call the merge function

base_case_return:
    # Stack and register restoration
    lw $ra, 0($sp)         # Restore return address
    lw $s0, 12($sp)        # Restore $s0
    lw $s1, 16($sp)        # Restore $s1
    lw $s2, 20($sp)        # Restore $s2
    lw $s3, 24($sp)        # Restore $s3
    lw $s4, 28($sp)        # Restore $s4
    addi $sp, $sp, 32      # Reset stack pointer

    jr $ra                 # Return to caller
