close all
clear

%Dataset one
px1 = [5, 6, 7, 8, 9];
py1 = [1, 1, 2, 3, 5];

%M = 2, N = length(x)

A1 = [px1' , ones(length(px1),1)]; %A Matrix
b1 = py1'; %Leftovers

x1 = inv(A1' * A1) * A1' * b1 %Calculating the unknowns 

Y1 = x1(1) * px1 + x1(2); %Final Y1


%Plotting the graph
figure(2)
ax1 = subplot(1,2,1)
plot ( px1, py1, 'x', 'markers',12,'LineWidth',3 ); %Given dataset plot
hold on
plot ( px1 , Y1 , 'r-','LineWidth',3);%2d Line fit plot
hold off;
title('Part A');
ylabel('Y values');
xlabel('X values');
legend('Given data points', '2D line fit','Location','northwest');
set(gca,'FontSize',18);

%Dataset 2
px2 = [5, 6, 7, 8, 8, 9];
py2 = [1, 1, 2, 3, 14, 5];

A2 = [px2' , ones(length(px2),1)];
b2 = py2';

x2 = inv(A2' * A2) * A2' * b2

Y2 = x2(1) * px2 + x2(2);

%Plotting the Graph
ax2 = subplot(1,2,2)
plot ( px2, py2, 'x','markers',12,'LineWidth',3 ); %Given dataset plot
hold on
plot ( px2 , Y2 , 'r-','LineWidth',3); %2d Line fit plot
hold off;
title('Part B');
ylabel('Y values');
xlabel('X values');
legend('Given data points', '2D line fit','Location','northwest');
set(gca,'FontSize',18);
axis([ax1,ax2], [4 10 0 16])
%Plotting Raw Data Points
figure(99)
plot(px1, py1, 'X','markers',22,'LineWidth',5)
ylabel('Y values');
xlabel('X values');
%title('Part A Dataset');
legend('Data points','location','NorthWest');
set(gca,'FontSize',20,'YTick',[0:1:15]);
axis([4 10 0 6])

figure(100)
plot(px2, py2, 'X','markers',22,'LineWidth',5)
ylabel('Y values');
xlabel('X values');
%title('Part B Dataset');
set(gca,'FontSize',20,'YTick',[0:2:15]);
legend('Data points','location','NorthWest');
axis([4 10 0 15])


%Part Three ( Power Function)

%Read the dataset from file into a table
Tble = readtable('83people-all-meals.txt');

%Convert the table into an array
A1 = table2array(Tble);

%Extract the 3rd column(i.e Bites taken)
Bites = A1(:,3);

%Calculate Kilocalories per bite
CalBite = A1(:,4) ./ A1(:,3) ;

%extract every 7th data
Bites_reduced = zeros(length(A1(:,1)),1);
CalBite_reduced = zeros(length(A1(:,1)),1);
j = 1;
for i = 1:10:(length(Bites))
    Bites_reduced(j,1) = Bites(i,1);
    CalBite_reduced(j,1) = CalBite(i,1);
    j = j+ 1;
end

%PArt 3 Raw data plot
figure(1)
plot(Bites_reduced,CalBite_reduced,'ko','markers',5);
xlabel("Number of bites");
ylabel("Kilo-calories per bite")
legend("Data Points");
set(gca,'FontSize',20);
axis([0 150 0 100])

%setting up the Matrices

% y3 = ax^b;
% V = K + bu3
% V = log(y3)
% K = log(a)
% u3 = log(x)

u3 = log(Bites);
v = log(CalBite);

A3 = [u3 ones(length(Bites),1)];
b3 = [v];

x3 = inv(A3' * A3) * A3' * b3;

a3 = exp(x3(2,1));
b3 = x3(1,1);

X3 = 0:max(Bites);
Y3 = a3 * X3.^b3;

% Plotting the graph
figure(3)
plot(Bites_reduced,CalBite_reduced, 'ko','markersize',5,'linewidth',1);
hold on;
plot(X3,Y3,'k-','LineWidth',4);
hold off;
xlabel("Number of bites");
ylabel("Kilo-calories per bite");
legend('Data Points','Power -Fit');
set(gca,'FontSize',18);
axis([0 150 0 100])

%Part 3 - Polynomial

A4 = [Bites ones(length(Bites),1)];
b4 = [CalBite];
x4 = inv(A4' * A4) * A4' * b4;

X4 = 0:max(Bites);
Y4 = x4(1,1) .* Bites + x4(2,1);

% Plotting the graph
figure(4)
plot(Bites_reduced,CalBite_reduced, 'ko','markersize',5,'linewidth',1);
hold on;
plot(Bites,Y4,'k-','LineWidth',4);
hold off;
xlabel("bites");
xlabel("Number of bites");
ylabel("Kilo-calories per bite");
legend('Data Points','Line-Fit');
set(gca,'FontSize',18);
axis([0 150 0 100])
