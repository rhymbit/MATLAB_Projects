% Inverse-Fast Fourier Transform
% Converting data from time domain to frequency domain
% and adding orthogonal components to the data

tx_data_spread_IFFT = ifft2(tx_data_spread);
tx_data_original = ifft2(original_data);

% Cyclic prefix insertion

Z = size(tx_data_spread_IFFT);
tx_data_spread_IFFT_GI = [tx_data_spread_IFFT((1-GI)*Z(1,1)+1:end,:);... 
                            tx_data_spread_IFFT];
Z1 = size(tx_data_original);
tx_data_original_GI = [tx_data_original((1-GI)*Z1(1,1)+1:end,:);... 
                            tx_data_original];

% adding Additive White Gaussian Noise

final_tx_data = awgn(tx_data_spread_IFFT_GI,50);

final_original_data = awgn(tx_data_original_GI,50);