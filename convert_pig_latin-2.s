#=========================================================================
# Convert Pig Latin 
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


input_sentence:     .space 1001                 # char input_sentence[MAX_SENTENCE_LENGTH+1];
output_sentence:    .space 1001                 # char output_sentence[(MAX_SENTENCE_LENGTH*3)+1];
before_vowel:       .space 51                   # char before_vowel[MAX_WORD_LENGTH+1];   //before_vowel array is an auxiliary array to store string before vowel
word:               .space 51                   # char word[MAX_WORD_LENGTH+1];
                                                
ch_a:               .byte 'a'                   # Character 'a' for vowel equality check 
ch_e:               .byte 'e'                   # Character 'e' for vowel equality check 
ch_i:               .byte 'i'                   # Character 'i' for vowel equality check 
ch_o:               .byte 'o'                   # Character 'o' for vowel equality check
ch_u:               .byte 'u'                   # Character 'u' for vowel equality check 

ch_E:               .byte 'E'                   # Character 'E' for vowel equality check 
ch_I:               .byte 'I'                   # Character 'I' for vowel equality check
ch_O:               .byte 'O'                   # Character 'O' for vowel equality check
ch_U:               .byte 'U'                   # Character 'U' for vowel equality check 

ch_z:               .byte 'z'                   # Character 'z' for ASCII check 
ch_A:               .byte 'A'                   # Character 'A' for ASCII check and vowel equality check    
ch_Z:               .byte 'Z'                   # Character 'Z' for ASCII check 
ch_y:               .byte 'y'                   # Character 'y' for appending at end of word
ch_Y:               .byte 'Y'                   # Character 'Y' for appending at end of word

hyphen:             .byte '-'                   # Character '-' for equality check 
newlinech:          .byte '\n'                  # Character '\n' for equality check 
nullch:             .byte '\0'                  # Character '\0' for equality check 

prompt1:            .asciiz "Enter input:"      # Prompt 1 to be dispayed for entering input 
outmsg:             .asciiz "output:\n"         # outmsg to label output 
newline:            .asciiz  "\n"               # Newline character  

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
        lb $t1, ch_z                            # $s5, $s4 registers are overwriiten to store the result of conditions after evaluation  
        lb $t2, ch_A                            # $v0 is the return value of function 
        lb $t7, ch_Z                            # $ra is the return address(process_input_loop)
                                                #  
        addi $sp, $sp, -8                       # Incrementing the stack downwards by 8 bits
        sw $s4, 4($sp)                          # To store $s4 for further use 
        sw $s5, 0($sp)                          # To store $s5 for further use 
                                                #
        sle $t5, $a1, $t7                       # int is_valid_character(char ch) {
        sge $t6, $a1, $t2                       #   if ( ch >= 'a' && ch <= 'z' ) {
        and $s4, $t5, $t6                       #      return true;}
                                                #   else if ( ch >= 'A' && ch <= 'Z' ) {
        sle $t5, $a1, $t1                       #      return true;}
        sge $t6, $a1, $t0                       #   else {
        and $s5, $t5, $t6                       #      return false;}
                                                #
        or $v0, $s4, $s5                        # If the character is uppercase ($t5) or lowercase($t6), return true
                                                # Returns 0 if false and 1 if true 
        lw $s5, 0($sp)                          # To store $s5 for further use 
        lw $s4, 4($sp)                          # To store $s4 for further use 
        addi $sp, $sp, 8                        # Incrementing the stack downwards by 8 bits
                                                #
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
                                                #
        lw $ra, 0($sp)                          # Loading main address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index 
                                                #
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
                                                #
        addi $sp, $sp, -4                       # Incrementing stack pointer index downwards
        sw $t4, 0($sp)                          # Storing return address in stack
                                                #
        lb $t4, nullch                          # w[char_index] = '\0';
        sb $t4, 0($s2)                          # Storing null at the end of the word 
                                                #
        lw $t4, 0($sp)                          # Loading main address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index

go_to_piglatin:                                 # Navigate to piglatin nd adday 
                                                #
        addi $sp, $sp, -4                       # Incrementing stack pointer index downwards
        sw $ra, 0($sp)                          # Storing return address in stack
                                                #
        jal pig_latin                           # piglatin(word);
                                                #
        lw $ra, 0($sp)                          # Loading main address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index
                                                #
        addi $sp, $sp, -4                       # Incrementing stack pointer index downwards
        sw $ra, 0($sp)                          # Storing return address in stack
                                                #
        jal add_ay                              # adday(word);
                                                #
        lw $ra, 0($sp)                          # Loading main address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index


punctuation:                                    # Function to append punctuations to string 
                                                # and set word to null 
        sb $t4, 0($s5)                          # output_sentence[output_index++] = cur_char; 
        addi $s5, $s5, 1                        # output_index++
                                                # Punctuations appended 
        lb $t4, nullch                          # Loading $t4 into word 
        sb $t4, word                            # w[0] = '\0';
        li $s3, -1                              # char_index = -1;
        jr $ra                                  # Return to amin address 

process_input_loop_end:

        beqz $t3, process_input_loop            # while( end_of_sentence == false )
        li $v1, 0                               # return false;
        jr $ra                                  # Jump to main 

isUpper:                                        # Function to check if a character is uppercase 
        lb $t2, ch_A                            # int isUpper(char ch){
        lb $t5, ch_Z                            #  while (ch != '\0') {
                                                #   if (ch >= 'A' && ch <= 'Z') {        
        sle $t5, $t1, $t5                       #        return true;       
        sge $t6, $t1, $t2                       #   }
        and $v0, $t5, $t6                       #   return false;          
                                                #  } }
        jr $ra                                  # Return to main adress 

pig_latin:

        la $s1, word                            # Loading address of word to $s1 to iterate through it 
        la $s4, before_vowel                    # Loading address of word to $s4 to iterate through it 
        

vowel_loop:
        lb $t0, 0($s1)                          #Load cur_char to $t0 and check if its a vowel 

        # int is_vowel(char ch){
        #   if ( ch == 'a'|| ch == 'e' || ch== 'i' || ch == 'o' || ch == 'u'|| ch == 'A'|| ch == 'E' || ch == 'I' || ch == 'O' || ch == 'U' ) {
        #               return true;  
        #  }
        #  return false;
        #  }
        lb $t2, ch_a
        beq $t0, $t2, vowel

        lb $t2, ch_e
        beq $t0, $t2, vowel

        lb $t2, ch_i
        beq $t0, $t2, vowel

        lb $t2, ch_o
        beq $t0, $t2, vowel

        lb $t2, ch_u
        beq $t0, $t2, vowel

        lb $t2, ch_A
        beq $t0, $t2, vowel

        lb $t2, ch_E
        beq $t0, $t2, vowel

        lb $t2, ch_I
        beq $t0, $t2, vowel

        lb $t2, ch_O
        beq $t0, $t2, vowel

        lb $t2, ch_U
        beq $t0, $t2, vowel


        lb $t5, nullch                          # Loading null character to $t5
        bne $t0, $t5, append_bv                 # If vowel not founf jump to append_bv
                                                # to append to the before_vowel string 
        la $s4, before_vowel                    # Loading address of before_vowel into $s4
                                                #
        j add_bv                                # Jump to add_bv to append before_vowel to end of word 

append_bv:                                      # Fuction to append charcters to the before_vowel string 
                                                #
        sb $t0, 0($s4)                          #  if ( is_valid_character(word[n]) ){
        addi $s4, $s4, 1                        # { 
                                                #     before_vowel[before_vowel_index++] = (word[n]);
        addi $s1, $s1, 1                        # }
        j vowel_loop                            # while ( is_vowel(word[n]) == 0 )

vowel:                                          # Function to append string to output_sentence
                                                # when a vowel is found 
        sb $t0, 0($s5)                          # Appending to $s5 - output_sentence
        addi $s5, $s5,1                         # Incrementing output_index
        addi $s1, $s1,1                         # Incrementing word character index
                                                # while ( word[n]!='\0' ) {     
        lb $t5, nullch                          #    output_sentence[output_index++] = word[n];
        lb $t0, 0($s1)                          #     n++;
        bne $t0, $t5, vowel                     # }
                                                #
        la $s4, before_vowel                    # Load the adress of before_vowel to $s4
        j add_bv                                # Jump to add_bv to append before_vowel string


add_bv:

        lb $t5, nullch                          # Function to append the before_vowel string to end of the word 
                                                # Register guide: $s4 - before_vowel ; $s5 - output_sentence
        lb $t0, 0($s4)                          # Loading current character from before_vowel string 
        addi $s4, $s4,1                         # int b = 0;  
                                                # while ( before_vowel[b]!= '\0' )
        sb $t0, 0($s5)                          #   output_sentence[output_index++] = before_vowel[b];
        addi $s5, $s5,1                         #   b++;  
                                                # }
        bne $t0, $t5, add_bv                    # If character not null, loop and append character 
        la $s4, before_vowel                    # Load address of before_vowel for other functions to use 

make_bv_null:
                                                # Function to make before_vowel string null 
        sb $t5, 0($s4)                          # Storing null character to before_vowel
        addi $s4, $s4, 1                        # Increment before_vowel_index
        lb $t0, 0($s4)                          # Load the character from current address
        bne $t0, $t5, make_bv_null              #  If character not null, return to loop and make it null
        j pig_latin_exit                        #Jump unconditionally to pig_latin_exit 

pig_latin_exit:
        jr $ra                                  # Return to process_input_loop

add_ay:                                         # Function to append ay/AY to end of word depending on case    
                                                # Regiter guide: $s1 - address of word ; $t1 - cur_char ; $v0 - return value 
        la $s1, word                            # Loading address of word into $s1 to check case of word 
        lb $t1, 0($s1)                          # Loading the character from the word index 
                                                #
        addi $sp, $sp, -4                       # Incrementing stack pointer index downwards 
        sw $ra, 0($sp)                          # Storing return address in stack
                                                #
        jal isUpper                             # isUpper(word[n]) 
                                                # Checking if first charcter is uppercase 
        lw $ra, 0($sp)                          # Storing return address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index
                                                #  if ( isUpper(word[n]) && res ) {  
        beq $v0, $zero, add_ay_small            #       res = true;  
                                                #   } else {
        addi $s1, $s1, 1                        #       res = false;          
        lb $t1, 0($s1)                          #  }
        lb $t5, nullch                          #  if(res){      
        beq $t1, $t5, add_ay_big                #    Append 'A'
                                                #    Append 'Y' }
        addi $sp, $sp, -4                       # Incrementing stack pointer index downwards 
        sw $ra, 0($sp)                          # Storing return address in stack
                                                # else{
        jal isUpper                             #    Append 'a'
                                                #    Append 'y' }
        lw $ra, 0($sp)                          # Storing return address in stack
        addi $sp, $sp, 4                        # Decrementing the stack pointer index
                                                # Checkimg if second charcacter is lowercase
        beq $v0, $zero, add_ay_small            # Then append ay
        j add_ay_big                            # Else append AY


add_ay_small:                                   # Functon to append "AY" at the 
                                                # end of an lowercase word 
        lb $t5, nullch                          # Loading null character to $t5 
                                                # Register guide: $s5: output_sentence, $t1 - characters to be appended 
        subi $s5, $s5, 1                        # Index decremented as null charcter stored at end of string 
        lb $t1, ch_a                            # loading 'a' to append to end of word 
        sb $t1, 0($s5)                          # output_sentence[output_index++] = 'a';
        addi $s5, $s5, 1                        # output_index++;
                                                #
        lb $t1, ch_y                            # loading 'y' to append to end of word
        sb $t1, 0($s5)                          # output_sentence[output_index++] = 'y';  
        addi $s5, $s5, 1                        # output_index++
                                                # "ay" appended to end of string 
        jr $ra                                  # Return to address in register 

add_ay_big:                                     # Functon to append "AY" at the 
                                                # end of an uppercase word 
        lb $t5, nullch                          # Loading null character to $t5  
                                                # Register guide: $s5: output_sentence, $t1 - characters to be appended 
        subi $s5, $s5, 1                        # Index decremented as null charcter stored at end of string 
        lb $t1, ch_A                            # loading 'A' to append to end of word 
        sb $t1, 0($s5)                          # output_sentence[output_index++] = 'A'; 
        addi $s5, $s5, 1                        # output_index++
                                                #
        lb $t1, ch_Y                            # loading 'Y' to append to end of word 
        sb $t1, 0($s5)                          # output_sentence[output_index++] = 'Y';
        addi $s5, $s5, 1                        # output_index++
                                                # "AY" appended to end of string 
        jr $ra                                  # Return to address in register 
                                                
output:                                         # Function to output output_sentence
                                                #
        li $v0, 4                               # Loading 4 into $v0 - print string 
        la $a0, output_sentence                 # print_string("output_sentence");
        syscall                                 # syscall to execute commands
        jr $ra                                  # return to main 

main:
        jal read_input                          # read_input(input_sentence);
                                                #
        li $v0, 4                               # Loading 4 into $v0 - print string 
        la $a0, outmsg                          # print_string("\noutput:\n");
        syscall                                 # syscall to execute commands
                                                #
        li $s0, 0                               # Loading immediate to iterarte through input_sentence
        la $s5, output_sentence                 # Loading address of output_sentence into $s5 
                                                
loop:

        jal process_input                       # process_input(input_sentence, word);

next:
        beq $t3, $zero, loop                    # while ( word_found == true );
        jal output                              # output(output_sentence);

exit:

        li   $v0, 10                            # exit()
        syscall
        #------------------------------------------------------------------
        # End of file 
        #------------------------------------------------------------------
