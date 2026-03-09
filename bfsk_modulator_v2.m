function [complex_signal, f1, f2] = bfsk_modulator_v2(bits, bit_rate, samples_per_bit, sampling_rate)
    % Automatically set orthogonal frequencies for optimal performance
    f1 = bit_rate * 4; 
    f2 = bit_rate * 2;
    
    num_bits = length(bits);
    complex_signal = zeros(1, num_bits * samples_per_bit);
    t_bit = (0:samples_per_bit-1) / sampling_rate;
    
    % Normalize amplitude such that Bit Energy (Eb) = 1
    amplitude = sqrt(2 / (samples_per_bit / sampling_rate)); 
    last_phase = 0;
    for i = 1:num_bits
        f_current = (bits(i) == 1)*f1 + (bits(i) == 0)*f2;
        % Maintain phase continuity to reduce spectral broadening (CPFSK)
        current_signal = amplitude * exp(1i * (2*pi*f_current * t_bit + last_phase));
        complex_signal((i-1)*samples_per_bit+1 : i*samples_per_bit) = current_signal;
        last_phase = mod(2*pi*f_current * (samples_per_bit/sampling_rate) + last_phase, 2*pi);
    end
end