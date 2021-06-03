function s=costofpegasos (rmax)
    sum=0;
    rmax=1;
    for r=1:1:rmax 
    %pegasis成chain与BS位置有关
    PS4=load('data');
    PS4
    PS4=PS4.';
    PS4
    BSx=50;
    BSy=300;
    node=length(PS4);
    node
end
pause
%按照到BS距离从近到远的顺序放置节点坐标到PS4矩阵中，PS4(1:)中节点坐标是离BS最近的；
%PS4(i:)表示第i节点，具体是：PS4(i,1)=x坐标，PS4(i,2)=y坐标，PS4(i,3)=i表示节点序号
for i=1:node
    for j=i:node
        if(PS4(i,1)-BSx)^2+(PS4(i,2)-BSy)^2>(PS4(j,1)-BSx)^2+(PS4(j,2)-BSy)^2
            s=PS4(i,:);
            PS4(i,:)=PS4(j,:);
            PS4(j,:)=s;
        end
    end
    PS4(i,3)=i;
end
PS4
%按照‘k’黑色，‘o’圆圈画出PS4表示的节点分布图figure(1);
plot(PS4(:,1),PS4(:,2),'ko')
pause
hold on
%d(i,j)为第i节点到第j节点的距离值?
for i=1:node
    for j=1:node
        if(i~=j)
            d(i,j)=sqrt((PS4(i,1)-PS4(i,1))^2+(PS4(j,2)-PS4(j,2))^2);
        else
            d(i,j)=10^8;
        end
    end
end
%从离BS最远节点PS4(node,:)开始按照greedy算法逐个找最近的节点，并将其坐标依次写入PS5
%这样PS5中按序排列的所有节点坐标即代表整条卢路由，比如PS5(i,:)表示第i行所有值或说此节点坐标，即PS5(i,1)=x坐标，PS5(i,2)=y坐标
%计算整条路由的能量值即距离平方和
tic
indx=node;
totaldis=0;
for i=1:100
    PS5(i,:)=PS4(indx,:);
    %PS5
    %indx
    %pause
    d(:,indx)=10^8;
    [distance,indx]=min(d(indx,:));
    if(distance~=10^8)
        totaldis=totaldis+distance*distance;
    end
end
tocgreed=toc
totaldis=totaldis
pause
%按':'点线,'k'黑色，'o'圆圈画出PS5表示的路由
figure(2);
plot(PS5(:,1),PS5(:,2),':bo')
PS5
pause
%考虑所有节点做一次chainleader,共node rounds的总能量消耗情况
costofdirectn=0;
for i=1:node
    costofdirectn=costofdirectn+(PS4(i,1)-BSx)^2+(PS4(i,2)-BSy)^2;
end
costofpegasisn=totaldis*node+costofdirectn
costofpegasis=costofpegasisn/node
if r==1
    sum(r)=costofpegasis;
else
    sum(r)=sum(r-1)+costofpegasis;
end
fprintf('\t\t\trond=%d\n',rmax);
fprintf('\t\t\tcostofpegasis=%d\n',sum(r));
savefile='costofpegasis';
save(savefile,'sum','-ASCII');
end




