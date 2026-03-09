function [Aout, Az] = SSFM_channel(Ain, Fs, L, Nz, fiber, T, target_ax)

% This program solves the nonlinear Schrödinger equation using the
% split-step Fourier method

% The folowing input and output variables are required:

% Ain - this is the input optical pulse from the optical modulator
% Fs - the sampling frequency
% L - the length of the fiber
% Nz - the number of steps to simulate along the fiber
% fiber - fiber structure (stepped index, graded index, multi or single
% mode)
% T - pause, sim was too fast

% Two outputs are obtained:

% Aout - optical pulse at the receiving end of the fiber
% Az - evolution of the pulse for visualization


% Define variables for the grid

N = length(Ain); % number of samples (time)
dz = L/Nz; % step size for propagation
df = Fs/N; % spacing of frequency steps
f = (-N/2:N/2 - 1)*df; % range of frequency for Nyquist theorem (-1 is needed to avoid using N/2 twice)
t = (-N/2:N/2-1)*10^-12; 
w = 2*pi*f; % angular frequency

% Define the parameters of the fiber

alpha = fiber.alpha; % attenuation 
beta2 = fiber.beta2; % group velocity dispersion (pulse broadening due to different group velcoities corresponding to different frequencies of light)
beta3 = fiber.beta3; % third-order dispersion (due to frequency dependence of GVD that leads to aysmmetric broadiening of the pulse)
gamma = fiber.gamma; % fiber nonlinearities (related to nonlinear refractive index, wavelength, and effective mode area of the fiber core)

% First we define the linear operator (accounts for attenuation and
% dispersion)

D = exp((-alpha/2)*dz - j*(beta2/2)*w.^2*dz - j*(beta3/6)*w.^3*dz);

% Next we need to initialize the field A

A = Ain;
Az = zeros(Nz+1, N); % Az is used for visualization
Az(1,:) = A; % We store the original field in the first position

% Next we initialize a figure before the loop so we can have live
% visualization of the pulse with initial visulation at the transmitting
if nargin > 6 && ~isempty(target_ax)
    h_ax = target_ax;
    cla(h_ax);
    h_plot = plot(h_ax, t*1e12, abs(A).^2);
    xlabel(target_ax, 't(ps)'); ylabel(target_ax, 'P(W)');
    grid(target_ax, 'on');
    target_ax.YLimMode = 'auto';
    pause(T);
else
    figure;
    h_ax = gca;
    h_plot = plot(h_ax, t*1e12, abs(A).^2);
    xlabel (h_ax, 't (ps)');
    ylabel(h_ax, 'P (W)');
    axis(h_ax, [t(1)*1e12 t(end)*1e12 0 max(abs(A).^2)]); % so our axis is fixed during animation
    grid(h_ax, 'on');
    title(sprintf('z = %.2f km', 0));
end
title(h_ax, sprintf('z = %.2f km', 0));


% Now we can perform the SSFM with a for loop
% In this loop we will do the symmetric SSFM for improved accuracy which
% requires we do half a nonlinear step on either side of the linear step

for k = 1:Nz

    % First half non linear step

    A = A.*exp(j*gamma*abs(A).^2*dz/2);

    % Now we do the full linear step
    % We have to do fft so we can multiply in the frequency domain
    % We need fftshift since the fft has frequencies return with zero at
    % the leftmost spot but we want it to be in the middle to match our
    % linear operator

    A = fftshift(fft(A)); 
    A = A.*D;
    A = ifft(ifftshift(A));

    % Next we apply the second half nonlinear step

    A = A.*exp(j*gamma*abs(A).^2*dz/2);

    % We store the field 

    Az(k+1,:) = A;
    set(h_plot, 'YData', abs(A).^2);
    h_ax.YLim = [0, max(abs(A).^2) * 1.1 + 1e-12];
    title(h_ax, sprintf('z = %.2f km', k*dz/1e3));

    drawnow limitrate;
    pause(T)
    % We can visualize the propagation of the pulse with drawnow

    % set(fig_t, 'YData', abs(A).^2);
    % title(sprintf('z = %.2f km', k*dz/1e3));
    % 
    % drawnow;
    %pause(0.1); % sim was too fast

end 

Aout = A; % the pulse at the recieving end of the fiber

drawnow;
end