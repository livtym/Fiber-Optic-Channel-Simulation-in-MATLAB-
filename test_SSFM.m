% to test the SSFM channel function 

clc
clear

Fs = 500e9; % Nyquist sampling frequency
N = 1024; 
t = (-100:100)*10^-12;

T = 5e-12; % width of pulse in time domain (ps)
P = 1000; % peak power is arbitray

% Will generate an arbitrary gaussian pulse for this

A = sqrt(P)*exp(-(t/T).^2);

% Fiber params

% % No attenuation/dispersion

% fiber.alpha = 0;
% fiber.beta2 = 0;
% fiber.beta3 = 0;
% fiber.gamma = 0;

% % Attenuation

% fiber.alpha = 0.2/4.343e3;
% fiber.beta2 = 0;
% fiber.beta3 = 0;
% fiber.gamma = 0;
% 
% % Attenuation and GVD

% fiber.alpha = 0.2/4.343e3; % 0.2 dB/km
% fiber.beta2 = -21e-27; 
% fiber.beta3 = 0; 
% fiber.gamma = 0;

% % Attenuation, GVD, and TOD
% 
% fiber.alpha = 0.2/4.343e3;
% fiber.beta2 = -21e-27; 
% fiber.beta3 = 0.1e-39; 
% fiber.gamma = 0;

% % Attenuation, GVD, TOD, and nonlinearities

fiber.alpha = 0.2/4.343e3;
fiber.beta2 = -21e-27; 
fiber.beta3 = 0.1e-39; 
fiber.gamma = 1.3e-3;

L = 10e3;
Nz = 200; 

[Aout, Az] = SSFM_channel(A, Fs, L, Nz, fiber, 0.05);


