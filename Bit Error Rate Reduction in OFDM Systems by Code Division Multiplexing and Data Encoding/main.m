clear; clc;

% OFDM System Parameters
NumOfSym = 128;%number of OFDM data symbols
N = 256; %length of FFT
GI = 1/4; %Gaurd interval length
M = 16; 
Q = 2; %Bandwidht spreading factor

% OFDM Data Generation
data = randi([3 (N-1)],NumOfSym,M);
b_data = de2bi(data); % converting data to binary
b_data = (b_data)';

original_data = b_data; % this data will be sent without any encoding
                        % and spread spectrum

%Calling Spread Spectrum file
spread_spectrum_encoding;

%Calling transmitter file
transmitter;

%Calling Reciever file
reciever;

%Calling data recovery file
rx_data_recovery;

%Bit error rate calculations
bit_error_rate;

%To delete unnecessary variables in workspace
var_delete