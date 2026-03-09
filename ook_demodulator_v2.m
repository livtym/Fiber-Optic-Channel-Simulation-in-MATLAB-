function recovered_bits = ook_demodulator_v2(rx_signal, samples_per_bit, threshold, delay, num_bits)
    % 1. Matched Filtering (Symmetric to the transmitter filter)
    rolloff = 0.5; span = 10;
    h = rcosdesign(rolloff, span, samples_per_bit, 'sqrt');
    filtered_signal = filter(h, 1, rx_signal);
    
    % 2. Compensate for total delay (TX filter delay + RX filter delay)
    total_delay = delay + (span * samples_per_bit) / 2;
    
    % 3. Sampling and Threshold Decision
    % num_bits = floor((length(filtered_signal) - total_delay) / samples_per_bit);
    recovered_bits = zeros(1, num_bits);
    for i = 1:num_bits

        % Sample at the center of the eye diagram
        sample_idx = round(total_delay + (i-1)*samples_per_bit + 1);

        % Ensure we don't go past signal length
        if sample_idx > length(filtered_signal)
            sample_idx = length(filtered_signal);
        end
        
        if filtered_signal(sample_idx) > threshold
            recovered_bits(i) = 1;
        else
            recovered_bits(i) = 0;
        end
    end
end