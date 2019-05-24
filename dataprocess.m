clc
clear all
M = csvread('daopin_4_2.txt');
loop = 100000;
[nrows, ncols] = size(M);
data = zeros(nrows, ncols * 2);
for col=1:ncols
    data(:, col*2-1) = real(M(:, col));
    data(:, col*2) = imag(M(:, col));
end

% x = 1:25:250;
% x = [-124, -75, -25, 25, 75, 125];
% x = [-124,-100,-75,-50,-25,0,25,50,75,100,125];
% x = -124:10:125;
x = load('dp62.txt');
% data_col = data(:,1)';
result = zeros(250, ncols*2);
result2 = zeros(250, ncols*2);
frequency = -124:125;

noise = normrnd(-0.014,0.0411, length(x),1)+normrnd(0.0075,0.0366, length(x),1)*1i; 

for col=1:ncols*2
%     real = average(data(:,col), loop);
    fitmodel1 = createFit1(x, data(:,col)+normrnd(0,0.08, length(x),1));
    tmp = fitmodel1(frequency);
    tmp = smooth(tmp, 1, 'moving');
    result(:,col) = xiaobo(tmp);
%     lev=3;wn='db45';ln = 'one';tptr='rigrsure';
    % 利用soft SURE阈值规则去噪
%     result(:,col)= wden(tmpp, tptr, 's', ln, lev, wn);
    
%     imag = real;
    fitmodel2 = createFit2(x, data(:,col));
    tmp2 = fitmodel2(frequency);
    tmpp = xiaobo(tmp2);
    %小波去噪
    lev=3;wn='db40';ln = 'one';tptr='sqtwolog';
    % 利用soft SURE阈值规则去噪
    result2(:,col)= wden(tmpp, tptr, 's', ln, lev, wn);
%     predict_imag= wden(predict_imag, tptr, 's', ln, lev, wn);
end
MM = zeros(250, 5);
MM2 = zeros(250, 5);
for i=1:250
    for j=1:5
        MM(i,j) = result(i,2*j-1)+result(i,2*j)*1i;
        MM2(i,j) = result2(i,2*j-1)+result2(i,2*j)*1i;
    end
end
% plot(-124:125, result2(:,1), 'b')
% hold on
% scatter(x', data(:,1),'d','filled') 

% noise = normrnd(-0.014,0.0411, 250,5)+normrnd(0.0075,0.0366, 250,5)*1i; 
csvwrite('submission.csv', MM)
csvwrite('submission2.csv', MM2)
% fid=fopen('submission.txt','wt'); %新建文件,你要保存到的文件路径,该路径的最后为'\文件名.txt'或者是'\文件名.dat'
% [m,n]=size(MM2);
% MM2=mat2str(MM2);
% for j=1:m
% for z=1:n
% if z==n
% fprintf(fid,'%g\n',MM2(j,z)); %一行一行的写入数据，到该行的最后一个数据，回车
% else
% fprintf(fid,'%g\t',MM2(j,z)); %相邻两个数据之间隔2个字符，相当于按一次Tab键
% end
% end
% end
% fclose(fid);
fprintf('done!\n')

% 导频数用62，此时导频和误差百分比大致在50%
% 导频分开实部和虚部分开进行拟合，拟合函数使用SmoothingSpline
% 拟合出来函数是带噪声的，接下来去噪
% 用小波变换，小波基为coif5,分解层数为10层 
% 输出最终结果，感觉有点过拟合了

