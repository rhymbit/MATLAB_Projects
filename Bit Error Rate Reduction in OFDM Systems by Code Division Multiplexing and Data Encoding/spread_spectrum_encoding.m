encoded_data = 2*b_data - ones(8,NumOfSym*M);

code = hadamard(NumOfSym*M);

data0 = encoded_data * code;

% spreading data spectrun by upsampling the data in
% time domain
col = 1; row = 1; %local variables to use
cold = 1; rowd = 1;  % cold & rowd = column of data
                     %                and row of data
save = Q; % using bandwidth spreading factor for upsampling
          % the given data

s = size(data0);
tx_data_spread = []; % preallocating
while rowd <= s(1,1)
    while Q > 0
        if Q == save
            if col > s(1,2)
                col = 1;
                row = row + 1;
            end
            if cold > s(1,2)
                cold = 1;
                rowd = rowd + 1;
            end
            if rowd > s(1,1)
                break;
            end
            tx_data_spread(row,col) = data0(rowd,cold);
            cold = cold + 1;
            col = col + 1;
            Q = Q - 1;
        else
            if col > s(1,2)
                row = row + 1;
                col = 1;
            end
            tx_data_spread(row,col) = 0;
            col = col + 1;
            Q = Q - 1;
        end
    end
    Q = save;
end
if length(tx_data_spread) < N
    for k = length(tx_data_spread):N
        for p = 1:s(1,2)
            tx_data_spread(k,p) = 0;
        end
    end
end