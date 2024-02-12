clear all
close all
clc

N = 10; % prediction horizon
radius = 0.2;
T = 0.1; %[s]
sim_tim = 10; % Maximum simulation time
theta1 = pi; theta2 = 0;
x1 = [1.2 ; 0 ; theta1; cos(theta1);  sin(theta1)];    % initial condition.
x2 = [-1.2 ; 0 ; theta2; cos(theta2); sin(theta2)];    % initial condition.
agent1 = agent_back(radius,N,T, [x1; x2]);
agent2 = agent_up(radius,N,T, [x2; x1]);

target1 = [-1.2 ; 0; theta1; cos(theta1);  sin(theta1)];
target2 = [1.2 ; 0; theta2; cos(theta2); sin(theta2)];   
x1_his = [x1];
x2_his = [x2];
i = 0;
tic
while i < 60
     agent1 = agent1.search(agent2.x1(1:5), [target1; target2]);
     agent2 = agent2.search(agent1.x1(1:5), [target2; target1]);
     x1_his = [x1_his agent1.x1(1:5)];
     x2_his = [x2_his agent2.x1(1:5)];
     i = i+1
end
toc
Draw_Multi (x1_his,x1_his,agent1.xx,x2_his,x2_his,agent2.xx, radius);
