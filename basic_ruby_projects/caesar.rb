def encode(char, shift_factor)
    base = char.upcase == char ? 65 : 97
    (((char.ord - base + shift_factor) % 26) + base).chr
end

def caesar_cipher(str_to_encode, shift_factor)
    str_to_encode.split('').map {|char| char.match?(/[A-Za-z]/) ? encode(char, shift_factor) : char}.join()
end

puts caesar_cipher("What a string!", -5)