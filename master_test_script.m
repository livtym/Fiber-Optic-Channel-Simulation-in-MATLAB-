clc; clear; 

%% 1. Setup
config.bit_rate = 1e6;
config.samples_per_bit = 20;
config.Fs = config.bit_rate * config.samples_per_bit;
config.ER_dB = 20;
fiber_struct.alpha = 0.1/4.343e3;  
fiber_struct.beta2 = -21e-27;      
fiber_struct.beta3 = 0.1e-39;      
fiber_struct.gamma = 1.3e-3;       
Fs = config.Fs;          
fiber_length = 5e3;                
Nz = 200; 
mod_type = 'OOK';
input_str = "january twenty-first";

%% --- CASE 1: NO PADDING ---
[bits_raw, ~] = source_gen(input_str); 
[tx_raw, ~] = transmitter(bits_raw, mod_type, config);
% The max limit of the raw signal
raw_limit = length(tx_raw); 
[rx_raw, ~] = SSFM_channel(tx_raw, Fs, fiber_length, Nz, fiber_struct, 0);

%% --- CASE 2: WITH PADDING & ALIGNMENT ---
[original_bits, ~] = source_gen(input_str); 
pad_len = 16; 
pad_samples = pad_len * config.samples_per_bit; 

bits_padded = [zeros(1, pad_len), original_bits, zeros(1, pad_len)]; 
[tx_pad, ~] = transmitter(bits_padded, mod_type, config);
[rx_pad, ~] = SSFM_channel(tx_pad, Fs, fiber_length, Nz, fiber_struct, 0);

% Sync and align Case 2
[corr, lags] = xcorr(abs(rx_pad), abs(tx_pad));
[~, idx] = max(corr);
rx_aligned = circshift(rx_pad, -lags(idx));

%% --- ALIGNMENT STRATEGY: Common Large Window ---
total_L = length(tx_pad); 
% Payload effectively starts at pad_samples + 1
payload_end_idx = pad_samples + raw_limit; 

% Create a full window for Case 1
rx_raw_full = [zeros(1, pad_samples), abs(rx_raw), zeros(1, pad_samples)];
tx_raw_full = [zeros(1, pad_samples), abs(tx_raw), zeros(1, pad_samples)];

%% 2. Visualization
figure('Color', 'w', 'Name', 'Padding & Alignment Analysis');
common_xlim = [0, total_L];

% Subplot 1: Show the shift outside the "Original Window"
ax1 = subplot(2,1,1);
plot(tx_raw_full, 'k--', 'LineWidth', 1); hold on;
plot(rx_raw_full, 'r', 'LineWidth', 1);
% Mark the boundary where the raw signal would normally end
xline(payload_end_idx, ':m', 'Raw Window End', 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom');
title('Case 1: Without Alignment (Signal shifts beyond the original boundary)');
legend('TX Reference', 'Received Signal', 'Original Limit');
grid on; xlim(common_xlim); ylabel('Power (W)');

% Subplot 2: Show how Padding saves the signal
ax2 = subplot(2,1,2);
plot(abs(tx_pad), 'k--', 'LineWidth', 1); hold on;
plot(abs(rx_aligned), 'b', 'LineWidth', 1);
% Mark the same boundary
xline(payload_end_idx, ':m', 'Raw Window End', 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom');
title('Case 2: With Padding & Alignment (Signal recovered within buffer)');
legend('TX Reference', 'Received & Aligned', 'Original Limit');
grid on; xlim(common_xlim); ylabel('Power (W)');
xlabel('Sample Index (Total Window with Guard Bands)');

linkaxes([ax1, ax2], 'x'); 
sgtitle('Impact of Guard Bands on Dispersion Compensation', 'FontSize', 14);