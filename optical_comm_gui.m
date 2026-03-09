function optical_comm_gui()
    % --- Main Figure Window ---
    fig = uifigure('Name', 'Optical Communication Analysis Tool: OOK vs BFSK', ...
        'Position', [50, 20, 1200, 800], 'Color', [0.95 0.95 0.95]);

    % --- Layout Grid ---
    mainGrid = uigridlayout(fig, [2, 2]);
    mainGrid.ColumnWidth = {420, '1x'}; 
    mainGrid.RowHeight = {'1.5x', '1x'};

    %% --- TOP LEFT: CONFIGURATION PANEL ---
    configPanel = uipanel(mainGrid, 'Title', 'Simulation Configuration', 'FontWeight', 'bold');
    configPanel.Layout.Row = 1; configPanel.Layout.Column = 1;
    
    cfgGrid = uigridlayout(configPanel, [13, 2]);
    cfgGrid.ColumnWidth = {'1.6x', '1x'}; 
    cfgGrid.RowHeight = repmat({22}, 1, 13);

    % 1. Input Data Mode
    uilabel(cfgGrid, 'Text', 'Source Type:');
    srcType = uidropdown(cfgGrid, 'Items', {'Text Message', 'Random Bits'}, 'Value', 'Text Message');
    
    % 2. Input Content
    uilabel(cfgGrid, 'Text', 'Input (Text/Bit Number):');
    msgInput = uieditfield(cfgGrid, 'text', 'Value', 'january twenty-first');

    % 3. Fiber Length
    uilabel(cfgGrid, 'Text', 'Fiber Length (1-20 km):');
    lenInput = uieditfield(cfgGrid, 'numeric', 'Value', 5);
    
    % 4. Attenuation
    uilabel(cfgGrid, 'Text', 'Attenuation (0.1-0.5 dB/km):');
    alphaInput = uieditfield(cfgGrid, 'numeric', 'Value', 0.1);
    
    % 5. GVD Beta2
    uilabel(cfgGrid, 'Text', 'GVD Beta2 (-25 to -15):');
    beta2Input = uieditfield(cfgGrid, 'numeric', 'Value', -21);
    
    % 6. TOD Beta3 (Added Range)
    uilabel(cfgGrid, 'Text', 'TOD Beta3 (0.05-0.2 ps^3/km):');
    beta3Input = uieditfield(cfgGrid, 'numeric', 'Value', 0.1);

    % 7. Gamma
    uilabel(cfgGrid, 'Text', 'Gamma (1.1-2.5 1/W/km):');
    gammaInput = uieditfield(cfgGrid, 'numeric', 'Value', 1.3);

    % 8. Bit Rate
    uilabel(cfgGrid, 'Text', 'Bit Rate (1-3 Mbps):');
    brInput = uieditfield(cfgGrid, 'numeric', 'Value', 1); 

    % 9. Samples per Bit
    uilabel(cfgGrid, 'Text', 'Samples per Bit (16-32):');
    spbInput = uieditfield(cfgGrid, 'numeric', 'Value', 20);

    % 10. Extinction Ratio
    uilabel(cfgGrid, 'Text', 'Extinction Ratio (12-30 dB):');
    erInput = uieditfield(cfgGrid, 'numeric', 'Value', 20);

    % 11. SNR
    uilabel(cfgGrid, 'Text', 'Target Eb/N0 (5-20 dB):');
    snrInput = uieditfield(cfgGrid, 'numeric', 'Value', 12);

    % 12. Simulation Speed
    uilabel(cfgGrid, 'Text', 'Propagation speed (1-500):');
    psInput = uieditfield(cfgGrid, 'numeric', 'Value', 200);

    % 13. Run Button
    runBtn = uibutton(cfgGrid, 'push', 'Text', 'START SIMULATION', 'FontWeight', 'bold', ...
        'BackgroundColor', [0.2 0.6 1.0], 'FontColor', 'white');
    runBtn.Layout.Row = 13; runBtn.Layout.Column = [1 2];

    %% --- BOTTOM LEFT: STATUS & DECODED TEXT ---
    statusPanel = uipanel(mainGrid, 'Title', 'Results & Decoded Output', 'FontWeight', 'bold');
    statusPanel.Layout.Row = 2; statusPanel.Layout.Column = 1;
    
    statusGrid = uigridlayout(statusPanel, [4, 1]);
    statusGrid.RowHeight = {25, 20, '1x', '1x'};
    
    statusLabel = uilabel(statusGrid, 'Text', 'Ready.', 'FontColor', [0.3 0.3 0.3]);
    
    progBg = uipanel(statusGrid, 'BackgroundColor', [0.9 0.9 0.9]);
    progFill = uipanel(progBg, 'BackgroundColor', [0.2 0.8 0.2], 'Position', [1 1 0 18]);
    
    decodedBox = uitextarea(statusGrid, 'Editable', 'off', 'Placeholder', 'Received Text will appear here...');
    conclusionBox = uitextarea(statusGrid, 'Editable', 'off', 'Placeholder', 'Performance Conclusion...');

    %% --- RIGHT SIDE: TAB GROUP ---
    tabGroup = uitabgroup(mainGrid);
    tabGroup.Layout.Row = [1,2]; tabGroup.Layout.Column = 2;

    % Tabs 1-5 Axes initialization (Keep the same as your current script)
    tab1 = uitab(tabGroup, 'Title', '1.Generated bits from message');
    grid1 = uigridlayout(tab1, [2,2]);
    axSource = uiaxes(grid1); axSource.Layout.Row = 1; axSource.Layout.Column = [1 2];
    title(axSource, 'Binary Stream Visualization'); grid(axSource, 'on');
    axOOK_t = uiaxes(grid1); axOOK_t.Layout.Row = 2; axOOK_t.Layout.Column = 1;
    title(axOOK_t, 'OOK Transmitted Signal'); grid(axOOK_t, 'on');
    axBFSK_t = uiaxes(grid1); axBFSK_t.Layout.Row = 2; axBFSK_t.Layout.Column = 2;
    title(axBFSK_t, 'BFSK Transmitted Signal'); grid(axBFSK_t, 'on');

    tab2 = uitab(tabGroup, 'Title', '2.Live propagation');
    grid2 = uigridlayout(tab2, [2,1]);
    axOOK_c = uiaxes(grid2); title(axOOK_c, 'Intensity with OOK'); grid(axOOK_c, 'on');
    axBFSK_c = uiaxes(grid2); title(axBFSK_c, 'Intensity with BFSK'); grid(axBFSK_c, 'on');

    tab3 = uitab(tabGroup, 'Title', '3.OOK received signals and bits comparison');
    grid3 = uigridlayout(tab3, [2,1]);
    axOOK_r = uiaxes(grid3); title(axOOK_r, 'OOK received signal'); grid(axOOK_r,'on');
    axOOK_cb = uiaxes(grid3); title(axOOK_cb, 'Comparison of bits (OOK)'); grid(axOOK_cb,'on');

    tab4 = uitab(tabGroup, 'Title', '4.BFSK received signals and bits comparison');
    grid4 = uigridlayout(tab4, [2,1]);
    axBFSK_r = uiaxes(grid4); title(axBFSK_r, 'BFSK received signal'); grid(axBFSK_r,'on');
    axBFSK_cb = uiaxes(grid4); title(axBFSK_cb, 'Comparison of bits (BFSK)'); grid(axBFSK_cb,'on');

    tab5 = uitab(tabGroup, 'Title', '5. Stress test analysis');
    grid5= uigridlayout(tab5, [2 1]);
    axSNR = uiaxes(grid5); title(axSNR, 'BER-SNR Analysis'); grid(axSNR,'on');
    axER = uiaxes(grid5); title(axER, 'BER-ER Analysis'); grid(axER,'on');

    %% --- LOGIC ---
    runBtn.ButtonPushedFcn = @(btn, event) runAnalysis();

    function updateProg(val)
        progFill.Position(3) = max(1, val * (progBg.Position(3) - 2));
        drawnow;
    end

    function runAnalysis()
        runBtn.Enable = 'off';
        updateProg(0.05);
        
        % Data Fetching
        rawInput = msgInput.Value;
        if strcmp(srcType.Value, 'Random Bits'), rawInput = str2double(rawInput); end
        
        L = lenInput.Value * 1e3;
        spb = spbInput.Value;
        bit_rate = brInput.Value * 1e6;
        Fs = bit_rate * spb;
        
        f_struct.alpha = alphaInput.Value/4.343e3;
        f_struct.beta2 = beta2Input.Value * 1e-27;
        f_struct.beta3 = beta3Input.Value * 1e-39;
        f_struct.gamma = gammaInput.Value * 1e-3;
        
        pauseTime = 0.1 / psInput.Value; 

        % 1. Source
        [original_bits, m_type] = source_gen(rawInput, axSource); 
        pad_len = 8; bits = [zeros(1, pad_len), original_bits, zeros(1, pad_len)]; 
        updateProg(0.2);
        
        % 2. OOK
        statusLabel.Text = 'Running OOK Path...';
        cfg_o.bit_rate = bit_rate; cfg_o.samples_per_bit = spb; cfg_o.Fs = Fs; cfg_o.ER_dB = erInput.Value;
        [tx_o, par_o] = transmitter(bits, 'OOK', cfg_o, axOOK_t);
        [rx_o, ~] = SSFM_channel(tx_o, Fs, L, 200, f_struct, pauseTime, axOOK_c);
        
        par_o.threshold = (max(abs(rx_o)) + min(abs(rx_o))) / 2;
        [corr, lags] = xcorr(abs(rx_o), abs(tx_o));
        [~, idx] = max(corr);
        rx_o_aligned = circshift(rx_o, -lags(idx));
        
        rec_bits_o_p = receiver(rx_o_aligned, 'OOK', par_o, tx_o, bits, axOOK_r, axOOK_cb);
        rec_bits_o = rec_bits_o_p(pad_len + 1 : end - pad_len);
        updateProg(0.5);

        % 3. BFSK
        statusLabel.Text = 'Running BFSK Path...';
        [tx_f, par_f] = transmitter(bits, 'BFSK', cfg_o, axBFSK_t);
        [rx_f, ~] = SSFM_channel(tx_f, Fs, L, 200, f_struct, pauseTime, axBFSK_c);
        
        [corr_f, lags_f] = xcorr(abs(rx_f), abs(tx_f));
        [~, idx_f] = max(corr_f);
        rx_f_aligned = circshift(rx_f, -lags_f(idx_f));
        
        rec_bits_f_p = receiver(rx_f_aligned, 'BFSK', par_f, tx_f, bits, axBFSK_r, axBFSK_cb);
        rec_bits_f = rec_bits_f_p(pad_len + 1 : end - pad_len);
        updateProg(0.8);

        % 4. Output & Rec
        res_text_o = received_bit_to_text(rec_bits_o, m_type);
        res_text_f = received_bit_to_text(rec_bits_f, m_type); 
        decodedBox.Value = sprintf("OOK Decoded: %s\nBFSK Decoded: %s", res_text_o, res_text_f);

        statusLabel.Text = 'Finalizing Analysis...';
        performStressTest(original_bits, snrInput.Value, erInput.Value, axSNR, axER);
        
        % Logic check
        ook_ok = strcmp(res_text_o, msgInput.Value);
        bfsk_ok = strcmp(res_text_f, msgInput.Value);
        
        if ook_ok && bfsk_ok
            rec = "OOK"; reason = "Both achieved 0 BER. OOK preferred for efficiency.";
        elseif bfsk_ok
            rec = "BFSK"; reason = "BFSK maintained integrity while OOK failed.";
        else
            rec = "OOK/BFSK"; reason = "Check parameters for high-dispersion impacts.";
        end
        
        conclusionBox.Value = sprintf("RECOMMENDATION: %s\nReason: %s", rec, reason);
        statusLabel.Text = 'Simulation Complete.';
        updateProg(1.0); runBtn.Enable = 'on';
    end
end