%����ʵ�黷���趨 
%��ʵ���趨��10��������1����λ�ĸ߼��ڵ㣬��+ ��ʾ;
%��90��������0.5����λ����ͨ�ڵ㣬��o��ʾ��
%�������м�(50,50)�����괦����һ����վ����x��ʾ.
% (CH:Cluster Head,����ͷ)
clear;%����ȴ����

%-- �ڵ㡢��ͷ��������� --%
n=100;%�ڵ�����
m=0.1;% ���Ƹ߼��ڵ��ռ��
p=0.1;%��ͷ����

%-- ������������� --%
xm=100;%x�᷶Χ
ym=100;%y�᷶Χ
sink.x=0.5*xm; %��վx��
sink.y=0.5*ym; %��վy��
S=repmat(struct('xd',0,'yd',0,'G',0','type','N','E',0,'ENERGY',0,'min_dis',0,'min_dis_cluster',0),n+1,1);% ��¼���нڵ�����꣬�����������

%-- ������������� --%
Bit=4000;% ÿһ�δ����bit��
Eo=0.02;%��ʼ����
ETX=50*0.000000001;%����������ÿbit
ERX=50*0.000000001;%����������ÿbit
Efs=10*0.000000001;%��ɢ������ÿbit
EDA=5*0.000000001;%�ں��ܺģ�ÿbit
Emp=5*0.000000001;% �㲥����
a=1;% ��ʼ�������ӵ�����ռ��
do=30;% �ж��Ƿ�㲥���ܺ�

%-- ������������� --%
times=10;% ʵ�����
r=500;% ���������ڴ�ͷѡ�ٳ�ʼ�׶Σ�ÿ���ڵ����һ��0-1��������֣����������С����ֵ���ڵ��Ϊ��ǰ�ֵĴ�ͷ����

%-- ��¼�ڵ������ --%
dead=0;% �����ڵ���� 
dead_a=0;% ����������ڵ�
dead_n=0;% ��������ͨ�ڵ�
cluster=0;% ��¼��ǰ�Ĵ�ͷ�ڵ�ĸ���
countCHs=0;% ��¼��ͷ�ڵ�ĸ���������cluster���ü���һ����ֻ���𵽼�¼���ã���δ��clusterһ���������㣩
PACKETS_TO_BS=zeros(1,r);% ��¼ÿһ�ֵĴ�ͷ����
PACKETS_TO_CH=zeros(1,r);% ��¼ÿһ�ֵ���ͨ�ڵ����
C=repmat(struct('xd',0,'yd',0,'distance',0,'id',0),n*p,1);% ��¼��ǰ�ִ�ͷ���������
PACKETS_FIRST_DEAD_X=zeros(1,times);% ��¼ÿ��ʵ���һ�������ڵ�ʱ�ĺ�����
PACKETS_FIRST_DEAD_Y=zeros(1,times);% ��¼ÿ��ʵ���һ�������ڵ�ʱ������

PACKETS_DEAD_X=zeros(1,r);% �ñ���Ϊ����¼ÿ�������ڵ�����������ֵ���ı仯���ĺ�����
PACKETS_DEAD_Y=zeros(1,r);% �ñ���Ϊ����¼ÿ�������ڵ�����������ֵ���ı仯����������ֵ
for i=1:1:r
    PACKETS_DEAD_X(i)=i;
end

for tests=1:1:times
    figure(1);
    % ��ʼ���ڵ㣬ѭ��n�Σ�����n���ڵ�
    XR=zeros(1,n);% ��ʱ��������¼X����
    YR=zeros(1,n);% ��ʱ��������¼Y����
    for i=1:1:n
        % �½�һ������ĵ�
        S(i).xd=rand(1,1)*xm;
        XR(i)=S(i).xd;
        S(i).yd=rand(1,1)*ym;
        YR(i)=S(i).yd;
        S(i).G=0;  %ÿһ�����ڽ����˱���Ϊ0
        S(i).type='N';
        temp_rnd0=i;
        if(temp_rnd0<=m*n+1) %ǰ���n*m����+�ڵ�
            S(i).E=Eo*(1+a);  %�����ǳ�ʼ������2����a=1 
            S(i).ENERGY=1;
            plot(S(i).xd,S(i).yd,'+');
            hold on;
        end
        if(temp_rnd0>=m*n+1)  %�����n-n*m����0�ڵ�
            S(i).E=Eo;% S(i).E �Ǹýڵ㵱ǰ������ֵ
            S(i).ENERGY=0;
            plot(S(i).xd,S(i).yd,'o');% plot�������ڽ����ϻ���
            hold on;
        end

    end
    S(n+1).xd=sink.x;   %���һ���ڵ㻭����ʾ��վ�ڵ�
    S(n+1).yd=sink.y;
    plot(S(n+1).xd,S(n+1).yd,'x');
    hold on;

    % ��ʼ����
    isFirst = 1;
    for temp_r=1:1:r % ��ʼ�µ�һ��
        hold off;% ʹ����ӵ��������еĻ�ͼ������л�ͼ���������е����������ԡ�
        figure(1);% �����淴����ʾ�ڱ��Ϊ1�Ĵ�����
        % �µ�һ�֣���ǰ��ͷ�ڵ����ˢ��
        cluster = 0;
        countCHs = 0;
        % �µ�һ�֣����¼�¼�ڵ�������
        dead_a = 0;
        dead_n = 0;
        dead = 0;

        % ����
        for i=1:1:n
            if(i<=n*m) % ǰ���n*m����+�ڵ�
                plot(S(i).xd,S(i).yd,'+');
            end
            if(i>n*m) % �����n-n*m����0�ڵ�
                plot(S(i).xd,S(i).yd,'o');
            end
            hold on;
        end

        %�ж������ڵ㡣���ڵ�����Ϊ0ʱ���ýڵ�Ϊ�����ڵ㡣
        for i=1:1:n
            if(S(i).E<=0) 
                plot(S(i).xd,S(i).yd,'red.');
                hold on;
                dead=dead+1;
                if(dead == 1 && isFirst == 1)
                    isFirst = 0;
                    fprintf("times=%d\tr=%d\n",tests,temp_r);
                    %pause;
                    PACKETS_FIRST_DEAD_X(tests)=tests;
                    PACKETS_FIRST_DEAD_Y(tests)=temp_r;
                end
                if(S(i).ENERGY==1) % ����������ڵ�
                    dead_a=dead_a+1; 
                end
                if(S(i).ENERGY==0) % ��������ͨ�ڵ�
                    dead_n=dead_n+1;
                end
                hold on;
            end
        end
        PACKETS_DEAD_Y(temp_r)=dead;
        plot(S(n+1).xd,S(n+1).yd,'x');
        hold on;

        %ѡ�ٴ�ͷ�ڵ㡣�� LEACH�㷨�Ĺ�ʽѡ�ٴ�ͷ�ڵ㡣 
        X=zeros(1,n*p);% ��ʱ��������¼X����
        Y=zeros(1,n*p);% ��ʱ��������¼Y����
        for i=1:1:n
            if(S(i).E>0) 
                temp_rand=rand; % ��temp_rand�����һ��ֵ��rand ����һ��(0-1)֮���һ���������
                if((S(i).G)<=0)% �ýڵ��ڱ�����û�е�����ͷ�ڵ�Ķ��ر�֤
                    if(temp_rand<=(p/(1-p*mod ((temp_r-1),round(1/p))))) 
                        countCHs=countCHs+1;
                        % packets_T0_BS=packets_T0_BS+1; 
                        % PACKETS_TO_BS(temp_r+1)=packets_T0_BS; 
                        S(i).type='C';
                        S(i).G=round(1/p)-1; % (round��������Ϊ���������)
                        cluster=cluster+1;%��ͷ����1
                        C(cluster).xd=S(i).xd;
                        C(cluster).yd=S(i).yd;
                        plot(S(i).xd,S(i).yd,'k*');
                        hold on;
                        distance=sqrt((S(i).xd-(S(n+1).xd))^2+(S(i).yd-(S(n+1).yd))^2); 		
                        C(cluster).distance=distance;
                        C(cluster).id=i;
                        X(cluster)=S(i).xd;
                        Y(cluster)=S(i).yd; 

                        distance;
                        if(distance>do)  
                            % ����������ֵ����������Ϊ����������(��������͸���۽ڵ�)+�����ں�����+���۽ڵ�ͨ������
                            %S(i).E=S(i).E-((ETX+EDA)*(Bit)+Emp*Bit*(distance*distance*distance*distance));
                            S(i).E=S(i).E-((ETX+EDA)*(Bit)+Emp*Bit);
                        end
                        if (distance<=do)
                            % ����С�ڵ�����ֵ����������Ϊ����������(��������͸���۽ڵ�)+�����ں�����+��ɢ����
                            %S(i).E=S(i).E-((ETX+EDA)*(Bit)+Efs*Bit*(distance*distance));
                            S(i).E=S(i).E-((ETX+EDA)*(Bit)+Efs*Bit);
                        end
                    end
                end
            end
        end
        PACKETS_TO_BS(temp_r)=countCHs;% ���ֲ����Ĵ�ͷ�ڵ���

        %��ͨ�ڵ�������
        for i=1:1:n
            %���i�ڵ�����ͨ�ڵ㣬����i�ڵ�������������ж��Ƿ񽫸ýڵ�����ͷ
            if(S(i).type=='N'&& S(i).E>0)
                if(cluster>=1)
                    min_dis=sqrt((S(i).xd-C(1).xd)^2+(S(i).yd-C(1).yd)^2);% ����õ�����һ����ͷ�ľ��루Ĭ�ϼ�¼��һ����ͷ��Ϊ��ʼ�㣩
                    min_dis_cluster=1;% ��¼��һ����ͷ�ı�ţ���Ĭ�ϼ�¼��һ����ͷ��Ϊ��ʼ�㣩
                    for c=1:1:cluster
                        temp=min(min_dis,sqrt((S(i).xd-C(c).xd)^2+(S(i).yd-C(c).yd)^2)); % ����c�ڵ����i�ڵ�ľ���
                        if(temp<min_dis) % ���i��c��i�����ĵ����̣���ѡ�����ݴ��͵�c�ڵ�
                            min_dis=temp;
                            min_dis_cluster=c;
                        end
                    end

                    if(min_dis>do) % �������ĵ��ʣ���������Խ��й㲥���������
                        % ���ĵ�����Ϊ����������(�����ݷ��͸���ͷ)
                        S(i).E=S(i).E-(ETX*Bit);
                    end
                    if(min_dis<=do) % �������ĵ��ʣ�����������Խ��й㲥�������
                        % ���ĵ�����Ϊ����ɢ����
                        S(i).E=S(i).E-(Efs*Bit);
                    end
                    %�����ͷ�ڵ����������
                    if(min_dis>0) % �����ͷ�ڵ㻹δ�����ľ�������������Ϊ����������+�ں�������
                        S(C(min_dis_cluster).id).E=S(C(min_dis_cluster).id).E-((ERX+EDA)*Bit);
                    end
                    S(i).min_dis=min_dis;% ��¼���������ӵĴ�ͷ�ľ���
                    S(i).min_dis_cluster=min_dis_cluster;% ��¼�����ӵĴ�ͷ�ı��
                end
            end
        end
        PACKETS_TO_CH(temp_r)=n-dead-cluster;% ��¼��ǰ���Ǵ�ͷ�ڵ����
        fprintf("%d %d\n",temp_r, countCHs);

        % �����еĽڵ㶼����һ�δ�ͷ�󣬽����нڵ㶼����Ϊδ�����ι���ͷ�ڵ㣬�Ա㿪ʼ�µĴ�ͷѡ��
        if(mod (temp_r,round(n*p)) == 0)
            for i=1:1:n
                S(i).G=0;  %ÿһ�����ڽ����˱���Ϊ0
                S(i).type='N';
            end
        end
    end
    
    figure(3);
    plot(PACKETS_DEAD_X,PACKETS_DEAD_Y);
    xlabel('����');
    ylabel('�����ڵ����');
    title('�ڵ���������ͼ');
    hold on;
end

figure(2);
plot(PACKETS_FIRST_DEAD_X,PACKETS_FIRST_DEAD_Y);% ������ͼ
xlabel('���Դ���');
ylabel('��������');
title('��һ�γ��������ڵ�ʱ����������');
