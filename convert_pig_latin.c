// ==========================================================================
// PigLatin Converter
// ==========================================================================
// Convert all words in a sentence using PigLatin rules

// Inf2C-CS Coursework 1. Task B
// PROVIDED file, to be used to complete the task in C and as a model for writing MIPS code.

// Instructor: Boris Grot
// TA: Priyank Faldu
// 10 Oct 2017

//---------------------------------------------------------------------------
// C definitions for SPIM system calls
//---------------------------------------------------------------------------
#include <stdio.h>

void read_string(char* s, int size) { fgets(s, size, stdin); }

void print_char(char c)    { printf("%c", c); }
void print_int(int num)    { printf("%d", num); }
void print_string(const char* s) { printf("%s", s); }

#define false 0
#define true 1

// Maximum characters in an input sentence excluding terminating null character

#define MAX_SENTENCE_LENGTH 1000

// Maximum characters in a word excluding terminating null character

#define MAX_WORD_LENGTH 50

// Global variables
// +1 to store terminating null character

char input_sentence[MAX_SENTENCE_LENGTH+1];
char output_sentence[(MAX_SENTENCE_LENGTH*3)+1];

void read_input(const char* inp) {
    print_string("Enter input: ");
    read_string(input_sentence, MAX_SENTENCE_LENGTH+1);
}

void output(const char* out) {
    print_string(out);
    print_string("\n");
}

// Do not modify anything above
// Define your global variables here

char word[MAX_WORD_LENGTH+1];                //word array to store the words in the input sentence
char before_vowel[MAX_WORD_LENGTH+1];        //before_vowel array is an auxiliary array to store string before vowel
int input_index = 0;                         //input_index is the index of the input_sentence
int end_of_sentence = false;                 //end_of_sentence is the flag to check if input_sentence reaches end
int output_index = 0;

// Write your own functions here
// -------Function to check if a character is uppercase-------
int isUpper(char ch){
  while (ch != '\0') {
    if (ch >= 'A' && ch <= 'Z') {           //Checks if a character is uppercase using ASCII values
        return true;                        //Returns true if a character is uppercase
    }
    return false;                           //Return false if not uppercase
  }
}

// -------Function to convert a charcter to uppercase--------
char toUpper(char ch){
  if (ch >= 'a' && ch <= 'z') {             //Checks if a character is lowercase according to ASCII
      ch = ch - 32;                         //If lowercase, converts to uppercase by subtracting 32 from ASCII value
  }
  return ch;                                //Returns Uppercase character
}

// -------Function to convert a charcter to lowercase--------
char toLower(char ch){
  if (ch >= 'A' && ch <= 'Z') {             //Checks if a character is uppercase according to ASCII
      ch = ch + 32;                         //If lowercase, converts to uppercase by adding 32 to ASCII value
  }
  return ch;                                //Returns Uppercase character
}

// --------Function to check if a character is valid---------
//Modified from find_word.c
int is_valid_character(char ch) {
  if ( ch >= 'a' && ch <= 'z' ) {           //Checks if lowercase according to ASCII
      return true;                          //Returns true if lowercase character
  } else if ( ch >= 'A' && ch <= 'Z' ) {    //Checks if uppercase according to ASCII
      return true;                          //Returns true if uppercase character
  } else {
      return false;                         //Returns false if neither uppercase nor lowercase
  }
}

// --------Function to check if a character is valid---------
int is_hyphen(char ch) {
  if ( ch == '-' ) {                        //Checks if the character is a hyphen
      return true;                          //Returns true if the characer is a hyphen
  } else {
      return false;                         //Returns false if the character is not a hyphen
  }
}

// --------Function to check if a character is valid---------
int is_vowel(char ch){
  if ( ch == 'a'|| ch == 'e' || ch== 'i' || ch == 'o' || ch == 'u'|| ch == 'A'|| ch == 'E' || ch == 'I' || ch == 'O' || ch == 'U' ) {
      return true;                          //Return true if a character is a vowel
  }
  return false;                             //Returns false if a character is not a vowel
}

// -----Function to append the 'ay'/'AY' to each word--------
void adday(char* word){
  int res = true;                           //Result of whether all words are uppercase or not
  int n = 0;                                //word character counter
  while ( word[n] != '\0' ) {
    if ( is_valid_character(word[n]) ) {    //If it is a valid character,
      if ( isUpper(word[n]) && res ) {      //And if all characters are uppercase,
          res = true;                       //Make result true
      } else {
          res = false;                      //Otherwise set result false
      }
    }
    n++;                                    //Incrementing character count
  }
  if(res){                                  //If res is true, that is if all characters are capital
    output_sentence[output_index++] = 'A';  //Append 'A' to the output_sentence
    output_sentence[output_index++] = 'Y';  //Append 'Y' to the output_sentence
  }
  else{
    output_sentence[output_index++] = 'a';  //Append 'a' to the output_sentence
    output_sentence[output_index++] = 'y';  //Append 'y' to the output_sentence
  }
}

// -----Function to convert each word to PigLatin--------
void piglatin(char* word){
  int before_vowel_index = 0;               //Declaring the before_vowel_index (array) and setting to 0
  int n = 0;                                //Declaring word character count
  int res = true;                           //Result of whether all words are uppercase or not
  int flag = 0;                             //Flag to check if there are vowels are in the words
  while ( word[n] != '\0' ) {               //While the character is not null, iterate to find if there are any vowels
    if ( is_vowel(word[n]) ) {              //If the character in the word is a vowel...
        flag =1;                            //Set flag to 1 intially declared as 0
    }
    n++;                                    //Increment word character index
  }
  n = 0;                                    //Set n as 0 for the next loop
  if ( flag == 0 ) {                        //If there are no vowels in the string,
    while ( word[n]!='\0' )                 //While character in word not null,
    {                                       //Append the word to output_sentence and increment output_index
        output_sentence[output_index++] = word[n];
        n++;                                //Increment loop counter
    }
  }
  else {                                    //If a vowel is found in the sentence
    n = 0;                                  //Set word charcter count to zero
    while ( word[n] != '\0' )               //While word is not null
    {                                       //Loop to check if all characters are capital in a word
      if ( is_valid_character(word[n]) ) {  //If the character is valid
        if( isUpper(word[n]) && res ) {     //If the word is uppercase, 'and' it with existing result
            res = true;                     //Set result to true if an uppercase character
        }
        else {
            res = false;                    //Else set result(res) to false
        }
      }
      n++;                                  //Increment loop counter
    }

    n = 0;                                  //Set loop counter to zero for the next loop
    while ( is_vowel(word[n]) == 0 )        //While the character is not a vowel,
    {                                       //append charcters to the before_vowel array
      if ( is_valid_character(word[n]) ){   //If it's a valid character
        if (res) {                          //If all words are capital
            before_vowel[before_vowel_index++] = toUpper(word[n]);
        }                                   //Append all characters by first changing it into uppercase
        else {
            before_vowel[before_vowel_index++] = toLower(word[n]);
        }                                   //Append all characters by first changing it into lowercase
      }
      n++;                                  //Increment loop counter
    }

    if (isUpper(word[0]) ) {
        word[n] = toUpper(word[n]);         //If the first charcter is uppercase, then change the first letter(vowel) uppercase
    }

    before_vowel[before_vowel_index] = '\0';
                                            //Set end of before_vowel array to null string
    while ( word[n]!='\0' ) {               //While character not null, append the word to the output_sentence
      output_sentence[output_index++] = word[n];
      n++;
    }
    int b = 0;                              //Set the character count for iterating through before_vowel
    while ( before_vowel[b]!= '\0' )        //While charcter in before_vowel not null, append to output_sentence,
    {                                       //that is after the word already appended
       output_sentence[output_index++] = before_vowel[b];
       b++;                                 //Increment before_vowel index
    }
  }
}

//------Function to process_input(modified from find_word.c)--------
void process_input(char* inp, char* out) {
  char cur_char = '\0';
  int is_valid_ch = false;
  int is_vowel_ch = false;
  // Indicates how many elements in "w" contains valid word characters
  int char_index = -1;
  while( end_of_sentence == false ) {     //Done
      // This loop runs until end of an input sentence is encountered or a valid word is extracted
      cur_char = inp[input_index];        // Done
      input_index++;                      // Done
      // Check if it is a valid character
      is_valid_ch = is_valid_character(cur_char);
      if ( is_valid_ch ) {
            word[++char_index] = cur_char;
      } else {
          if ( cur_char == '\n' || cur_char == '\0' ) {
              // Indicates an end of an input sentence
              end_of_sentence = true;
          }
          if ( char_index >= 0 ) {
              // w has accumulated some valid characters. Thus, punctuation mark indicates a possible end of a word
              if ( is_hyphen(cur_char) == true && is_valid_character(inp[input_index]) ) {
                // check if the next character is also a valid character to detect hyphenated word.
                word[++char_index] = cur_char;
                //  output_sentence[output_index] = output_sentence[output_index] + word[char_index];
                //  output_index++;
                  continue;
              }
              // w has accumulated some valid characters. Thus, punctuation mark indicates an end of a word
              char_index++;
              word[char_index] = '\0';

              int len_w = 0;
              while (word[len_w]!= '\0')
              {
                  len_w++;
              }

              if ( len_w > 0 ) {
                    piglatin(word);
                    adday(word);
                }
          }

        }
        output_sentence[output_index++] = cur_char;   //Append punctuations to output_sentence
        word[0] = '\0';
        char_index = -1;
      }
  }
}
// Do not modify anything below
int main() {

    read_input(input_sentence);

    print_string("\noutput:\n");

    output_sentence[0] = '\0';
    process_input(input_sentence, output_sentence);

    output(output_sentence);

    return 0;
}

//---------------------------------------------------------------------------
// End of file
//---------------------------------------------------------------------------
