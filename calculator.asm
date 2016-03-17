#################################################################
#								#
#		      CALCULATOR SIMULATOR			#
#		    ------------------------			#
#								#														#
# 	$t0 = Counter						#
# 	$t1 = Holds value of $t9 input				#	
# 	$t2 = Increment counter for ten_multiplier_loop		#
# 	$t3 = Holds result of ten_multiplier_loop		#
# 	$t4 = Unused						#
# 	$t5 = Unused						#
# 	$t6 = Unused						#
# 	$t7 = Unused						#
# 	$t8 = Displays value					#
# 	$t9 = Holds user input					#
# 	$s0 = Input counter					#
# 	$s1 = User entered value				#
# 	$s2 = User entered value				#
# 	$s3 = Holds result of user specified operation		#
# 	$s4 = Unused						#
# 	$s5 = Increment counter for division			#
# 	$s6 = Increment counter for multiplication		#
# 	$s7 = Counter for operation input			#
#								#
#################################################################

.text
	
wait:

	beq 	$t9, $zero, wait		# Wait for user input
	bne 	$t9, $zero, input		# Once user enters value, branch to input

input:
	
	add 	$t1, $zero, $t9			# Move value from $t9 to $t1
	andi 	$t1, $t1, 15			# Adjust value in $t1
	bne	$t1, $zero, check_operand	# Then branch to check_operand

check_operand:

	slti	$t0, $t1, 10			# If the value is from 0-9 branch to check_counter
	beq	$t0, 1, check_counter		# 
	beq	$t1, 10, pre_addition		# If the value is 10, branch to pre_addition
	beq	$t1, 11, pre_subtraction	# If the value is 11, branch to pre_subtraction
	beq	$t1, 12, pre_multiplication	# If the value is 12, branch to pre_multiplication
	beq	$t1, 13, pre_division		# If the value is 13, branch to pre_division
	beq	$t1, 14, equals			# If the value is 14, branch to equals
	beq	$t1, 15, clear			# If the value is 15, branch to clear
	
check_counter:

	addi	$s0, $s0, 1			# Increment $s0 counter as input is received
	add	$t0, $zero, $zero		# Reset $t0 counter
	slti	$t0, $s0, 2			# Check if $s0 is less than 2
	beq	$t0, 1, add_operand		# If $s0 is 1, branch to add_operand
	add  	$t2, $zero, $s1			# Set $t2 to $s1 for manipulation in branch
	beq	$t0, 0, ten_multiplier_loop	# If $s0 is not less than 2, branch to ten_multiplier_loop
	
display:

	add 	$t8, $zero, $s1			# Display the value in $s1
	j	reset_values			# Jump to reset_values

reset_values:

	add	$t0, $zero, $zero		# Reset the temporary values
	add	$t1, $zero, $zero		#
	add	$t2, $zero, $zero		#
	add	$t3, $zero, $zero		#
	add	$t9, $zero, $zero		#
	j	wait				# Jump to wait
	
ten_multiplier_loop:

	addi	$t5, $zero, 1
	beq  	$t2, $zero, add_operand		# If $t2 is 0, branch to add_operand
	addi  	$t3, $t3, 10			# Add 10 to the value of $t3
	sub 	$t2, $t2, $t5			# Decrement the $t2 value
	bne  	$t2, $zero, ten_multiplier_loop	# If $t2 does not equal 0, loop ten_multiplier_loop
	
add_operand:

	add	$t3, $t3, $t1			# Add the $t1 value to $t3
	add	$s1, $zero, $t3			# Move the value of $t3 to #s1
	j	display				# Jump to display
	
pre_addition:

	add	$t0, $zero, $zero		# Reset the value of $t0
	slti	$t0, $s7, 1			# If $s7 is less than one, continue
	beq	$t0, 0, operation_check_add	# If $s7 is greater than one, branch to operation_check_add
	add	$t1, $zero, $s1			# Move value from $s1 to $t1
	add	$s0, $zero, $zero		# Reset the $s0 counter
	add	$s2, $zero, $s1			# Move value from $s1 to $s2 for new input
	addi	$s7, $zero, 2			# Set $s7 to 2 for equals branches to addition
	j	add_operand			# Jump to add_operand

operation_check_add:

	add 	$t8, $zero, $s3			# Display value in $s3
	add	$s2, $zero, $s3			# Move value from $s3 to $s2
	add	$s1, $zero, $zero		# Reset the value of $s1
	addi	$s7, $zero, 2			# Set $s7 to 2 for equals branches to addition
	j	reset_values			# Jump to reset_values

addition: 

	add 	$s3, $s1, $s2			# Add $s1 and $s2 values and store result in $s3
	add	$s7, $zero, $zero		# Reset value of $s7
	j	equals				# Jump to equals

pre_subtraction:

	add	$t0, $zero, $zero		# Reset value of $t0
	slti	$t0, $s7, 1			# If $s7 is less than one, continue
	beq	$t0, 0, operation_check_sub	# If $s7 is greater than one, branch to operation_check_sub
	add	$t1, $zero, $s1			# 
	add	$s0, $zero, $zero		# 
	add	$s2, $zero, $s1			# 
	addi	$s7, $zero, 3			# Set $s7 to 2 for equals branches to addition
	j	add_operand			# Jump to add_operand

operation_check_sub:

	add 	$t8, $zero, $s3			# Display value of $s3
	add	$s2, $zero, $s3			# Move $s3 value to $s2
	add	$s1, $zero, $zero		# Reset value of $s1
	addi	$s7, $zero, 3			# Set $s7 to 2 for equals branches to addition
	j	reset_values			# Jump to reset_values

subtraction:
	
	sub 	$s3, $s1,   $s2			# Subtract $s2 value from $s1 and store result in $s3
	add	$t0, $zero, $zero		# Reset value of $t0
	sub	$s3, $t0,   $s3			# Compensate for negative $s3 value
	add	$s7, $zero, $zero		# Reset value of $s7
	j	equals				# Jump to equals

pre_multiplication:

	add	$t0, $zero, $zero		# Reset value of $t0
	slti	$t0, $s7, 1			# If $s7 is less than one, continue
	beq	$t0, 0, operation_check_multi	# If $s7 is greater than one, branch to operation_check_multi
	add	$t1, $zero, $s1			# Move $s1 value to $t1
	add	$s0, $zero, $zero		# Reset value of $s0
	add	$s2, $zero, $s1			# Move $s1 value to $s2
	add	$s6, $zero, $s2			# Copy $s2 value to $s6
	addi	$s7, $zero, 4			# Set $s7 to 2 for equals branches to addition
	j	add_operand			# Jump to add_operand

operation_check_multi:

	add 	$t8, $zero, $s3			# Display value of $s3
	add	$s2, $zero, $s3			# Move $s3 value to $s2
	add	$s3, $zero, $zero		# Reset $s3 value
	add	$s6, $zero, $s2			# Copy $s2 value to $s6
	add	$s1, $zero, $zero		# Reset value of $s1
	addi	$s7, $zero, 4			# Set $s7 to 2 for equals branches to addition
	j	reset_values			# Jump to reset_values

multiplication:

	addi	$t5, $zero, 1
	add	$s7, $zero, $zero		# Reset value of $s7
	beq  	$s6, $zero, equals		# If counter is 0, branch to equals
	add  	$s3, $s3, $s1			# Subtract $s1 value from $s3
	sub 	$s6, $s6, $t5			# Decrememnt $s6 value
	j	multiplication			# Jump to multiplication
	
pre_division:

	add	$t0, $zero, $zero		# Reset the value of $t0
	slti	$t0, $s7, 1			# If $s7 is less than one, continue
	beq	$t0, 0, operation_check_div	# If $s7 is greater than one, branch to operation_check_div
	add	$t1, $zero, $s1			# Move $s1 value to $t1
	add	$s0, $zero, $zero		# Reset value of $s0
	add	$s2, $zero, $s1			# Move $s1 value to $s2
	add	$s5, $zero, $s2			# Move $s2 value to $s5
	addi	$s7, $zero, 5			# Set $s7 to 5 for equals branches to addition
	j	add_operand			# Jump to add_operand

operation_check_div:

	add 	$t8, $zero, $s3			# Display the value of $s3
	add	$s2, $zero, $s3			# Move the value of $s3 to $s2
	add	$s3, $zero, $zero		# Reset value of $s3
	add	$s5, $zero, $s2			# Move the value of $s2 to $s5
	add	$s1, $zero, $zero		# Reset value of $s1
	addi	$s7, $zero, 5			# Set $s7 to 5 for equals branches to addition
	j	reset_values			# Jump to reset_values

division:

	add	$s7, $zero, $zero		# Reset value of $s7
	beq	$s1, $s2, adjuster		# If $s1 equals $s2, branch to adjuster
	slt	$t0, $s1, $s2			# Check if $s1 is less than $s2
	beq  	$t0, $zero, equals		# If $t0 is zero, branch to equals
	sub 	$s2, $s2, $s1			# Subtract the value of $s1 from $s2
	addi  	$s3, $s3, 1			# Decrement the value of $s3
	j	division			# Jump to division

adjuster:

	sub	$s2, $s2, $s1			# Subtracts extra value from $s2 after first division
	addi	$s3, $s3, 1			# Increment $s3
	j	division			# Jump to division

equals:

	beq	$s7, 2, addition		# If $s7 is 2, branch to addition
	beq	$s7, 3, subtraction		# If $s7 is 3, branch to subtraction
	beq	$s7, 4, multiplication		# If $s7 is 4, branch to multiplication
	beq	$s7, 5, division		# If $s7 is 5, branch to division
	add 	$t8, $zero, $s3			# Display the calculated result
	add	$s2, $zero, $s3			# Move the result to $s2 for further input
	add	$s1, $zero, $zero		# Reset the $s1 operand
	addi	$s7, $s7, 1			# Increment $s7 for further input
	j	reset_values			# Jump to reset_values
	
clear:
	
	add 	$t9, $zero, $zero		# Reset saved values for new calculations
	add 	$t8, $zero, $zero		#
	add	$s0, $zero, $zero		#
	add	$s1, $zero, $zero		#
	add	$s2, $zero, $zero		#
	add	$s3, $zero, $zero		#
	add	$s7, $zero, $zero		#
	j	reset_values			# Jump to reset_values
