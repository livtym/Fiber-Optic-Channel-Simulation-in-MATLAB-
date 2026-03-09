function recovered_bits = receiver(rx_signal, modulation_type, params, tx_signal, tx_bits, ax_sig, ax_bits)

% This function will recover the bits after they have been transmitted
% through the optical fiber. It does so by calling the demodulator function
% (similarly to the transmitter). 
% The inputs for this function are the recieved signal after it has
% traveled along the fiber channel, the type of modulation that was used
% (as the same type of demodulation will be used), and the parameter
% structure that was captured in the transmitter function containing
% relavent frequencies or delays (depending on the modulation type)

switch upper(modulation_type)
        case 'BFSK'
            recovered_bits = bfsk_demodulator_v2(rx_signal, params.f1, params.f2, params.sampling_rate, params.samples_per_bit);
            
            if nargin > 6 && ~isempty(ax_sig) && ~isempty(ax_bits)
               
                cla(ax_sig);
                plot(ax_sig, real(rx_signal), 'LineWidth', 1.5); hold(ax_sig, 'on');
                plot(ax_sig, real(tx_signal), '--k', 'LineWidth', 1);
                xlabel(ax_sig, 'Sample index'); ylabel(ax_sig, 'Amplitude');
                title(ax_sig, 'BFSK Received Signal');
                legend(ax_sig, 'Received', 'Transmitted'); grid(ax_sig, 'on');
                            
                cla(ax_bits);
                stem(ax_bits, tx_bits, 'filled'); hold(ax_bits, 'on'); 
                stem(ax_bits, recovered_bits + 0.1, 'r'); 
                xlabel(ax_bits, 'Bit index'); ylabel(ax_bits, 'Bit value');
                title(ax_bits, 'Comparison of bits');
                legend(ax_bits, 'Transmitted', 'Recovered'); grid(ax_bits, 'on');
                ax_bits.YLim = [-0.2 1.5]; 
            else
                figure;
                subplot(2,1,1);
                plot(real(rx_signal), 'LineWidth', 1.5); hold on;
                plot(real(tx_signal), '--k', 'LineWidth', 1);
                title('BFSK Received Signal'); grid on;
                subplot(2,1,2);
                stem(tx_bits, 'filled'); hold on; stem(recovered_bits + 0.1, 'r');
                title('Comparison of bits'); grid on;
            end
            % figure;
            % subplot(2,1,1)
            % plot(real(rx_signal), 'LineWidth', 1.5); % plot the real part of receiver signal after passing through modulator
            % hold on;
            % plot(real(tx_signal), '--k', 'LineWidth', 1);
            % xlabel('Sample index'); 
            % ylabel('Amplitude');
            % title('BFSK Received Signal');
            % legend('Received', 'Transmitted');
            % grid on;
            % 
            % subplot(2,1,2);
            % n = min(length(recovered_bits), length(tx_bits)); % in the case that the recovered bits do not exactly match the transmitted bits
            % stem(tx_bits, 'filled');
            % hold on; 
            % stem(recovered_bits, 'r'); % shift the recovered bits up a bit so we can see them
            % xlabel('Bit index');
            % ylabel('Bit value');
            % legend('Transmitted bits', 'Recovered bits');
            % title('Comparison of transmitted and received bits');
            % grid on;

        case 'OOK'

            recovered_bits = ook_demodulator_v2(rx_signal, params.samples_per_bit, params.threshold, params.delay, params.num_bits);

            if nargin > 6 && ~isempty(ax_sig) && ~isempty(ax_bits)
                % GUI mode
                % received signal
                cla(ax_sig);
                plot(ax_sig, abs(rx_signal), 'LineWidth', 1.5); hold(ax_sig, 'on'); 
                plot(ax_sig, real(tx_signal), '--k', 'LineWidth', 1);
                yline(ax_sig, params.threshold, '--r', 'Threshold', 'LineWidth', 1.5);
                xlabel(ax_sig, 'Sample index'); ylabel(ax_sig, 'Amplitude / Power');
                title(ax_sig, 'OOK Received Signal');
                legend(ax_sig, 'Received', 'Transmitted'); grid(ax_sig, 'on');
                
                % bits comparison
                cla(ax_bits);
                stem(ax_bits, tx_bits, 'filled'); hold(ax_bits, 'on'); 
                stem(ax_bits, recovered_bits + 0.1, 'r');
                xlabel(ax_bits, 'Bit index'); ylabel(ax_bits, 'Bit value');
                title(ax_bits, 'Comparison of bits');
                legend(ax_bits, 'Transmitted', 'Recovered'); grid(ax_bits, 'on');
                ax_bits.YLim = [-0.2 1.5];
            else
                % figure mode
                figure; 
                subplot(2,1,1);
                plot(abs(rx_signal),'LineWidth', 1.5); hold on; 
                plot(real(tx_signal), '--k', 'LineWidth', 1);
                yline(params.threshold, '--r', 'Threshold');
                title('OOK Received Signal'); grid on;
                subplot(2,1,2);
                stem(tx_bits, 'filled'); hold on; stem(recovered_bits + 0.1, 'r');
                title('Comparison of bits'); grid on;
            end
end
            % figure; 
            % subplot(2,1,1)
            % plot(abs(rx_signal),'LineWidth', 1.5); 
            % hold on; 
            % plot(real(tx_signal), '--k', 'LineWidth', 1);
            % yline(params.threshold, '--r', 'Threshold', 'LineWidth', 1.5);
            % xlabel('Sample index'); 
            % ylabel('Amplitude / Power');
            % title('OOK Received Signal');
            % legend('Received', 'Transmitted');
            % grid on;
            % 
            % subplot(2,1,2);
            % n = min(length(recovered_bits), length(tx_bits)); % in the case that the recovered bits do not exactly match the transmitted bits
            % stem(tx_bits, 'filled');
            % hold on; 
            % stem(recovered_bits + 0.1, 'r'); % shift the recovered bits up a bit so we can see them
            % xlabel('Bit index');
            % ylabel('Bit value');
            % legend('Transmitted bits', 'Recovered bits');
            % title('Comparison of transmitted and received bits');
            % grid on;

end