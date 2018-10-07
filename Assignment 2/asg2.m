close all
clear 
clc

A = dlmread('log-data-A.txt'); %Read table A
B = dlmread('log-data-B.txt'); %Read table B
C = dlmread('log-data-C.txt'); %Read table C


N = length(A(:,1)); %Total number of data points

%initial guesses
% a_init = 3;
% b_init = 25;
% c_init = 0.4;
a_init = 50;
b_init = 70;
c_init = 100;

a1 = find_a(A,a_init,'Data-A')
a2 = find_a(B,b_init,'Data-B')
a3 = find_a(C,c_init,'Data-C')

y1 = log( a1 .* A(:,1) );
y2 = log( a2 .* B(:,1) );
y3 = log( a3 .* C(:,1) );

%Plots

%Raw data plot
% figure(1)
% subplot(3,1,1)
% plot(A(:,1),A(:,2),'x','markersize',5,'linewidth',3);
% xlabel('x_i');
% ylabel('y_i');
% title("log-data-A");
% set(gca,'FontSize',12);
% 
% subplot(3,1,2)
% plot(B(:,1),B(:,2),'x','markersize',5,'linewidth',3);
% xlabel('x_i');
% ylabel('y_i');
% title("log-data-B");
% set(gca,'FontSize',12);
% 
% subplot(3,1,3)
% plot(C(:,1),C(:,2),'x','markersize',5,'linewidth',3);
% xlabel('x_i');
% ylabel('y_i');
% title("log-data-C");
% set(gca,'FontSize',12);

%Plot A
figure(2)

subplot(3,1,1)
plot(A(:,1),A(:,2),'*','markersize',5);
hold on;
plot( A(:,1),y1, 'LineWidth',2 ); 
hold off;
title("Data-set A");
xlabel('x_i');
ylabel('y_i');
legend('Raw data points','Non-linear fit');
set(gca,'FontSize',13)

%Plot B
subplot(3,1,2)
plot(B(:,1),B(:,2),'*','markersize',5);
hold on;
plot( B(:,1),y2,'LineWidth',2 );
hold off;
title("Data-set B");
xlabel('x_i');
ylabel('y_i');
legend('Raw data points','Non-linear fit');
set(gca,'FontSize',13)

%Plot C

subplot(3,1,3)
plot(C(:,1),C(:,2),'*','markersize',5);
hold on;
plot( C(:,1),y3,'LineWidth',2 );
hold off;
title("Data-set C");
xlabel('x_i');
ylabel('y_i');
legend('Raw data points','Non-linear fit');
set(gca,'FontSize',13)
