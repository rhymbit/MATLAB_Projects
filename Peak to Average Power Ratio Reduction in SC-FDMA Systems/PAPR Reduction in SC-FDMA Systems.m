%% Topic :- Peak to Average Power Ratio Analysis of Single Carrier Frequency Division Multiple Access plus Soft-Clipping
%**************************************************************************

%% OFDM System Parameters

N = 256;   %length of OFDM IFFT (eg. 16,32,...2^n)
M = 16;   %number of QAM constellation points
          % Using QAM as the modulation technique for input data
GI = 1/4;   %Gaurd Interval or Cyclic Prefix
NumOfSym = 100;   %number of OFDM data symbols
Q = floor(N/NumOfSym);   %Bandwidth Spreading Factor

%% OFDM data generation and modulation
% tx stand for transmitter

txData = randi(N,NumOfSym,M);   %random integers gen. with max val N
txData = floor(txData/16.5); %adjusting data for inbuilt Matlab QAM func.
txDataMod = qammod(txData,M);   %QAM data

%% Fast Fourier Transform 

txDataMod = fft(txDataMod);

%% Subcarrier Mapping for PAPR reduction


% (1). Localized Frequency Division Multiple Access(LFDMA)

txDataModLFDMA = txDataMod;
for k = length(txDataMod):N
    for p = 1:M
        txDataModLFDMA(k,p) = 0;
    end
end

% (2). Interleaved Frequency Division Multiple Access(IFDMA)

col = 1; row = 1;  %variables col and row
cold = 1; rowd = 1;  %here cold and rowd refers to column of data
                     %and row of data before subcarrier mapping
save = Q;   %bandwidth spreading factor value saved 

while rowd < length(txDataMod)
    while Q > 0
        if Q == floor(N/NumOfSym)
            if col > M 
                col = 1;
                row = row + 1;
            end
            if cold > M
                cold = 1;
                rowd = rowd + 1;
            end
            txDataModIFDMA(row,col) = txDataMod(rowd,cold);
            cold = cold + 1;
            col = col + 1;
            Q = Q - 1;
        else
            if col > M;
                row = row + 1;
                col = 1;
            end
            txDataModIFDMA(row,col) = 0;
            col = col + 1;
            Q = Q - 1;
        end
    end
    Q = save;
end

% Filling zeros to make data length equal to number of subcarriers
% Results in increased bandwidth

if rowd > length(txDataMod)-1
    for p = length(txDataModIFDMA)+1:1:N
        for q = 1:1:M
            txDataModIFDMA(p,q) = 0;
        end
    end
end

% (3). Distributed Frequency Division Multiple Access(DFDMA)

cold = 1; %cold refers to columns of data before subcarrier mapping
for p = 1:1:N
    for q =1:2:M
        if p <= length(txDataMod)
            if cold == M
                cold = 1;
            end
            txDataModDFDMA(p,q) = txDataMod(p,cold);
            cold = cold + 1;
        else
            txDataModDFDMA(p,q) = 0;
        end
    end
end

%% IFFT operation to make trasmitting data Orthogonal

txDataIfftLFDMA = (1/sqrt(N))*ifft(txDataModLFDMA,N);

txDataIfftIFDMA = (1/sqrt(N))*ifft(txDataModIFDMA,N);

txDataIfftDFDMA = (1/sqrt(N))*ifft(txDataModDFDMA,N);


%% Cyclic Prefix Insertion

txDataIfftLFDMAGI = [txDataIfftLFDMA((1-GI)*N+1:end,:);txDataIfftLFDMA];

txDataIfftIFDMAGI = [txDataIfftIFDMA((1-GI)*N+1:end,:);txDataIfftIFDMA];

txDataIfftDFDMAGI = [txDataIfftDFDMA((1-GI)*N+1:end,:);txDataIfftDFDMA];


%% Complementary Cumulative Distribution Function(CCDF)
alpha = 1;  %oversampling factor

%Different Number of Subcarriers
N1 = 32*alpha ; N2 = 64; N3 = 128; N4 = 256; N5 = 512; 

% Generating Probablity Distribution Functions for subcarriers
i = 0;
for R=1:0.5:15  
    i = i+1;
    P1(i) = (1-(1-exp(-R))^N1);  % PDF for 32 subcarriers
end
i = 0;
for R=1:0.5:15
    i = i+1;
    P2(i) = (1-(1-exp(-R))^N2);   % PDF for 64 subcarriers
end
i = 0;
for R=1:0.5:15
    i = i+1;
    P3(i) = (1-(1-exp(-R))^N3);   % PDF for 128 subcarriers
end
i = 0;
for R=1:0.5:15
    i = i+1;
    P4(i) = (1-(1-exp(-R))^N4);    % PDF for 256 subcarriers
end
i = 0;
for R=1:0.5:15
    i = i+1;
    P5(i) = (1-(1-exp(-R))^N5);   % PDF for 512 subcarriers
end

% Plotting results
R=1:0.5:15;
Rd=10*log10(R);
semilogy(Rd,P1,Rd,P2,Rd,P3,Rd,P4,Rd,P5);
axis([4 13 1e-4 1]);
legend('32 subcarriers','64 subcarriers','128 subcarriers', ...
    '256 subcarriers','512 subcarriers');
grid on; 
hold on;
xlabel('PAPRo [dB]');
ylabel('Prob (PAPRlow > PAPRo )');
title('PAPR reduction due to number of Subcarriers');