%Project στο μάθημα "Σήματα & Συστήματα" 4/6/2019
% Νίκος Πλέσσας // ΑΕΜ: 615 

clc; clf; clear;

%%MEROS A
%%


%1 me arxeio hxografhmeno ektos matlab kai deigmatolhpthmeno sta 8khz
[nikos,fs] = audioread('nikos.wav');
figure(1);
plot(nikos);
title('Kymatomorfh toy .wav');

%2 metatroph se double kai fasmatogramma
nikos_double = double(nikos);
s = spectrogram(nikos_double(:,1),512,480,4096,8000, 'yaxis');
figure(2);
plot(s);
title('Fasmatogramma toy .wav');

%3 sxediash sto idio para8yro twn 2 metrwn (kanoniko kai logarithmiko me ton
%aksona x sto [0,2pi]
figure(3);
subplot(2,1,1); 
plot(abs(fft(nikos_double)));
title('Metro tou shmatos');
xlabel('freq');
ylabel('Magn');
xlim([0 2*pi])
subplot(2,1,2);
plot(20*log(abs(fft(nikos_double))));
title('Logarithmiko metro tou shmatos');
xlabel('freq');
ylabel('Magn');
xlim([0 2*pi])

%4 anaparagwgh toy arxeioy. Me thn entolh audioplayer + play den epaize (den
%akoygotan hxos) opote dokimasa me thn entolh sound() h opoia doylevei mono
%gia double.
sound(nikos_double,fs);

nikos_int = int16(nikos);
nikos_int1=audioplayer(nikos_int,fs);
play(nikos_int1) 

%%MEROS B
%% 

% 1.
%y[n] = x[n] + a*x[n-n0]
% H(z) = 1 + 1/2*z^-10 ||| a=0,5 n0 = 10

n0=10;
a=1/2;
a1=[1,0,0,0,0,0,0,0,0,0];  %%paronomasths
b1=[1,0,0,0,0,0,0,0,0,a]; %%ari8mhths

%sxediasi tis vimatikis apokrisis gia n = 0:1:20
figure(4);
step = stepz(b1,a1,[0:20]);
plot(step);
title('Vimatiki');
xlabel('n');
ylabel('s[n]');

%sxediasi tis kroustikis apokrisis gia n = 0:1:20
figure(5);
imp = impz(b1,a1,[0:20]);
plot(imp);
title('Kroustiki');
xlabel('n');
ylabel('h[n]');

% 2.
%mhdenika & poloi || a paronomasths (y) , b ari8mhths (x)

figure(6);
a = 0.1;
a1=[1,0,0,0,0,0,0,0,0,0];  %%paronomasths
b1=[1,0,0,0,0,0,0,0,0,a]; %%ari8mhths
zplane(b1,a1);
title('Diagramma polwn/mhdenikwn gia a=.1');

figure(7);
a = 0.01;
a1=[1,0,0,0,0,0,0,0,0,0];  %%paronomasths
b1=[1,0,0,0,0,0,0,0,0,a]; %%ari8mhths
zplane(b1,a1);
title('Diagramma polwn/mhdenikwn gia a=.01');

figure(8);
a = 0.001;
a1=[1,0,0,0,0,0,0,0,0,0];  %%paronomasths
b1=[1,0,0,0,0,0,0,0,0,a]; %%ari8mhths
zplane(b1,a1);
title('Diagramma polwn/mhdenikwn gia a=.001');

rizes_paron=roots(a1);
rizes_ari8m=roots(b1);

figure(9);
plot(rizes_paron,'rx');
title('Rizes paronomasti me thn roots gia a=.001');

figure(10);
plot(rizes_ari8m,'ko');
title('Rizes ari8miti me thn roots gia a=.001');

%% meros G
%%

% a paronomasths (y) , b ari8mhths (x)

% 1. y[n] = x[n] + 0.5*x[n-2000] a = 0.5, n0 = 2000

a1(1)=1;
b1=zeros;
b1(1)=1;
b1(2000)=0.5;

% 2. 
nikos_filtered = filter(b1,a1,nikos);
sound(nikos_filtered); %%exei echo!

% 3. fasmatogramma
spec = spectrogram(nikos_filtered(:,1),512,480,4096,8000, 'yaxis');
figure(11);
plot(spec);
title('Fasmatogramma toy filtrarismenoy me echo shma');

% 4. autocorrelation
figure(12);
plot(xcorr(nikos_filtered));
title('Kymatomorfh me autocorrelation toy filtratismenoy shmatos');

figure(13);
plot(xcorr(nikos));
title('Kymatomorfh me autocorrelation toy prwtotypoy shmatos');

%% Meros D. 
%%

% y(n) = x(n) + 0.5*x(n-2000) yinv = ?
% x -> h -> y || y -> Hinv -> x H(z)*Hinv(z) = 1 => Hinv(z) = 1 / H(z)
% H(z)= 1 + 0.5*z^-2000 => Hinv(z) = 1 / 1 + 0.5*z^-2000 => antistrofo
% systhma: y(n) - 0.5*y(n-2000) = x(n)

% a paronomasths (y) , b ari8mhths (x)

% 1. Sxediash ths kroystikhs apokrisis toy antistrofoy
b1=zeros;
b1(1)=1;
a1=zeros;
a1(1)=1;
a1(2000)=0.5;

[imp,t] = impz(b1,a1,[1:20000]);
figure(14);
plot(imp);
title('Kroustiki antistrofou systhmatos ');
xlabel('n');
ylabel('h[n]');

% 2. Syneliksi twn prwtwn 3000 deigmatwn ths kroystiks me to hxhtiko gia
% echo cancellation, plot + anaparagwgh
imp1 = imp(1:3000);
for i=1:1:3000
    cancelation1 = conv(imp1,nikos_filtered(:,1));
end
sound(cancelation1);
figure(15);
plot(cancelation1);
title('Prospa8eia echo cancelation me 3000 times ths h[n]');

% 3. Syneliksi twn prwtwn 15000 deigmatwn ths kroystiks me to hxhtiko gia
% echo cancellation, plot + anaparagwgh

imp2 = imp(1:15000);
for i=1:1:15000
    cancelation2 = conv(imp2,nikos_filtered(:,1));
end
sound(cancelation2);

figure(16);
plot(cancelation2);
title('Prospa8eia echo cancelation me 15000 times ths h[n]');

