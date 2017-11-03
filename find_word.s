#=========================================================================
# Find_word
#=========================================================================
# Tokenizes words in a sentence given as input
#
# Inf2C Computer Systems Coursework 1
#
# Likhitha Sai Modalavalasa
#
# MIPS comments show how code corresponds to an equivalent C program.
# C comments within MIPS comments are used to add further details on
# the operation of the MIPS code and the use of registers.

        #==================================================================
        # DATA SEGMENT
        #==================================================================
        .data
        #------------------------------------------------------------------
        # Constant strings for output messages
        #------------------------------------------------------------------

input_sentence: .space 1001                     # char input_sentence[MAX_SENTENCE_LENGTH+1];
word:           .space 51                       # char word[MAX_WORD_LENGTH+1];
false:          .word 0                         # define false 0
true:           .word 1                         # define true 1
                                                
ch_a:           .byte 'a'                       # Character a for ASCII check 
ch_z:           .byte 'z'                       # Character z for ASCII check
ch_A:           .byte 'A'                       # Character A for ASCII check
ch_Z:           .byte 'Z'                       # Character Z for ASCII check
                                                
hyphen:         .byte '-'                       # Character '-' for hyphen equality check
newlinech:      .byte '\n'                      # Character '\n' for newline equality check
nullch:         .byte '\0'                      # Character '\0' for null character check 
                                                
prompt1:        .asciiz "Enter input:"          # Prompt 1 to be dispayed for entering input 
outmsg:         .asciiz "output:"               # outmsg to label output 
newline:        .asciiz  "\n"                   # Newline character 
                                                
                                                
.globl main                                        
                                                
.text    


if_hyphenandvalid:                              # Function to append to word if a hyphenated word
        addi $s3, $s3, 1                        # ++char_index;
        sb $t4, 0($s2)                          # w[char_index] = cur_char;
        addi $s2, $s2, 1                        # Incrementing adress of word to store next character
                                                #
        j process_input_loop                    # continue;
                                        
                                                
read_input:                                     # void read_input(const char* inp)
        li $v0, 4                               # Loading 4 to $v0 - print string 
        la $a0, prompt1                         # print_string("\nEnter input: ");
        syscall                                 # syscall to execute commands 
                                                #
        li    $v0, 8                            # Load 8=read_string into $v0
        la    $a0, input_sentence               # $a0=address of str   
        li    $a1, 1001                         # $a1= max str length
        move  $s0, $a0                          # moving $a0 to saved temporary register $s0
        syscall                                 # read string
                                                # read_string(input_sentence, MAX_SENTENCE_LENGTH+1);
        jr $ra                                  # Return to main 
                                                
is_valid_character:                             # Fuction to check if its a valid character 
        lb $t0, ch_a                            # Register guide: $t0, $t1, $t2, $t5 have characters 'a','z','A','Z' respectively 
        lb $t1, ch_z                            # $t5, $t6 registers are overwriiten to store the result of conditions after evaluation 
        lb $t2, ch_A                            # $v0 is the return value of function 
        lb $t7, ch_Z                            # $ra is the return address(process_input_loop)

        sle $t5, $a1, $t7                       # int is_valid_character(char ch) {
        sge $t6, $a1, $t2                       #   if ( ch >= 'a' && ch <= 'z' ) {
        and $t5, $t5, $t6                       #      return true;}
                                                #   else if ( ch >= 'A' && ch <= 'Z' ) {
        sle $t7, $a1, $t1                       #      return true;}
        sge $t8, $a1, $t0                       #   else {
        and $t6, $t7, $t8                       #      return false;}
                                                #
        or $v0, $t5, $t6                        # If the character is uppercase ($t5) or lowercase($t6), return true
                                                # Returns 0 if false and 1 if true 
        jr $ra                                  # Return to process_input_loop

is_hyphen:                                      # Function to check if the char is hyphen 
                                                # Register guide: $v1- return value 
        lb $t2, hyphen                          # $t4 - cur_char ; $t2- hyphen
        seq $v1, $t4, $t2                       # int is_hyphen(char ch)
        jr $ra                                  # if ( ch == '-' ) {
                                                #   return true; }

process_input:                                  # process_input loop which calls the process_input_loop
                                                # Register guide: $s3 - char_index, $s2 - address of word , $t3 - end_of_sentence
        li $s3, -1                              # int char_index = -1;
        la $s2, word                            # Loading address of word into $s2 register 
        li $t3, 0                               # int end_of_sentence = false; 
                                                #
        addi $sp, $sp, -4                       # Incrementing the stack downwards 
        sw $ra, 0($sp)                          # Storing the return address in stack 
                                                #
        jal process_input_loop                  # Jump and link to process_input_loop
                                                #
        lw $ra, 0($sp)                          # Loading return address address in stack
        addi $sp, $sp, 4                        # Decrementing stack pointer 
                                                #
        jr $ra                                  # Returning to main

process_input_loop:                             # int process_input(char* inp, char* w)
                                                # Function to process input and tokenize
        lb $t4, input_sentence($s0)             # cur_char = inp[input_index]; 
        addi $s0, $s0, 1                        # input_index++;
                                                # Loading cur_char into $t4 
        move $a1, $t4                           # Moving $t4 (cur_char) to $a1 to indicate as
                                                # argument sent to is_valid_character function 
        addi $sp, $sp, -4                       # Incrementing stack pointer index downwards 
        sw $ra, 0($sp)                          # Storing return address in stack
                                                #
        jal is_valid_character                  # is_valid_ch = is_valid_character(cur_char);

        lw $ra, 0($sp)                          # Loading main address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index 

        beq $v0, $zero, else_of_isvalid         #  if ( is_valid_ch ) {
        addi $s3, $s3, 1                        #     w[++char_index] = cur_char;
        sb $t4, 0($s2)                          #  }
        addi $s2, $s2, 1                        #  If character is valid, append to word array 
                                                #  Else jump to process_input_loop_end
        j process_input_loop_end                #  Jump unconditionally to process_input_loop_end

else_of_isvalid:                                # else {
        lb $t0, newlinech                       # Loading newline character to $t0
        lb $t1, nullch                          # Loading null character to $t1
        seq $t0, $t4, $t0                       # If cur_char == newline then set $t0 to 1 otherwise 0
        seq $t1, $t4, $t1                       # If cur_char == null then set $t0 to 1 otherwise 0
        or $t0, $t0, $t1                        # if ( cur_char == '\n' || cur_char == '\0' )
        sgt $t3, $t0, $zero                     # { end_of_sentence = true;}
                                                #
        move $t0, $s3                           # Loading char_index to $t0 
        blt $t0, $zero, punctuation             # if ( char_index >= 0 ) {
                                                #
        addi $sp, $sp, -4                       # Incrementing stack pointer index downwards 
        sw $ra, 0($sp)                          # Storing return address in stack
                                                #
        jal is_hyphen                           # is_hyphen(cur_char) == true
                                                #
        lw $ra, 0($sp)                          # Loading main address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index
                                                #
        lb $a1, input_sentence($s0)             # inp[input_index]
                                                #
        addi $sp, $sp, -4                       # Incrementing stack pointer index downwards
        sw $ra, 0($sp)                          # Storing return address in stack
                                                #
        jal is_valid_character                  # is_valid_character(inp[input_index])
                                                #
        lw $ra, 0($sp)                          # Loading main address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index
                                                #
        and $t1, $v0, $v1                       # is_hyphen(cur_char) == true && is_valid_character(inp[input_index])
                                                # Storing result in $t1 
        bnez $t1, if_hyphenandvalid             # if ( is_hyphen(cur_char) == true && is_valid_character(inp[input_index]) )
                                                #
        li $v1, 1                               # return true;
        addi $s3, $s3, 1                        # char_index++;
        lb $t4, nullch                          # w[char_index] = '\0';
        sb $t4, 0($s2)                          # Storing null at the end of the word 
        jr $ra                                  # Return to process_input

punctuation:
        lb $t4, nullch                          # w[0] = '\0';
        sb $t4, word                            # Setting word to null 
        li $s3, -1                              # char_index = -1;

process_input_loop_end:

        beqz $t3, process_input_loop            # while( end_of_sentence == false )
        li $v1, 0                               # return false;
        jr $ra                                  # Jump to main 


output:
        li $v0, 4                               # Loading 4 into $v0 - print string 
        la $a0, newline                         # print_string("\n");
        syscall                                 # syscall to execute commands
                                                #
        li $v0, 4                               # Loading 4 into $v0 - print string
        la $a0, word                            # a0 is the address of the word
        syscall                                 # syscall to execute commands

        jr $ra


main:
        jal read_input                          # read_input(input_sentence);
                                                #
        li $v0, 4                               # Loading 4 into $v0 - print string 
        la $a0, outmsg                          # print_string("\noutput:\n");
        syscall                                 # syscall to execute commands

        li $s0, 0                                 

loop:
        jal process_input                       # process_input(input_sentence, word);
                                                #
        move $t1, $v1                           # word_found = process_input(input_sentence, word);
        beq $t1, $zero, next                    #  if ( word_found == true )
        jal output                              # {output(word);}

next:
        beq $t3, $zero, loop                    # while ( word_found == true );
exit:
        li   $v0, 10                            # exit()
        syscall

        #------------------------------------------------------------------
        # End of file 
        #------------------------------------------------------------------

