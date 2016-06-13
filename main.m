%% close all, clear all
close all
clear all

%% Init and Seed

% Mersenne Twister
rng(0,'twister')
% GPU seed
parallel.gpu.rng(0);

bigN=1e6;
K1 = 100; % strike
K2 = 90; % strike
T = 1.0;  % years
r=.1;  % mu
d=0; %dividends
sigma=(.1)^.5;  % volatility
N=1;  
dt=T/N;

%% Simulate
S0=90*ones(bigN,1,'gpuArray');  % S(0)
X=arrayfun(@simulateStockPrice,S0,r,d,sigma,T,dt);
S=gather(X);

clear X
clear S0

% Compute Call value at t=1
C1=max(0,S-K1);
C2=max(0,S-K2);

%Some statistics
corr1=corr(S,-C1);
corr2=corr(S,-C2);

%% Calculate Variance
%Q values
Q=(1.25+.01):.01:2.25;
Q1=gpuArray(Q);
Q=(-3.25+.01):.01:-2.25;
Q2=gpuArray(Q);

varV=varOfV(Q1,Q2,S,C1,C2);
varV=gather(varV);

[r,c] = find(varV==min(varV(:)));

VS=var(S);
VS=ones(length(Q),length(Q))*VS;

%% Plots

figure

%!@#$ Uncomment to see variance of S alone
%surf(Q,Q,VS,'EdgeColor','none','FaceColor','red')
%hold on

surf(Q,Q,varV,'EdgeColor','none')
hold on
plot3(Q2(c),Q1(r),varV(r,c),'r*')
axis([-3.35 2.4 -3.35 2.4 -500 20000])
colorbar
xlabel('Q3')
ylabel('Q2')
zlabel('Variance')
title('Variance Surface at t=1, K1=100, K2=90')