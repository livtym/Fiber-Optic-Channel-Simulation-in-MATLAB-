function recovered_bits = bfsk_demodulator_v2(received_signal, f1, f2, sampling_rate, samples_per_bit)
    num_bits = floor(length(received_signal) / samples_per_bit);
    recovered_bits = zeros(1, num_bits);
    t_bit = (0:samples_per_bit-1) / sampling_rate;
    
    % Construct basis functions for the Matched Filter
    basis_1 = exp(1i * 2*pi*f1 * t_bit);
    basis_2 = exp(1i * 2*pi*f2 * t_bit);
    
    for i = 1:num_bits
        segment = received_signal((i-1)*samples_per_bit+1 : i*samples_per_bit);
        % Correlation Detection: Choose the branch with higher projected energy
        if abs(sum(segment .* conj(basis_1))) > abs(sum(segment .* conj(basis_2)))
            recovered_bits(i) = 1;
        else
            recovered_bits(i) = 0;
        end
    end
end