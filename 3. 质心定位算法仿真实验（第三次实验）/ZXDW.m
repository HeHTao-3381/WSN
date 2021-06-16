
% function [Accuracy]=dingwei(BeaconAmount) 
BorderLength=100;%����������ı߳� 
UNAmount=60; %δ֪�ڵ����
BeaconAmount=20; %�ű�ڵ����
NodeAmount=UNAmount+BeaconAmount;%����ڵ���� 
R=50;%�ڵ��ͨ�ž��� 
%D=zeros(NodeAmount,NodeAmount);%δ֪�ڵ絽�ű�ڵ�����ʼ����BeaconAmount��NodeAmount�� 
%X=zeros(2,UNAmount);%�ڵ���������ʼ�� 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~�������������ڲ������ȷֲ����������
RandStream.setDefaultStream(RandStream('mt19937ar','Seed',sum(100*clock)))  %2010�汾
%RandStream.setGlobalStream(RandStream('mt19937ar','Seed',sum(100*clock))) %2016�汾
C=BorderLength.*rand(2,NodeAmount); 
C
pause
D=C.'
pause
%figure(1);
%plot(D(:,1),D(:,2),'ko')
%pause
%���߼��ŵĽڵ����� 
Sxy=[[1:NodeAmount];C]; 
Sxy
pause
Beacon=[Sxy(2,1:BeaconAmount);Sxy(3,1:BeaconAmount)];%�ű�ڵ����� 
B=Beacon.'
figure(1);
plot(B(:,1),B(:,2),'ro')
hold on;
pause
UN=[Sxy(2,(BeaconAmount+1):NodeAmount);Sxy(3,(BeaconAmount+1):NodeAmount)];%δ֪�ڵ�����  
U=UN.'
plot(U(:,1),U(:,2),'ko')
pause
sume=0; 
for i=1:1:UNAmount   
    m=0; 
    sumx=0; %x���ۻ�ֵ
    sumy=0; %y���ۻ�ֵ 
    for j=1:1:BeaconAmount  %nΪ�ű�ڵ���� 
        if sqrt(abs(UN(1,i)-Beacon(1,j))^2+abs(UN(2,i)-Beacon(2,j))^2)<=R %x2��y2Ϊ����ڵ����꣬S.xd��S.ydΪĿ������ 
           m=m+1; 
           sumx=sumx+Beacon(1,j); 
           sumy=sumy+Beacon(2,j); 
        end 
     end 
     if m==0 
          X(1,i)=0; 
          X(2,i)=0; 
     end 
      T.xd(i)=sumx./m; 
      X(1,i)= T.xd(i); %x������ƽ��ֵ 
      T.yd(i)=sumy./m; 
      X(2,i)=T.yd(i);  %y������ƽ��ֵ 
      error(1,i)=sqrt(abs(UN(1,i)-X(1,i))^2+abs(UN(2,i)-X(2,i))^2); 
      sume=sume+error(1,i); 
end   
  figure;
  plot(error,'-o')
  pause
   Accuracy=sume/(UNAmount*R)
