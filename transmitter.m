function [tx_signal, params] = transmitter(bits, mod_type, config, target_ax)

% This function will generate the optical signal using the modulation type
% that a user must specify (either OOK or BSFK). 

% The inputs of the function include the binary bits generated from the
% source generator function, a user entered modulation type (either 'BSFK'
% or 'OOK', and the parameters config which is a container with the bit
% rate, samples per bit, sampling frequency, and extinction ratio if we
% choose OOK)

params = struct(); % this will be contained with values that are relavent to the reciever

switch upper(mod_type); % the modulation type needs to be in all capitals so this ensures that it will be in case it is entered in lower case
    case 'BFSK'
        [tx_signal, f1, f2] = bfsk_modulator_v2(bits, config.bit_rate, config.samples_per_bit, config.Fs);

        % Capture the parameters that we need to pass onto BFSK demodulator in reciever
        % later in the block
        params.f1 = f1; 
        params.f2 = f2;
        params.sampling_rate=config.Fs;
        params.samples_per_bit=config.samples_per_bit;

        if nargin > 3 && ~isempty(target_ax)
            cla(target_ax);
            plot(target_ax, real(tx_signal));
            title(target_ax, 'BFSK Transmitted Signal');
            xlabel(target_ax, 'Sample Index');ylabel(target_ax, 'Amplitude');
        else
            figure;
            plot(real(tx_signal)); title('BFSK Transmitted Signal');
        end


    case 'OOK'
        [tx_signal, delay] = ook_modulator_v2(bits, config.samples_per_bit, config.ER_dB);

        % The paramter we need for OOK demodulator in reciever
        params.threshold = 0.5*(max(tx_signal) + min(tx_signal)); 
        params.delay = delay;
        params.samples_per_bit = config.samples_per_bit;
        params.num_bits = length(bits);

        if nargin > 3 && ~isempty(target_ax)
            cla(target_ax);
            plot(target_ax, real(tx_signal));
            title(target_ax, 'OOK Transmitted Signal');
            xlabel(target_ax, 'Sample Index');ylabel(target_ax, 'Amplitude');
        else
            figure; 
            plot(tx_signal); title('OOK Transmitted Signal');
        end

end