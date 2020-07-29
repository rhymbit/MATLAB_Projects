% converting recived data to binary format
% and then decoding data for final output

% For Encoded Data
r_data0 = sign(rx_data1*code');

r_data = (r_data0 + 1)/2;

b_r_data = r_data';

rec_data = bi2de(b_r_data);

final_data = []; %pre-allocating

k = 1;
s = size(data);
for i = 1:s(1,2)
    for j = 1:s(1,1)
        final_data(j,i) = rec_data(k);
        k = k + 1;
        if k > length(rec_data)
            break;
        end
    end
end

%For Original non-encoded data
o_r_data = sign(rx_original_data);
o_r_data = (o_r_data + 1)/2;
b_r_o_data = o_r_data';

o_rec_data = bi2de(b_r_o_data);


k1 = 1;
s1 = size(data);
for i = 1:s1(1,2)
    for j = 1:s1(1,1)
        o_recieved(j,i) = o_rec_data(k1);
        k1 = k1 + 1;
        if k1 > length(o_rec_data)
            break;
        end
    end
end