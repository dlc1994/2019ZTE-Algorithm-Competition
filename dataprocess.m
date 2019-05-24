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
    % ����soft SURE��ֵ����ȥ��
%     result(:,col)= wden(tmpp, tptr, 's', ln, lev, wn);
    
%     imag = real;
    fitmodel2 = createFit2(x, data(:,col));
    tmp2 = fitmodel2(frequency);
    tmpp = xiaobo(tmp2);
    %С��ȥ��
    lev=3;wn='db40';ln = 'one';tptr='sqtwolog';
    % ����soft SURE��ֵ����ȥ��
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
% fid=fopen('submission.txt','wt'); %�½��ļ�,��Ҫ���浽���ļ�·��,��·�������Ϊ'\�ļ���.txt'������'\�ļ���.dat'
% [m,n]=size(MM2);
% MM2=mat2str(MM2);
% for j=1:m
% for z=1:n
% if z==n
% fprintf(fid,'%g\n',MM2(j,z)); %һ��һ�е�д�����ݣ������е����һ�����ݣ��س�
% else
% fprintf(fid,'%g\t',MM2(j,z)); %������������֮���2���ַ����൱�ڰ�һ��Tab��
% end
% end
% end
% fclose(fid);
fprintf('done!\n')

% ��Ƶ����62����ʱ��Ƶ�����ٷֱȴ�����50%
% ��Ƶ�ֿ�ʵ�����鲿�ֿ�������ϣ���Ϻ���ʹ��SmoothingSpline
% ��ϳ��������Ǵ������ģ�������ȥ��
% ��С���任��С����Ϊcoif5,�ֽ����Ϊ10�� 
% ������ս�����о��е�������

