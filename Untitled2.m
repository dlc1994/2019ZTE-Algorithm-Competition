% N = load('daopin_4_2.txt');
clc;clear
sample = csvread('sample.txt');
MM = zeros(250, 1);
[nrows, ncols] = size(sample);
% x = [-124,-100,-75,-50,-25,0,25,50,75,100,125];
% x = -124:5:125;
% % x = sort(randperm(250, 80)-125)';
% x = x';
x = load('dp62.txt');
% x = [-124 -116 -108 -100 -92 -84 -76 -68 -60 -52 -44 -36 -28 -20 -12 -4 ...
%          4 12 20 28 36 44 52 60 68 76 84 92 100 108 116 124]';
% csvwrite('dp62.txt',x')
xx = x+125;
noise = normrnd(-0,0.5, length(x),1)+normrnd(0,0.5, length(x),1)*1i; 
noise_real = sample(xx, 3);
noise_imag =sample(xx, 4);

% noise_real = sample(xx, 1) + real(noise);
% noise_imag = sample(xx, 2) + imag(noise);
% % 
% noise_real = xiaobo(noise_real);
% noise_imag = xiaobo(noise_imag);

% static_real = zeros(length(noise_real),1);
% static_imag = zeros(length(noise_imag),1);
% loop = 100000;
% u = 0;
% sigma = 1;
% for i=1:loop
%     noise_r = normrnd(u, sigma, length(noise_real), 1);
%     static_real = static_real + noise_real - noise_r;
%     noise_i = normrnd(u, sigma, length(noise_real), 1);
%     static_imag = static_imag + noise_imag - noise_i;
% end
% static_real = static_real / loop;
% static_imag = static_imag / loop;
noise = normrnd(0,0.04, 250,1)+normrnd(0,1, 250,1)*1i;

% predict_real = OMP_func(x, 62, 250, 1);
% predict_imag = OMP_func(x, 62, 250, 1);
%method 1
fitmodel_sample1 = createFit1(x, noise_real);
fitmodel_sample2 = createFit1(x, noise_imag);
predict_real = fitmodel_sample1(-124:125);
predict_imag = fitmodel_sample2(-124:125);

% for i=1:250
%     for j=1:1
%         MM(i,j) = predict_real(i,1)+predict_imag(i,1)*1i;
%     end
% end
% MM = ifft(MM);
% lev = 1; wn = 'sym8';
% MM = wden(MM,'heursure','s','sln',lev,wn);
% MM = fft(MM);
% predict_real = real(MM);
% predict_imag = imag(MM);
% predict_imag = ifft(predict_imag);
% lev = 1; wn = 'sym8';
% predict_imag = wden(predict_imag,'heursure','s','sln',lev,wn);
% predict_imag = fft(predict_imag);

predict_real = smooth(predict_real,2, 'moving');
predict_imag = smooth(predict_imag,2, 'moving');
% %小波变换
predict_real = xiaobo(predict_real);
predict_imag = xiaobo(predict_imag);
% %小波去噪
% lev=10;wn='db45';ln = 'one';tptr='rigrsure';
% lev=6;wn='coif5';ln = 'sln';tptr='sqtwolog';
% 利用soft SURE阈值规则去噪
% predict_real= wden(predict_real, tptr, 's', ln, lev, wn);
% predict_imag= wden(predict_imag, tptr, 's', ln, lev, wn);

% 
% %小波去噪
% lev=20;wn='sym8';
% % 利用soft SURE阈值规则去噪
% predict_real= wden(predict_real, 'minimaxi', 's', 'sln', lev, wn);
% predict_imag= wden(predict_imag, 'minimaxi', 's', 'sln', lev, wn);
% predict_real = predict_real - real(noise);
% predict_imag = predict_imag - imag(noise);

channel_real = sample(:, 1);
channel_imag = sample(:, 2);
C = sum((predict_real-channel_real).^2 + (predict_imag-channel_imag).^2);
H = sum(channel_real.^2 + channel_imag.^2);
fprintf('method1, Ea:  %d, Eb:  %d, E:  %d\n', C/H, length(x)/2500, C/H + length(x)/2500);
plot(-124:125, predict_real, 'r')
hold on
digits(2);
predict_real= vpa(predict_real);
predict_imag = vpa(predict_imag);

%method 2
fitmodel_sample1 = createFit2(x, noise_real);
fitmodel_sample2 = createFit2(x, noise_imag);
predict_real = fitmodel_sample1(-124:125);
predict_imag = fitmodel_sample2(-124:125);
%小波变换
predict_real = xiaobo(predict_real);
predict_imag = xiaobo(predict_imag);

%小波去噪
lev=5;wn='sym8';ln = 'mln';tptr='heursure';
% lev=7;wn='coif5';ln = 'sln';tptr='sqtwolog';
% 利用soft SURE阈值规则去噪
predict_real= wden(predict_real, tptr, 's', ln, lev, wn);
predict_imag= wden(predict_imag, tptr, 's', ln, lev, wn);

% %小波变换
% predict_real = xiaobo(predict_real);
% predict_imag = xiaobo(predict_imag);
% predict_real = predict_real - real(noise);
% predict_imag = predict_imag - imag(noise);
% 
% noise_real = smooth(noise_real, 'moving');
% noise_imag = smooth(noise_imag, 'moving');

channel_real = sample(:, 1);
channel_imag = sample(:, 2);
C = sum((predict_real-channel_real).^2 + (predict_imag-channel_imag).^2);
H = sum(channel_real.^2 + channel_imag.^2);
fprintf('method2, Ea:  %d, Eb:  %d, E:  %d\n', C/H, length(x)/2500, C/H + length(x)/2500);
fprintf('percent, Ea:  %d , Eb:  %d , E:  %d \n', C/H/(C/H + length(x)/2500), length(x)/2500/( C/H + length(x)/2500), C/H + length(x)/2500);

% consider noise: Ea:  4.264550e-02, Eb:  2.000000e-02, E:  6.264550e-02
% minus    noise: Ea:  4.011335e-02, Eb:  2.000000e-02, E:  6.011335e-02 样本一次
% no   2   noise: Ea:  4.206490e-02, Eb:  5.000000e-02, E:  9.206490e-02
% no   1   noise: Ea:  4.123032e-02, Eb:  1.000000e-01, E:  1.412303e-01
% xiaobobianhuan: Ea:  7.030419e-02, Eb:  2.000000e-02, E:  9.030419e-02
% 统计平均100   : Ea:  4.256002e-02, Eb:  2.000000e-02, E:  6.256002e-02
% 统计平均10000 : Ea:  4.115769e-02, Eb:  2.000000e-02, E:  6.115769e-02
% 统计平均100000: Ea:  4.114562e-02, Eb:  2.000000e-02, E:  6.114562e-02
% 样本平均10000 : Ea:  4.010292e-02, Eb:  2.000000e-02, E:  6.010292e-02  % 当前最优，平均没用
% 小波变换 预测后再变换50个导频   : Ea:  3.667115e-02, Eb:  2.000000e-02, E:  5.667115e-02 4-14最优
% 65个导频 50%:50%                : Ea:  2.263320e-02, Eb:  2.600000e-02, E:  4.863320e-02
% 改小波变换，改导频 62个导频

%method3
% S1 = sample(:,1)+1i*sample(:,2);
% S1 = S1.';
% S2 = sample(xx,3)+1i*sample(xx,4);
% S2 = S2.';
% % method = 'linear'/'spline'/'cubic'|插值方法
% P2 = interpolate(S2,xx',250,'cubic');
% plot(-124:125, real(P2),'y','linewidth',2)
% hold on
% P2t = ifft(P2);
% lev = 1; wn = 'sym8';
% P2t_modified = wden(P2t,'heursure','s','sln',lev,wn);
% P2_modified = fft(P2t_modified);
% Ea = sum(power(abs(S1-P2_modified),2))/sum(power(abs(S1),2));
% Eb = length(xx)/2500;
% E = Ea+Eb;
% fprintf('method3, Ea:  %d, Eb:  %d, E:  %d\n',Ea, Eb, E);
% plot(-124:125, real(P2_modified),'r','linewidth',2)
% hold on


plot(-124:125, predict_real, 'g')
hold on
plot(-124:125, sample(:,1), 'b')
hold on
scatter(x', noise_real,'d','filled') 
hold on 
% scatter(x', noise_real-real(noise), 'filled')
% hold on
plot(-124:125, sample(:,3), 'm')
legend('predict_1','predict_2','real', 'given', 'noise')
