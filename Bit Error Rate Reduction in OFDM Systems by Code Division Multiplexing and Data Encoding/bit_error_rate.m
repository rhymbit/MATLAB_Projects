% For Encoded Data
b_r_data = b_r_data';
SER = [];
Es = 10;
x = 1:512;
for i = 1:length(x)
    Eb2N(i) = i*2;
    Eb2N_num = 10^(Eb2N(i)/10);
    Var_n = Es/(2*Eb2N_num);
    temp = log(i+1);
    SER = [SER;sum( b_r_data ~= b_data)/temp];
    Q(i) = 3*0.5*erfc(sqrt((2*Eb2N_num/5)/2));
end
SER = diag(SER);
SER = sort(SER,'descend');
figure;
subplot(111)
figber = semilogy(Eb2N,Q);
axis([2 18 .99e-5 1]);
ylabel('Symbol error rate');
xlabel('Signal Power/Noise Power');
grid on; hold on;
title('Error funtcion for BER of QAM');
legend('erfc function');
hold off;

% For original Data
b_r_o_data = b_r_o_data';
SER1 = [];
for i = 1:length(x)
    temp1 = log(i+1);
    SER1 = [SER1;sum( b_r_o_data ~= b_data)/temp1];
end
SER1 = diag(SER1);
SER1 = sort(SER1,'descend');


figure(2);
plot(x,SER,'red',x,SER1,'BLUE');
axis([0 500 0 2]);
ylabel('Symbol error rate');
xlabel('Signal Power/Noise Power');
grid on; hold on;
title('BER for Encoded data & Original data');
legend('Original data','Encoded data');