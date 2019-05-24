function [ s0 ] = xiaobo( s )
wname = 'coif5';
level = 7;
s = s';
N = numel(s); 
%小波分解; 
[c,l]=wavedec(s,level,wname); %小波基为coif5,分解层数为7层 
ca11=appcoef(c,l,wname,level); %获取低频信号 
cd1=detcoef(c,l,1); 
cd2=detcoef(c,l,2); %获取高频细节 
cd3=detcoef(c,l,3); 
cd4=detcoef(c,l,4); 
cd5=detcoef(c,l,5); 
cd6=detcoef(c,l,6); 
cd7=detcoef(c,l,7); 
% cd8=detcoef(c,l,8); 
% cd9=detcoef(c,l,9); 
% cd10=detcoef(c,l,10); 

% sd1=wthresh(cd1,'s',0.014); 
% sd2=wthresh(cd2,'s',0.014); 
% sd3=wthresh(cd3,'s',0.014); 
sd1=zeros(1,length(cd1)); 
sd2=zeros(1,length(cd2)); %1-3层置0,4-7层用软阈值函数处理 
sd3=zeros(1,length(cd3)); 
% sd4=zeros(1,length(cd4));
% sd5=zeros(1,length(cd5));
sd4=wthresh(cd4,'s',0.0014); 
sd5=wthresh(cd5,'s',0.0014); 
sd6=wthresh(cd6,'s',0.0014); 
sd7=wthresh(cd7,'s',0.0014); 
% sd8=wthresh(cd8,'s',0.1); 
% sd9=wthresh(cd9,'s',0.1); 
% sd10=wthresh(cd10,'s',0.1); 

% c2=[ca11,sd10,sd9,sd8,sd7,sd6,sd5,sd4,sd3,sd2,sd1]; 
c2=[ca11,sd7,sd6,sd5, sd4,sd3,sd2,sd1]; 
s0=waverec(c2,l,wname); %小波重构 
s0 = s0';
end

