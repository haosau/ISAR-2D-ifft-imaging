%% 2d FFT成像
clear all%#ok
close all
clc
load('ship1025.mat');
%% 参数设置
c = 3e8;
%%f的离散设置=======================
f_Min = 4e9;
f_Max = 4.045e9;
fn=51;
f_Interval=(f_Max-f_Min)/(fn-1);
%f_Interval = 80e6;
%fn = (f_Max-f_Min)/f_Interval+1;
fc = (f_Max-f_Min)/2+f_Min;
B = f_Max-f_Min;
pr=c/B/2;
r_width = c/2/f_Interval;3
%%=====================================

%%Phi的离散设置================================方位角观测角度
Phi_Min = -5 / 180 * pi;
Phi_Max = 5 / 180 * pi;
Phi_Interval = 0.2 / 180 * pi;
pn=ceil((Phi_Max-Phi_Min)/Phi_Interval+1);
pa=c/fc/2/(Phi_Max-Phi_Min);
p_width = c/2/Phi_Interval/fc;
%%================================

%% 读取数据
E = zeros(fn,pn);
%data_real=load('real.txt');
%data_imag=load('imag.txt');
%data=data_real + 1i * data_imag;
%for i=1:fn
 %   E(i,:)=data(pn*(i-1)+1:i*pn);
%end
E=data{6,1};
%% FFT成像
ISAR=(fft2(E.',4*2^nextpow2(pn),4*2^nextpow2(fn)));
cmx=abs(fftshift(ISAR));
S =cmx/max(max(abs(cmx)));
ff=linspace(-(fn-1)/2*pr,(fn-1)/2*pr,4*2^nextpow2(fn));
pp=linspace(-(pn-1)/2*pa,(pn-1)/2*pa,4*2^nextpow2(pn));%pa pr 分辨率  fn pn 范围
figure(1);
imagesc(ff,pp,20*log10(S))
xlabel('距离向/m', 'fontsize',12);                        
ylabel('方位向/m','fontsize',12);
title('回波成像');
colormap(jet);
axis([-r_width/2 r_width/2 -r_width/2 r_width/2]);
axis square% x y轴显示范围相同
clim = get(gca,'CLim');
set(gca,'CLim',clim(2) + [-20 0]);