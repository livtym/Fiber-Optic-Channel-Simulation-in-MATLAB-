function [bits, msg_type] = source_gen(input_data, target_ax)

% This function will convert a (user entered) text message into a binary
% stream via the use of ASCII encoding. It also contains the option to
% generate a random string of bits if a bit number is provided.

msg_type = ''; % for the plot since we need to know if it is a string of text or randomly generated binary


if isstring(input_data) || ischar(input_data) % if the text is in double quotes it is a string, if it is in single quotes it is a charcter array, either way it is treated as text (not bit number)
    ascii_val = double(char(input_data)); % convert to ascii encoding

    % Initialize an array to store the binary bits
    bits = [];

    for i = 1:length(ascii_val) % to loop over all ascii characters and convert to binary
        b = dec2bin(ascii_val(i), 8) - '0';
        bits = [bits b]; % build the bits vector bit by bit by appending the new bit to the end of the vector (b appended to bits)
    end 
    msg_type = 'Text';

elseif isnumeric(input_data) && isscalar(input_data) % if it isn't text it will be recognized as a number, and we need to generate random bits (as many as this number)
        bits = randi([0 1], 1, input_data); % generate a random binary stream of the entered number of bits
        msg_type = 'Random bits';
end 

if nargin >1 && ~isempty(target_ax)
    %GUI
    cla(target_ax);
    stem(target_ax, bits, 'filled');
    title(target_ax, [msg_type ' to binary']);
    xlabel(target_ax, 'Bit index');
    ylabel(target_ax, 'Bit value');
else
    %figure
    figure;
    stem(bits, 'filled');
    title([msg_type ' to binary']);
    xlabel('Bit index'); ylabel('Bit value');

end 