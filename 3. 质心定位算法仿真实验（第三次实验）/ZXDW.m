% function [Accuracy] = dingwei(BeaconAmount)

% Beacon Ϊ�ű�ڵ�����
% UN Ϊδ֪�ڵ�����

clear;

BorderLength = 100; % ����������ı߳� 
UNAmount = 60; % δ֪�ڵ���� 
BeaconAmount = 40; % �ű�ڵ���� 
NodeAmount = UNAmount + BeaconAmount; % ����ڵ���� 
R = 50; % �ڵ��ͨ�ž��� 
%D = zeros(NodeAmount,NodeAmount); % δ֪�ڵ絽�ű�ڵ�����ʼ����BeaconAmount��NodeAmount�� 
%X = zeros(2,UNAmount); % �ڵ���������ʼ�� 

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% �������������ڲ������ȷֲ����������
% RandStream.setGlobalStream����ȫ���������
%RandStream.setDefaultStream(RandStream('mt19937ar','Seed',sum(100*clock)))  %2010�汾
RandStream.setGlobalStream(RandStream('mt19937ar','Seed',sum(100*clock))) % 2016�汾
C = BorderLength.*rand(2,NodeAmount); % `.*`��Ԫ�س˷������ھ�����ӦԪ�ص���ˣ���������֮�䣬�������֮�����ˡ�
                                    % X = rand(sz1,sz2) �������������ɵ� sz1��sz2 ���顣

D = C.' % ��C�������ת��,�������нڵ������

%pause

%figure(1);
%hold off;
%plot(D(:,1),D(:,2),'ko')

%pause

% ���߼��ŵĽڵ����� 
Sxy = [[1:NodeAmount];C]; % �ֺű�ʾ������ʾ���飬ð�ű�ʾ��������
Sxy.'

%pause

Beacon = [Sxy(2,1:BeaconAmount);Sxy(3,1:BeaconAmount)]; % �ű�ڵ����� 
B = Beacon.'
figure(1);
hold off;
plot(B(:,1),B(:,2),'ro')
hold on;

%pause

UN = [Sxy(2,(BeaconAmount + 1):NodeAmount);Sxy(3,(BeaconAmount + 1):NodeAmount)];%δ֪�ڵ�����  
U = UN.'
plot(U(:,1),U(:,2),'ko')

%pause

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% �����㷨
sumE = 0; % �ڵ����ֵ�ܺ�
for i = 1:1:UNAmount   
   m = 0;  % δ֪�ڵ�(����)��Χ�Ľڵ����
   sumX = 0; % x������ۻ�ֵ
   sumY = 0; % y������ۻ�ֵ 
   for j = 1:1:BeaconAmount  % BeaconAmountΪ�ű�ڵ���� 
      % iΪδ֪�ڵ㣬jΪ�ű�ڵ㡣
      if sqrt(abs(UN(1,i)-Beacon(1,j))^2 + abs(UN(2,i)-Beacon(2,j))^2) <= R % �ڵ�֮���ͨ�ž���ҪС��R
         m = m + 1; 
         sumX = sumX + Beacon(1,j); 
         sumY = sumY + Beacon(2,j); 
      end 
   end 
   if m == 0 % ���һ��δ֪�ڵ���Χû���ű�ڵ㣬���ýڵ���Ϊ(0,0)
      X(1,i) = 0; 
      X(2,i) = 0; 
   else
      T.xd(i) = sumX./m; 
      X(1,i) =  T.xd(i); % x������ƽ��ֵ 
      T.yd(i) = sumY./m; 
      X(2,i) = T.yd(i);  % y������ƽ��ֵ  
   end
   
   error(1,i) = sqrt(abs(UN(1,i)-X(1,i))^2 + abs(UN(2,i)-X(2,i))^2); % ��¼�˽ڵ�����ֵ
   sumE = sumE + error(1,i); 
end

figure(2);
hold off;
plot(error,'-o') % ���ڵ�����ֵ������ͼ����ʾ����

%pause

Accuracy = sumE/(UNAmount*R) % ÿ���ڵ�ƽ�������ֵ
