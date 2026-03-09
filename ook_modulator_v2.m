function [optical_power, filter_delay] = ook_modulator_v2(electrical_bits, samples_per_bit, ER_dB)
    % 1. Calculate power levels based on Extinction Ratio (ER)
    P1 = 1; 
    if isinf(ER_dB), P0 = 0; else, P0 = P1 / (10^(ER_dB / 10)); end
    
    % 2. Map bits to electrical levels
    symbols = (electrical_bits == 1) * P1 + (electrical_bits == 0) * P0;
    
    % 3. Pulse Shaping (Square-Root Raised Cosine Filter)
    rolloff = 0.5;   % Rolloff factor
    span = 10;       % Filter symbol span
    num_samples = samples_per_bit;
    h = rcosdesign(rolloff, span, num_samples, 'sqrt');
    filter_delay = (span * num_samples) / 2; % Group delay caused by the filter
    
    % Upsample and apply the shaping filter
    upsampled_symbols = upsample(symbols, num_samples);
    optical_power = filter(h, 1, upsampled_symbols);
end