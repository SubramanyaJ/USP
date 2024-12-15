#!/bin/bash

generate_prime_numbers() {

  BITLENGTH=$1

  # Check if the provided bit length is a positive integer
#  if ! [[ "$BITLENGTH" =~ ^[0-9]+$ ]] || [ "$BITLENGTH" -le 0 ]; then
#    echo "Invalid bit length. Please provide a positive integer."
#    return 1
#  fi

  TEMP=$(echo "$BITLENGTH/2" | bc)

  PRIME1=$(openssl prime -generate -bits $TEMP)
  
  PRIME2=$(openssl prime -generate -bits $(echo "$BITLENGTH - $TEMP" | bc))
  
  # echo "Prime 1: $PRIME1"
  # echo "Prime 2: $PRIME2"
}

calculate_n(){
  N=$(echo "$PRIME1*$PRIME2" | bc)
  echo $N
}

calculate_minus(){
  PRIME1_MINUSONE=$(echo "$PRIME1 - 1" | bc)
  PRIME2_MINUSONE=$(echo "$PRIME2 - 1" | bc)
}

# Function to calculate GCD
gcd() {
  a=$1
  b=$2
  while [ "$b" -ne 0 ]; do
    temp=$b
    b=$((a % b))
    a=$temp
  done
  echo "$a"
}

# Function to calculate LCM (Least Common Multiple)
lcm() {
  a=$1
  b=$2

  # Ensure that both numbers are positive
  if [ "$a" -le 0 ] || [ "$b" -le 0 ]; then
    echo "Both numbers must be positive."
    return 1
  fi

  # Calculate GCD of a and b
  gcd_value=$(gcd $a $b)

  # Calculate LCM using the formula: LCM(a, b) = |a * b| / GCD(a, b)
  totient_value=$(( (a * b) / gcd_value ))

  echo "$totient_value"
}

# Function to find the largest number of the form 2^x + 1 that is coprime with n
largest_coprime_of_form_2x_plus_1() {
  if [ $# -ne 1 ]; then
    echo "Please provide a number."
    return 1
  fi

  n=$1
  x=1
  result=-1

  # Iterate through numbers of the form 2^x + 1
  while true; do
    #num=$((2**x + 1))
    num=$(echo "(2^$x) + 1" | bc)
    
    # If the number exceeds n, stop searching
    if [ "$num" -gt "$n" ]; then
      break
    fi

    # Check if the number is coprime with n
    if [ $(gcd $n $num) -eq 1 ]; then
      result=$num
    fi
    
    x=$((x + 1))
  done
  echo $result
  # Output the result
  #  if [ "$result" -ne -1 ]; then
  #   echo "Largest coprime of the form 2^x + 1: $result"
  #else
  # echo "No coprime number of the form 2^x + 1 found."
  #fi
}

modulo() {
  # Ensure that two arguments are provided
  if [ $# -ne 2 ]; then
    echo "Please provide two parameters: a and b."
    return 1
  fi

  a=$1
  b=$2

  # Check if b is zero to avoid division by zero error
  if [ "$b" -eq 0 ]; then
    echo "Error: Division by zero is not allowed."
    return 1
  fi

  # Calculate a mod b
  d=$((a % b))

  # Output the result
  echo $d
}

ascii_map() {
  # Check if exactly one argument is provided
  if [ $# -ne 1 ]; then
    echo "Usage: ascii_map <character>"
    return 1
  fi

  # Get the input character
  char=$1

  # Ensure the input is a single character
  if [ ${#char} -ne 1 ]; then
    echo "Error: Please provide a single character."
    return 1
  fi

  # Use printf to get the ASCII value of the character
  ascii_code=$(printf "%d" "'$char")

  # Output the ASCII code
  echo "$ascii_code"
}

# Function to calculate (a^key) % mod
powerModulus() {
  # Assign arguments to variables
  a=$1
  key=$2
  mod=$3

  # Initialize the result to 1
  result=1

  # Perform modular exponentiation (a^key) % mod
  for i in $(seq 1 $key); 
  do
    result=$(( (result * a) % mod ))
  done

  # Output the result
  echo $result
}


# generate_prime_numbers <input_keylength>
# calculate_n
# lcm p-1 q-1
# largest_coprime_of_form_2x_plus_1 (encryption key)
# decryption_key calculate

copy_file_char_by_char() {
    # Check if the correct number of arguments are passed
    if [ "$#" -ne 2 ]; then
        echo "Usage: copy_file_char_by_char <source_file> <destination_file>"
        return 1
    fi

    # Assign parameters to variables
    source_file=$1
    destination_file=$2

    # Check if the source file exists
    if [ ! -f "$source_file" ]; then
        echo "Source file does not exist."
        return 1
    fi

    # Open the source file and write it character by character to the destination file
    while IFS= read -r -n1 char; do
        echo -n "$(printf "%d " "'$char")" >> "$destination_file"
    done < "$source_file"

    echo "File copied successfully to $destination_file"
}

decode_ascii_to_text() {
    local input_file=$1
    local output_file=$2

    if [[ ! -f $input_file ]]; then
        echo "Error: File '$input_file' not found."
        return 1
    fi

    # Read the ASCII codes, convert to characters, and write to the output file
    awk '{for(i=1;i<=NF;i++) printf "%c", $i; printf "\n"}' "$input_file" > "$output_file"

    echo "Decoded text written to '$output_file'."
}

# Function to calculate the modular multiplicative inverse of 'a' under modulo 'm'
modular_inverse() {
    local a=$1
    local m=$2

    # Variables for Extended Euclidean Algorithm
    local m0=$m
    local x0=0
    local x1=1

    if (( m == 1 )); then
        echo "0"
        return
    fi

    while (( a > 1 )); do
        # q is quotient
        local q=$(( a / m ))
        local t=$m

        # Update m and a
        m=$(( a % m ))
        a=$t

        # Update x0 and x1
        t=$x0
        x0=$(( x1 - q * x0 ))
        x1=$t
    done

    # Make x1 positive
    if (( x1 < 0 )); then
        x1=$(( x1 + m0 ))
    fi

    echo "$x1"
}


# MAIN
# generate_prime_numbers 10
# TAKE INPUT HERE
PRIME1=43
PRIME2=59

GLOBAL____N=$(calculate_n)
calculate_minus
GLOBAL____TOTIENT=$(lcm $PRIME1_MINUSONE $PRIME2_MINUSONE)

#GLOBAL____ENC_KEY=$(largest_coprime_of_form_2x_plus_1 $GLOBAL____TOTIENT)
GLOBAL____ENC_KEY=$( echo "13" | bc)
GLOBAL____DEC_KEY=$(modular_inverse $GLOBAL____ENC_KEY $GLOBAL____TOTIENT)

echo $GLOBAL____N $GLOBAL____ENC_KEY $GLOBAL____DEC_KEY $GLOBAL____TOTIENT


copy_file_char_by_char ./lorem.txt ./enc.txt 
decode_ascii_to_text ./enc.txt ./new.txt
