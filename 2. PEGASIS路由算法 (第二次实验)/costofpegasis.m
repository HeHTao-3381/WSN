function s=costofpegasos (rmax)
    sum=0;
    rmax=1;
    for r=1:1:rmax 
    %pegasis��chain��BSλ���й�
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
%���յ�BS����ӽ���Զ��˳����ýڵ����굽PS4�����У�PS4(1:)�нڵ���������BS����ģ�
%PS4(i:)��ʾ��i�ڵ㣬�����ǣ�PS4(i,1)=x���꣬PS4(i,2)=y���꣬PS4(i,3)=i��ʾ�ڵ����
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
%���ա�k����ɫ����o��ԲȦ����PS4��ʾ�Ľڵ�ֲ�ͼfigure(1);
plot(PS4(:,1),PS4(:,2),'ko')
pause
hold on
%d(i,j)Ϊ��i�ڵ㵽��j�ڵ�ľ���ֵ?
for i=1:node
    for j=1:node
        if(i~=j)
            d(i,j)=sqrt((PS4(i,1)-PS4(i,1))^2+(PS4(j,2)-PS4(j,2))^2);
        else
            d(i,j)=10^8;
        end
    end
end
%����BS��Զ�ڵ�PS4(node,:)��ʼ����greedy�㷨���������Ľڵ㣬��������������д��PS5
%����PS5�а������е����нڵ����꼴��������¬·�ɣ�����PS5(i,:)��ʾ��i������ֵ��˵�˽ڵ����꣬��PS5(i,1)=x���꣬PS5(i,2)=y����
%��������·�ɵ�����ֵ������ƽ����
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
%��':'����,'k'��ɫ��'o'ԲȦ����PS5��ʾ��·��
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
savefile='costofpegasis';
save(savefile,'sum','-ASCII');
end




