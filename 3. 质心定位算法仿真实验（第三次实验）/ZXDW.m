% function [Accuracy] = dingwei(BeaconAmount)

% Beacon 为信标节点坐标
% UN 为未知节点坐标

clear;

BorderLength = 100; % 正方形区域的边长 
UNAmount = 60; % 未知节点个数 
BeaconAmount = 40; % 信标节点个数 
NodeAmount = UNAmount + BeaconAmount; % 网络节点个数 
R = 50; % 节点的通信距离 
%D = zeros(NodeAmount,NodeAmount); % 未知节电到信标节点距离初始矩阵；BeaconAmount行NodeAmount列 
%X = zeros(2,UNAmount); % 节点估计坐标初始矩 

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 在正方形区域内产生均匀分布的随机拓扑
% RandStream.setGlobalStream设置全局随机数流
%RandStream.setDefaultStream(RandStream('mt19937ar','Seed',sum(100*clock)))  %2010版本
RandStream.setGlobalStream(RandStream('mt19937ar','Seed',sum(100*clock))) % 2016版本
C = BorderLength.*rand(2,NodeAmount); % `.*`按元素乘法。用于矩阵间对应元素的相乘，或数与数之间，数与矩阵之间的相乘。
                                    % X = rand(sz1,sz2) 返回由随机数组成的 sz1×sz2 数组。

D = C.' % 将C矩阵进行转置,储存所有节点的坐标

%pause

%figure(1);
%hold off;
%plot(D(:,1),D(:,2),'ko')

%pause

% 带逻辑号的节点坐标 
Sxy = [[1:NodeAmount];C]; % 分号表示分行显示数组，冒号表示创建向量
Sxy.'

%pause

Beacon = [Sxy(2,1:BeaconAmount);Sxy(3,1:BeaconAmount)]; % 信标节点坐标 
B = Beacon.'
figure(1);
hold off;
plot(B(:,1),B(:,2),'ro')
hold on;

%pause

UN = [Sxy(2,(BeaconAmount + 1):NodeAmount);Sxy(3,(BeaconAmount + 1):NodeAmount)];%未知节点坐标  
U = UN.'
plot(U(:,1),U(:,2),'ko')

%pause

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 质心算法
sumE = 0; % 节点误差值总和
for i = 1:1:UNAmount   
   m = 0;  % 未知节点(质心)周围的节点个数
   sumX = 0; % x坐标的累积值
   sumY = 0; % y坐标的累积值 
   for j = 1:1:BeaconAmount  % BeaconAmount为信标节点个数 
      % i为未知节点，j为信标节点。
      if sqrt(abs(UN(1,i)-Beacon(1,j))^2 + abs(UN(2,i)-Beacon(2,j))^2) <= R % 节点之间的通信距离要小于R
         m = m + 1; 
         sumX = sumX + Beacon(1,j); 
         sumY = sumY + Beacon(2,j); 
      end 
   end 
   if m == 0 % 如果一个未知节点周围没有信标节点，将该节点标记为(0,0)
      X(1,i) = 0; 
      X(2,i) = 0; 
   else
      T.xd(i) = sumX./m; 
      X(1,i) =  T.xd(i); % x的坐标平均值 
      T.yd(i) = sumY./m; 
      X(2,i) = T.yd(i);  % y的坐标平均值  
   end
   
   error(1,i) = sqrt(abs(UN(1,i)-X(1,i))^2 + abs(UN(2,i)-X(2,i))^2); % 记录了节点的误差值
   sumE = sumE + error(1,i); 
end

figure(2);
hold off;
plot(error,'-o') % 将节点的误差值在折线图中显示出来

%pause

Accuracy = sumE/(UNAmount*R) % 每个节点平均的误差值
