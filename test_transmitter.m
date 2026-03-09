clc; 
clear;

% Testing the transmitter code

cfg.bit_rate = 1e6;
cfg.samples_per_bit = 20;
cfg.Fs = cfg.bit_rate * cfg.samples_per_bit;
cfg.ER_dB = 20;

bits = source_gen("Olivia");

[tx_bfsk, params_bfsk] = transmitter(bits, 'BFSK', cfg);
[tx_ook, params_ook] = transmitter(bits, 'OOK', cfg);

% figure;
% subplot(2,1,1); plot(real(tx_bfsk)); title('BFSK Transmitted Signal');
% subplot(2,1,2); plot(tx_ook); title('OOK Transmitted Signal');
