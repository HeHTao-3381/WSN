%仿真实验环境设定 
%本实验设定有10个能量是1个单位的高级节点，用+ 表示;
%有90个能量是0.5个单位的普通节点，用o表示。
%在区域中间(50,50)的坐标处，有一个基站，用x表示.
% (CH:Cluster Head,即簇头)
clear;%清除內存变量

%-- 节点、簇头设置相关量 --%
n=100;%节点总数
m=0.1;% 控制高级节点的占比
p=0.1;%簇头概率

%-- 控制坐标相关量 --%
xm=100;%x轴范围
ym=100;%y轴范围
sink.x=0.5*xm; %基站x轴
sink.y=0.5*ym; %基站y轴
S=repmat(struct('xd',0,'yd',0,'G',0','type','N','E',0,'ENERGY',0,'min_dis',0,'min_dis_cluster',0),n+1,1);% 记录所有节点的坐标，及其相关属性

%-- 计算能量相关量 --%
Bit=4000;% 每一次传输的bit量
Eo=0.02;%初始能量
ETX=50*0.000000001;%传输能量，每bit
ERX=50*0.000000001;%接收能量，每bit
Efs=10*0.000000001;%耗散能量，每bit
EDA=5*0.000000001;%融合能耗，每bit
Emp=5*0.000000001;% 广播能量
a=1;% 初始额外增加的能量占比
do=30;% 判断是否广播的能耗

%-- 控制轮数相关量 --%
times=10;% 实验次数
r=500;% 总轮数（在簇头选举初始阶段，每个节点产生一个0-1的随机数字，如果该数字小于阈值，节点成为当前轮的簇头。）

%-- 记录节点相关量 --%
dead=0;% 死亡节点个数 
dead_a=0;% 死亡的特殊节点
dead_n=0;% 死亡的普通节点
cluster=0;% 记录当前的簇头节点的个数
countCHs=0;% 记录簇头节点的个数。（跟cluster作用几乎一样，只是起到记录作用，并未像cluster一样进行运算）
PACKETS_TO_BS=zeros(1,r);% 记录每一轮的簇头个数
PACKETS_TO_CH=zeros(1,r);% 记录每一轮的普通节点个数
C=repmat(struct('xd',0,'yd',0,'distance',0,'id',0),n*p,1);% 记录当前轮簇头的相关数据
PACKETS_FIRST_DEAD_X=zeros(1,times);% 记录每次实验第一次死掉节点时的横坐标
PACKETS_FIRST_DEAD_Y=zeros(1,times);% 记录每次实验第一次死掉节点时的轮数

PACKETS_DEAD_X=zeros(1,r);% 该变量为“记录每轮死亡节点死亡数量的值”的变化量的横坐标
PACKETS_DEAD_Y=zeros(1,r);% 该变量为“记录每轮死亡节点死亡数量的值”的变化量的纵坐标值
for i=1:1:r
    PACKETS_DEAD_X(i)=i;
end

for tests=1:1:times
    figure(1);
    % 初始化节点，循环n次，画出n个节点
    XR=zeros(1,n);% 临时变量，记录X坐标
    YR=zeros(1,n);% 临时变量，记录Y坐标
    for i=1:1:n
        % 新建一个随机的点
        S(i).xd=rand(1,1)*xm;
        XR(i)=S(i).xd;
        S(i).yd=rand(1,1)*ym;
        YR(i)=S(i).yd;
        S(i).G=0;  %每一次周期结束此变量为0
        S(i).type='N';
        temp_rnd0=i;
        if(temp_rnd0<=m*n+1) %前面的n*m个是+节点
            S(i).E=Eo*(1+a);  %能量是初始能量的2倍，a=1 
            S(i).ENERGY=1;
            plot(S(i).xd,S(i).yd,'+');
            hold on;
        end
        if(temp_rnd0>=m*n+1)  %后面的n-n*m个是0节点
            S(i).E=Eo;% S(i).E 是该节点当前的能量值
            S(i).ENERGY=0;
            plot(S(i).xd,S(i).yd,'o');% plot函数，在界面上画点
            hold on;
        end

    end
    S(n+1).xd=sink.x;   %最后一个节点画，表示基站节点
    S(n+1).yd=sink.y;
    plot(S(n+1).xd,S(n+1).yd,'x');
    hold on;

    % 开始仿真
    isFirst = 1;
    for temp_r=1:1:r % 开始新的一轮
        hold off;% 使新添加到坐标区中的绘图清除现有绘图并重置所有的坐标区属性。
        figure(1);% 将界面反复显示在标号为1的窗口中
        % 新的一轮，当前簇头节点个数刷新
        cluster = 0;
        countCHs = 0;
        % 新的一轮，重新记录节点死亡数
        dead_a = 0;
        dead_n = 0;
        dead = 0;

        % 画点
        for i=1:1:n
            if(i<=n*m) % 前面的n*m个是+节点
                plot(S(i).xd,S(i).yd,'+');
            end
            if(i>n*m) % 后面的n-n*m个是0节点
                plot(S(i).xd,S(i).yd,'o');
            end
            hold on;
        end

        %判断死亡节点。当节点能量为0时，该节点为死亡节点。
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
                if(S(i).ENERGY==1) % 死亡的特殊节点
                    dead_a=dead_a+1; 
                end
                if(S(i).ENERGY==0) % 死亡的普通节点
                    dead_n=dead_n+1;
                end
                hold on;
            end
        end
        PACKETS_DEAD_Y(temp_r)=dead;
        plot(S(n+1).xd,S(n+1).yd,'x');
        hold on;

        %选举簇头节点。按 LEACH算法的公式选举簇头节点。 
        X=zeros(1,n*p);% 临时变量，记录X坐标
        Y=zeros(1,n*p);% 临时变量，记录Y坐标
        for i=1:1:n
            if(S(i).E>0) 
                temp_rand=rand; % 给temp_rand随机附一个值（rand 返回一个(0-1)之间的一个随机数）
                if((S(i).G)<=0)% 该节点在本轮中没有当过簇头节点的二重保证
                    if(temp_rand<=(p/(1-p*mod ((temp_r-1),round(1/p))))) 
                        countCHs=countCHs+1;
                        % packets_T0_BS=packets_T0_BS+1; 
                        % PACKETS_TO_BS(temp_r+1)=packets_T0_BS; 
                        S(i).type='C';
                        S(i).G=round(1/p)-1; % (round四舍五入为最近的整数)
                        cluster=cluster+1;%簇头數加1
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
                            % 能量大于阈值，消耗能量为：传输能量(将结果发送给汇聚节点)+数据融合能量+与汇聚节点通信能量
                            %S(i).E=S(i).E-((ETX+EDA)*(Bit)+Emp*Bit*(distance*distance*distance*distance));
                            S(i).E=S(i).E-((ETX+EDA)*(Bit)+Emp*Bit);
                        end
                        if (distance<=do)
                            % 能量小于等于阈值，消耗能量为：传输能量(将结果发送给汇聚节点)+数据融合能量+耗散能量
                            %S(i).E=S(i).E-((ETX+EDA)*(Bit)+Efs*Bit*(distance*distance));
                            S(i).E=S(i).E-((ETX+EDA)*(Bit)+Efs*Bit);
                        end
                    end
                end
            end
        end
        PACKETS_TO_BS(temp_r)=countCHs;% 本轮产生的簇头节点数

        %普通节点加入簇中
        for i=1:1:n
            %如果i节点是普通节点，并且i节点的能量够，则判断是否将该节点加入簇头
            if(S(i).type=='N'&& S(i).E>0)
                if(cluster>=1)
                    min_dis=sqrt((S(i).xd-C(1).xd)^2+(S(i).yd-C(1).yd)^2);% 计算该点距离第一个簇头的距离（默认记录第一个簇头作为初始点）
                    min_dis_cluster=1;% 记录第一个簇头的标号，（默认记录第一个簇头作为初始点）
                    for c=1:1:cluster
                        temp=min(min_dis,sqrt((S(i).xd-C(c).xd)^2+(S(i).yd-C(c).yd)^2)); % 计算c节点距离i节点的距离
                        if(temp<min_dis) % 如果i到c比i到中心点距离短，则选择将数据传送到c节点
                            min_dis=temp;
                            min_dis_cluster=c;
                        end
                    end

                    if(min_dis>do) % 如果最近的点的剩余能量可以进行广播，则参与活动。
                        % 消耗的能量为：传输能量(将数据发送给簇头)
                        S(i).E=S(i).E-(ETX*Bit);
                    end
                    if(min_dis<=do) % 如果最近的点的剩余能量不足以进行广播，则待机
                        % 消耗的能量为：耗散能量
                        S(i).E=S(i).E-(Efs*Bit);
                    end
                    %计算簇头节点的能量消耗
                    if(min_dis>0) % 如果簇头节点还未能量耗尽，则消耗能量为：接收能量+融合能量。
                        S(C(min_dis_cluster).id).E=S(C(min_dis_cluster).id).E-((ERX+EDA)*Bit);
                    end
                    S(i).min_dis=min_dis;% 记录距离其连接的簇头的距离
                    S(i).min_dis_cluster=min_dis_cluster;% 记录其连接的簇头的编号
                end
            end
        end
        PACKETS_TO_CH(temp_r)=n-dead-cluster;% 记录当前存活非簇头节点个数
        fprintf("%d %d\n",temp_r, countCHs);

        % 当所有的节点都当过一次簇头后，将所有节点都设置为未曾担任过簇头节点，以便开始新的簇头选举
        if(mod (temp_r,round(n*p)) == 0)
            for i=1:1:n
                S(i).G=0;  %每一次周期结束此变量为0
                S(i).type='N';
            end
        end
    end
    
    figure(3);
    plot(PACKETS_DEAD_X,PACKETS_DEAD_Y);
    xlabel('轮数');
    ylabel('死亡节点个数');
    title('节点死亡曲线图');
    hold on;
end

figure(2);
plot(PACKETS_FIRST_DEAD_X,PACKETS_FIRST_DEAD_Y);% 画折线图
xlabel('测试次数');
ylabel('运行轮数');
title('第一次出现死亡节点时的运行轮数');
