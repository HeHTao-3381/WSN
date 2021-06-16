%----------------%
%名词解释
% data 数据是指PS4的初始矩阵，大小为2行100列
% node 节点总数
% PS4 节点数据
% BS 汇聚节点，横坐标BSx，纵坐标BSy
% d(i,j) 第i节点到第j节点的距离值

function s=costofpegasos (rmax)
    sum=0;
    rmax=1; % 相当于传了个参数。若不加这句，会提示输入参数的数目不足
    for r=1:rmax 
        %pegasis成chain与BS位置有关
        PS4=load('data.txt'); % 将文件变量加载到工作区中
        PS4
        PS4=PS4.'; % 将矩阵进行转置
        PS4
        BSx=50;
        BSy=300;
        node=length(PS4);
        node
    end

    pause

    % `(:)` 可以将向量转换为列向量，行向量相当于直接转置，列向量不变，
    % 而如果是n*m维向量则仍然是以列为主，即按照第一列，第二列的顺序转换为列向量。
    % a(:,1)为取a矩阵中第一列元素
    % a(1,:)为取a矩阵中第一行元素
    %按照到BS距离从近到远的顺序放置节点坐标到PS4矩阵中，PS4(1,:)中节点坐标是离BS最近的；
    %PS4(i,:)表示第i节点，具体是：PS4(i,1)=x坐标，PS4(i,2)=y坐标，PS4(i,3)=i表示节点序号

    %冒泡排序，将近的节点排在前面，远的节点排在后面
    for i=1:node
        for j=i:node
            if((PS4(i,1)-BSx)^2+(PS4(i,2)-BSy)^2>(PS4(j,1)-BSx)^2+(PS4(j,2)-BSy)^2)
                % 节点i到BS的距离比j到BS的距离远
                s=PS4(i,:);
                PS4(i,:)=PS4(j,:);
                PS4(j,:)=s;
            end
        end
        PS4(i,3)=i; % 将节点按顺序进行编号
    end
    '排序完成----------'
    PS4

    %按照‘k’黑色，‘o’圆圈画出PS4表示的节点分布图figure(1);
    plot(PS4(:,1),PS4(:,2),'ko')
    '画图完成----------'
    pause
    hold on

    d=zeros(node,node);

    % 计算第i节点到第j节点的距离值
    for i=1:node
        for j=1:node
            if(i~=j) % ~逻辑非
                d(i,j)=sqrt((PS4(i,1)-PS4(j,1))^2+(PS4(i,2)-PS4(j,2))^2);
            else
                d(i,j)=10^4; % 取一个最大值，表示无穷
            end
        end
    end

    % d

    % 从离BS最远节点PS4(node,:)开始按照greedy算法逐个找最近的节点，并将其坐标依次写入PS5
    % 这样PS5中按序排列的所有节点坐标即代表整条卢路由，
    % 比如PS5(i,:)表示第i行所有值或说此节点坐标，即PS5(i,1)=x坐标，PS5(i,2)=y坐标
    
    % 计算整条路由的能量值即距离平方和
    tic % tic 函数记录当前时间，toc 函数使用记录的值计算经过的时间。

    '计算路径平方和----------'
    indx=node;
    totaldis=0;
    for i=1:100
        PS5(i,:)=PS4(indx,:);
        %i
        %PS5
        %indx
        % pause
        d(:,indx)=10^8;
        [distance,indx]=min(d(indx,:)); % 找出d中indx行中的最小值，值赋值给distance，坐标赋值给indx
        if(distance~=10^8)
            totaldis=totaldis+distance*distance;
        end
    end
    tocgreed=toc
    totaldis=totaldis

    pause

    %按':'点线,'b'蓝色，'o'圆圈画出PS5表示的路由
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
    % savefile='costofpegasis.txt';
    % save(savefile,'sum','-ASCII');
end
