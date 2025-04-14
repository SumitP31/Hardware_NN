def fractional_to_12bit_binary(number, int_length=3):
    """
    Convert a fractional number to a 12-bit binary representation:
    - 1 bit for sign (0 for positive, 1 for negative)
    - 3 bits for integer part
    - 8 bits for fractional part
    
    Returns: string representation of the 12-bit binary number
    """
    # Handle sign bit
    frac_length=  12-int_length-1

    if number < 0:
        sign_bit = '1'
        number = abs(number)  # Work with absolute value
    else:
        sign_bit = '0'
    
    # Extract integer and fractional parts
    integer_part = int(number)
    fractional_part = number - integer_part
    
    # Check if integer part can be represented in 3 bits (0-7)
    if integer_part > 2**int_length - 1:
        integer_part = 2**int_length - 1
        fractional_part= 0.999999999999999
    
    # Convert integer part to 3-bit binary
    integer_binary = format(integer_part, f'0{int_length}b')
    
    # Convert fractional part to 8-bit binary
    fractional_binary = ""
    for _ in range(frac_length):
        fractional_part *= 2
        bit = int(fractional_part)
        fractional_binary += str(bit)
        fractional_part -= bit
    
    # Combine all parts
    result = sign_bit + integer_binary + fractional_binary
    
    return result

# Example usage
test_values = [3.25, -2.75, 6.125, -0.5, 7.999, 8.0]

for value in test_values:
    try:
        binary = fractional_to_12bit_binary(value)
        print(f"{value} -> {binary}")
    except Exception as e:
        print(f"{value} -> {str(e)}")