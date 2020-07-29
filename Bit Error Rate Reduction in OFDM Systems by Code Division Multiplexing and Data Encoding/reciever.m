% Cyclic Prefix Removal

rx_data = final_tx_data(((Z(1,1)-((1-GI)*Z(1,1)+1)))+2:end,:);
rx_original_data = final_original_data(((Z1(1,1)-((1-GI)*Z1(1,1)+1)))+2:end,:);

% Fast Fourier Transform
% To remove orthogonality from code

rx_recovered_data = fft2(rx_data);  % for encoded data
rx_original_data = fft2(rx_original_data); % for original data

rx_original_data = real(rx_original_data);

% Removing spread Spectrum Components from the encoded signal
rx_data = real(rx_recovered_data);
rx_data1 = [];
a = 1; b = 1;
s = size(rx_data);
for i = 1:1:s(1,1)
    for j = 1:1:s(1,2)
        if (rx_data(i,j) < 2 && rx_data(i,j) > -2)
               j = j + 1;
            if j > s(1,2)
               j = 1;
               i = i + 1;
            end
        else
            rx_data1(a,b) = rx_data(i,j);
            b = b+1;
            if b > s(1,2)
                b = 1;
                a = a + 1;
            end
          end
     end
end
        