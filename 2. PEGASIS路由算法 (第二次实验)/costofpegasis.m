%----------------%
%���ʽ���
% data ������ָPS4�ĳ�ʼ���󣬴�СΪ2��100��
% node �ڵ�����
% PS4 �ڵ�����
% BS ��۽ڵ㣬������BSx��������BSy
% d(i,j) ��i�ڵ㵽��j�ڵ�ľ���ֵ

function s=costofpegasos (rmax)
    sum=0;
    rmax=1; % �൱�ڴ��˸���������������䣬����ʾ�����������Ŀ����
    for r=1:rmax 
        %pegasis��chain��BSλ���й�
        PS4=load('data.txt'); % ���ļ��������ص���������
        PS4
        PS4=PS4.'; % ���������ת��
        PS4
        BSx=50;
        BSy=300;
        node=length(PS4);
        node
    end

    pause

    % `(:)` ���Խ�����ת��Ϊ���������������൱��ֱ��ת�ã����������䣬
    % �������n*mά��������Ȼ������Ϊ���������յ�һ�У��ڶ��е�˳��ת��Ϊ��������
    % a(:,1)Ϊȡa�����е�һ��Ԫ��
    % a(1,:)Ϊȡa�����е�һ��Ԫ��
    %���յ�BS����ӽ���Զ��˳����ýڵ����굽PS4�����У�PS4(1,:)�нڵ���������BS����ģ�
    %PS4(i,:)��ʾ��i�ڵ㣬�����ǣ�PS4(i,1)=x���꣬PS4(i,2)=y���꣬PS4(i,3)=i��ʾ�ڵ����

    %ð�����򣬽����Ľڵ�����ǰ�棬Զ�Ľڵ����ں���
    for i=1:node
        for j=i:node
            if((PS4(i,1)-BSx)^2+(PS4(i,2)-BSy)^2>(PS4(j,1)-BSx)^2+(PS4(j,2)-BSy)^2)
                % �ڵ�i��BS�ľ����j��BS�ľ���Զ
                s=PS4(i,:);
                PS4(i,:)=PS4(j,:);
                PS4(j,:)=s;
            end
        end
        PS4(i,3)=i; % ���ڵ㰴˳����б��
    end
    '�������----------'
    PS4

    %���ա�k����ɫ����o��ԲȦ����PS4��ʾ�Ľڵ�ֲ�ͼfigure(1);
    plot(PS4(:,1),PS4(:,2),'ko')
    '��ͼ���----------'
    pause
    hold on

    d=zeros(node,node);

    % �����i�ڵ㵽��j�ڵ�ľ���ֵ
    for i=1:node
        for j=1:node
            if(i~=j) % ~�߼���
                d(i,j)=sqrt((PS4(i,1)-PS4(j,1))^2+(PS4(i,2)-PS4(j,2))^2);
            else
                d(i,j)=10^4; % ȡһ�����ֵ����ʾ����
            end
        end
    end

    % d

    % ����BS��Զ�ڵ�PS4(node,:)��ʼ����greedy�㷨���������Ľڵ㣬��������������д��PS5
    % ����PS5�а������е����нڵ����꼴��������¬·�ɣ�
    % ����PS5(i,:)��ʾ��i������ֵ��˵�˽ڵ����꣬��PS5(i,1)=x���꣬PS5(i,2)=y����
    
    % ��������·�ɵ�����ֵ������ƽ����
    tic % tic ������¼��ǰʱ�䣬toc ����ʹ�ü�¼��ֵ���㾭����ʱ�䡣

    '����·��ƽ����----------'
    indx=node;
    totaldis=0;
    for i=1:100
        PS5(i,:)=PS4(indx,:);
        %i
        %PS5
        %indx
        % pause
        d(:,indx)=10^8;
        [distance,indx]=min(d(indx,:)); % �ҳ�d��indx���е���Сֵ��ֵ��ֵ��distance�����긳ֵ��indx
        if(distance~=10^8)
            totaldis=totaldis+distance*distance;
        end
    end
    tocgreed=toc
    totaldis=totaldis

    pause

    %��':'����,'b'��ɫ��'o'ԲȦ����PS5��ʾ��·��
    figure(2);
    plot(PS5(:,1),PS5(:,2),':bo')
    PS5
    
    pause
    
    %�������нڵ���һ��chainleader,��node rounds���������������
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
