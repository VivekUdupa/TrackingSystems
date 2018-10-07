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
figure(1)
subplot(1,2,1)
plot ( px1, py1, 'x', 'markers',12,'LineWidth',3 ); %Given dataset plot
hold on
plot ( px1 , Y1 , 'r-','LineWidth',3);%2d Line fit plot
hold off;
title('Dataset 1');
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
subplot(1,2,2)
plot ( px2, py2, 'x','markers',12,'LineWidth',3 ); %Given dataset plot
hold on
plot ( px2 , Y2 , 'r-','LineWidth',2); %2d Line fit plot
hold off;
title('Dataset 2');
ylabel('Y values');
xlabel('X values');
legend('Given data points', '2D line fit','Location','northwest');
set(gca,'FontSize',18);

%Part Three ( Power Function)

%Read the dataset from file into a table
Tble = readtable('83people-all-meals.txt');

%Convert the table into an array
A1 = table2array(Tble);

%Extract the 3rd column(i.e Bites taken)
Bites = A1(:,3);

%Calculate Kilocalories per bite
CalBite = A1(:,4) ./ A1(:,3) ;

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
plot(Bites,CalBite, 'x','markersize',10,'linewidth',2);
hold on;
plot(X3,Y3,'r-','LineWidth',4);
hold off;
xlabel("bites");
ylabel("kilo-cal/bite");
title("Bites vs kilo-cal/bite - Power Fit");
legend('Data Points','Power -Fit');
set(gca,'FontSize',18);

%Part 3 - Polynomial

A4 = [Bites ones(length(Bites),1)];
b4 = [CalBite];
x4 = inv(A4' * A4) * A4' * b4;

X4 = 0:max(Bites);
Y4 = x4(1,1) .* Bites + x4(2,1);

% Plotting the graph
figure(4)
plot(Bites,CalBite, 'x','markersize',10,'linewidth',2);
hold on;
plot(Bites,Y4,'r-','LineWidth',4);
hold off;
xlabel("bites");
ylabel("kilo-cal/bite");
title("Bites vs kilo-cal/bite - Linear Line Fit");
legend('Data Points','Line-Fit');
set(gca,'FontSize',18);

