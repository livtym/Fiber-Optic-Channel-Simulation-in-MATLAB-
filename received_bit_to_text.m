function text = received_bit_to_text(bits, msg_type)

% This function acts as the reverse of the source generator. It takes the
% bits that are demodulated from the received optical signal and converts
% them back to ASCII, and then again to text. In the case that a defined
% number of randomly generated bits was requested, it does not convert to
% ASCII

text = []; % will be empty if the source was randomly generated bits
 
if strcmp(msg_type, 'Text') % only convert if the message type was a string of text, stored from source generator function

    N = floor(length(bits)/8)*8; % this determines the number of bits (the largest multiple of 8 that will fit inside the legnth of bits since we have 8-bit binary
    bits = bits(1:N); % this will take only the first N elements of the received bits so we only have 8 bit characters, since we cannot convert binary that is not 8 characters
    bit_matrix = reshape(bits, 8, []).'; % this creates a matrix with 8 rows, since each character is 8 bits, and however many columns are needed for however many characters we have, and takes the transpose since we want each row to be one character
    ascii_val = zeros(1, size(bit_matrix, 1)); % initialize a vector to store decimal ascii value for the corresponding binary character

    for i = 1:size(bit_matrix, 1)
        ascii_val(i) = bin2dec(char(bit_matrix(i,:) + '0')); % add 0 to convert the number back to a character and then convert the character array back to its corresponding decimal ascii number
    end 

    text = char(ascii_val); % forms the text from the ascii value

end
