%仿真实验环境设定 本实验设定有10个能量是1个单位的高级节点，用+ 表示;有90个能量是0.5个单位的普通节点，用o表示。在区域中间(50,50)的坐标处，有一个基站，用x表示.
clear;%清除內存变量

xm=100;%x轴范围
ym=100;%y轴范围

sink.x=0.5*xm; %基站x轴
sink.y=0.5*ym; %基站y轴

n=100;%节点总数
m=0.1;

p=0.1;%簇头概率

Eo=0.02;%初始能量
ETX=50*0.000000000001;%传输能量，每bit
ERX=50*0.000000000001;%接收能量，每bit
Efs=10*0.000000000001;%耗散能量，每bit
EDA=5*0.000000000001;%融合能耗，每bit
Emp=5*0.000000000001;
a=1;
dead=0; 
r=100;
countCHs=0;
packets_T0_BS=0;
cluster=0;
do=30;

for i=1:1:n
	S(i).xd=rand(1,1)*xm;
	XR(i)=S(i).xd;
	S(i).yd=rand(1,1)*ym;
	YR(i)=S(i).yd;
	S(i).G=0;  %每一次周期结束此变量为0
	S(i).type='N';
	temp_rnd0=i;
	if(temp_rnd0>=m*n+1)  %后面的90个是0节点
		S(i).E=Eo;
		S(i).ENERGY=0;
		plot(S(i).xd,S(i).yd,'o');
	end
	if(temp_rnd0<=m*n+1) %前面的10个是+节点
		S(i).E=Eo*(1+a);  %能量是初始能量的2倍，a=1 
		S(i).ENERGY=1;
		plot(S(i).xd,S(i).yd,'+');
		hold on;
	end
end
S(n+1).xd=sink.x;   %最后一个节点画，表示基站节点
S(n+1).yd=sink.y;
plot(S(n+1).xd,S(n+1).yd,'x');

dead_a=0;
dead_n=0;
%判断死亡节点。当节点能量为0时，该节点为死亡节点。
for j=1:1:r
    fprintf("%d %d\n",j,countCHs);
    hold off;
    figure(1);
    cluster=0;
    
    for i=1:1:n
        if(S(i).E<=0) 
            plot(S(i).xd,S(i).yd,'red.'); 
            dead=dead+1;
            if(S(i).ENERGY==1) 
                dead_a=dead_a+1; 
            end
            if(S(i).ENERGY==0)
                dead_n=dead_n+1;
            end
            hold on;
        end
        if(i<=10)
           plot(S(i).xd,S(i).yd,'+');
           hold on;
        end
        if(i>10)
           plot(S(i).xd,S(i).yd,'o');
        end 
    end
    plot(S(n+1).xd,S(n+1).yd,'x');
    

    %选举簇头节点。按 LEACH算法的公式选举簇头节点。 
     for i=1:1:n
        if(S(i).E>0) 
            temp_rand=rand; 
            if((S(i).G)<=0)
                if(temp_rand<=(p/(1-p*mod (r,round(1/p))))) 
                    countCHs=countCHs+1;
                    packets_T0_BS=packets_T0_BS+1; 
                    PACKETS_T0_BS(r+1)=packets_T0_BS; 
                    S(i).type='C';
                    S(i).G=round(1/p)-1;
                    cluster=cluster+1;%簇头數加1
                    C(cluster).xd=S(i).xd;
                    C(cluster).yd=S(i).yd;
                    plot(S(i).xd,S(i).yd,'k*');
                    distance=sqrt((S(i).xd-(S(n+1).xd))^2+(S(i).yd-(S(n+1).yd))^2); 		
                    C(cluster).distance=distance;
                    C(cluster).id=i;
                    X(cluster)=S(i).xd;
                    Y(cluster)=S(i).yd; 

                    distance;
                    if(distance>do)  %能量计算
                        S(i).E=S(i).E-((ETX+EDA)*(4000)+Emp*4000*(distance*distance*distance*distance));
                    end
                    if (distance<=do)
                        S(i).E=S(i).E-((ETX+EDA)*(4000)+Efs*4000*(distance*distance));
                    end
                end
            end
        end
    end


    %普通节点加入簇中
    for i=1:1:n
        if(S(i).type=='N'&& S(i).E>0)
            if(cluster-1>=1)
                min_dis=sqrt((S(i).xd-S(n+1).xd)^2+(S(i).yd-S(n+1).yd)^2);
                min_dis_cluster=1;
                for c=1:1:cluster-1
                    temp=min(min_dis,sqrt((S(i).xd-C(c).xd)^2+(S(i).yd-C(c).yd)^2));
                    if(temp<min_dis)
                        min_dis=temp;
                        min_dis_cluster=c;
                    end
                end
                min_dis;
                if(min_dis>do)
                    S(i).E=S(i).E-(ETX*(4000)+Emp*4000*(min_dis*min_dis*min_dis*min_dis));
                end
                if(min_dis<=do)
                    S(i).E=S(i).E-(ETX*(4000)+Emp*4000*(min_dis*min_dis*min_dis*min_dis));
                end
                if(min_dis>0) %能量计算
                    S(C(min_dis_cluster).id).E=S(C(min_dis_cluster).id).E-((ERX+EDA)*4000);
                    PACKETS_TO_CH(r+1)=n-dead-cluster+1;
                end
                S(i).min_dis=min_dis;
                S(i).min_dis_cluster=min_dis_cluster;
            end
        end
    end
end
