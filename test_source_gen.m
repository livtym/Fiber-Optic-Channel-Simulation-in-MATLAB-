clc;
clear;

%% Text

message = 'Olivia'
bits_text = source_gen(message); 

disp('Input Message:');
disp(message); 

figure;
stem(bits_text, 'filled');
title('Text message to binary');
xlabel('Bit index'); ylabel('Bit value');

%% Number of bits

num_bits = 20; 
bits_random = source_gen(num_bits);

disp('Number of Bits:');
disp(num_bits); 
disp('Output Bits:');
disp(bits_random);
disp(['Number of Bits: ', num2str(length(bits_random))]);

figure;
stem(bits_random, 'filled');
title('Randomly generated bits');
xlabel('Bit index'); ylabel('Bit value');


