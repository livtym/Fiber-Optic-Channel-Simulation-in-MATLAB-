function performStressTest(bits, targetSNR, targetER, axSNR, axER)
% System evaluation under noise and hardware impairments

    % --- Basic Setup ---
    spb = 16; 
    bit_rate = 1e6; % 1 Mbps sim
    sampling_rate = bit_rate * spb;
    num_bits = length(bits);
    EbN0_fixed = 12; % fixed SNR ref for ER test

    % --- Part 1: Noise Sensitivity (BER vs SNR) ---
    EbN0_range = 2:2:16;
    ber_ook_snr = zeros(size(EbN0_range));
    ber_fsk_snr = zeros(size(EbN0_range));
    
    for k = 1:length(EbN0_range)
        % OOK path: high ER to check pure noise
        [tx_o, d_o] = ook_modulator_v2(bits, spb, 30); 
        n_o = mean(tx_o.^2) / (10^(EbN0_range(k)/10) * (1/spb));
        rx_o = tx_o + sqrt(n_o) * randn(size(tx_o));
        dec_o = ook_demodulator_v2(rx_o, spb, 0.25, d_o, num_bits);
        ber_ook_snr(k) = sum(bits(1:length(dec_o)) ~= dec_o) / length(dec_o);
        
        % BFSK path
        [tx_f, f1, f2] = bfsk_modulator_v2(bits, bit_rate, spb, sampling_rate);
        n_f = mean(abs(tx_f).^2) / (10^(EbN0_range(k)/10) * (1/spb));
        rx_f = tx_f + sqrt(n_f/2)*(randn(size(tx_f)) + 1i*randn(size(tx_f)));
        dec_f = bfsk_demodulator_v2(rx_f, f1, f2, sampling_rate, spb);
        ber_fsk_snr(k) = sum(bits ~= dec_f) / num_bits;
    end

    % --- Part 2: Hardware Tolerance (BER vs ER) ---
    % note: SNR is locked to EbN0_fixed here
    er_range = [3, 6, 9, 12, 18, 30];
    ber_ook_er = zeros(size(er_range));
    ber_fsk_er = zeros(size(er_range));
    
    for k = 1:length(er_range)
        % OOK with varying ER
        [tx_o, d_o] = ook_modulator_v2(bits, spb, er_range(k));
        n_o = mean(tx_o.^2) / (10^(EbN0_fixed/10) * (1/spb)); 
        rx_o = tx_o + sqrt(n_o) * randn(size(tx_o));
        % threshold shifts based on ER
        dec_o = ook_demodulator_v2(rx_o, spb, (1+10^(-er_range(k)/10))/4, d_o, num_bits);
        ber_ook_er(k) = sum(bits(1:length(dec_o)) ~= dec_o) / length(dec_o);
        
        % BFSK: dc leakage simulation
        leakage_amp = sqrt(1 / (10^(er_range(k)/10)));
        [tx_f, f1, f2] = bfsk_modulator_v2(bits, bit_rate, spb, sampling_rate);
        tx_f_impaired = tx_f + leakage_amp; 
        n_f = mean(abs(tx_f).^2) / (10^(EbN0_fixed/10) * (1/spb));
        rx_f = tx_f_impaired + sqrt(n_f/2)*(randn(size(tx_f)) + 1i*randn(size(tx_f)));
        dec_f = bfsk_demodulator_v2(rx_f, f1, f2, sampling_rate, spb);
        ber_fsk_er(k) = sum(bits ~= dec_f) / num_bits;
    end

    % --- Plotting & Current Input Markers ---
    % SNR plot
    cla(axSNR);
    semilogy(axSNR, EbN0_range, ber_ook_snr, 'b-o', 'DisplayName', 'OOK'); hold(axSNR, 'on');
    semilogy(axSNR, EbN0_range, ber_fsk_snr, 'r-s', 'DisplayName', 'BFSK');
    xline(axSNR, targetSNR, '--k', 'LineWidth', 1.5, 'Label', 'Current SNR');
    grid(axSNR, 'on'); legend(axSNR, 'show');

    % ER plot
    cla(axER);
    semilogy(axER, er_range, ber_ook_er, 'b-o', 'DisplayName', 'OOK'); hold(axER, 'on');
    semilogy(axER, er_range, ber_fsk_er, 'r-s', 'DisplayName', 'BFSK');
    xline(axER, targetER, '--k', 'LineWidth', 1.5, 'Label', 'Current ER');
    grid(axER, 'on'); legend(axER, 'show');
end