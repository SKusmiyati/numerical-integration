clc; clear; close all;

% Fungsi
function y = y(t)
y = sin(2*pi*t) - cos(3*pi*t);
end

% Integral analitik
function Y = Y(t)
Y = -(sin(3*pi*t))/(3*pi) - (cos(2*pi*t))/(2*pi);
end

% Batas integrasi
a = 0; 
b = 5;       
N = 300;     % jumlah segmen (disarankan genap dan kelipatan 3)
if mod(N,6)~=0, N = N + (6 - mod(N,6)); end  % biar bisa utk 1/3 & 3/8 sekaligus

h = (b-a)/N;
t = linspace(a,b,N+1);
f = y(t);

% -------------------------
% 1. Analitik (running integral)
% -------------------------
Y_analytic = Y(t) - Y(a);

% -------------------------
% 2. Trapesium (sesuai rumus segmen berganda)
% -------------------------
trap_cum = zeros(1,N+1);
for k = 1:N
    trap_cum(k+1) = (h/2) * ( f(1) + 2*sum(f(2:k)) + f(k+1) );
end

% -------------------------
% 3. Simpson 1/3 (segmen genap)
% -------------------------
simp13_cum = zeros(1,N+1);
for k = 2:2:N
    simp13_cum(k+1) = (h/3)*( f(1) + 4*sum(f(2:2:k)) + 2*sum(f(3:2:k-1)) + f(k+1) );
    simp13_cum(k)   = (simp13_cum(k-1)+simp13_cum(k+1))/2; % interpolasi
end

% -------------------------
% 4. Simpson 3/8 (segmen kelipatan 3)
% -------------------------
simp38_cum = zeros(1,N+1);
for k = 3:3:N
    simp38_cum(k+1) = (3*h/8)*( f(1) + 3*sum(f(2:k)) - 2*sum(f(3:3:k)) + f(k+1) );
    % catatan: untuk kumulatif, pendekatan dengan rumus langsung sampai x_k
end

% -------------------------
% Plot gabungan
% -------------------------
figure;
plot(t,Y_analytic,'k-','LineWidth',2); hold on;
plot(t,trap_cum,'r--','LineWidth',1.5);
plot(t,simp13_cum,'b-.','LineWidth',1.5);
plot(t,simp38_cum,'m:','LineWidth',1.5);

xlabel('t'); ylabel('Integral dari y(t)');
title('Perbandingan Integral Numerik dan Analitik');
legend('Analitik','Trapesium','Simpson 1/3','Simpson 3/8','Location','best');
grid on;