function [fir_pot,basline]=calcu_distang(image,bw_thre,remove,remtimes,bas_rate)
    bw=im2bw(image,bw_thre);
    se = strel('disk',2);
    openbw=imopen(bw,se);
    openbw=abs(1-openbw);
    BW = bwareaopen(openbw,remove);
    [x,y]=find(BW==1);
    
    skeletonizedImage = bwmorph(BW, 'skel', inf); % ��ȡ��ʼ�Ǽ�
    BW1 = bwmorph(skeletonizedImage,'spur',remtimes); % �Ǽ�ȥ�Ǵ�
    [x11,y11]=find(BW1==1);
    % ������ֱ�����л�
%     e=unique(sort(x11));
    e=sort(x11); 
    f=zeros(size(e,1),1);
    for j=1:size(e)
        f(j,1)=mean(y11(x11==e(j)));   
    end
    basline=[e,f];
    
    bb=size(e,1);
    bas_point=fix(0.01*bas_rate*size(e,1)); % ͷ����׼��ͨ������ȷ��������/ֱ�������ĵ�������ϴ��30��
    p=polyfit(e(1:bas_point),f(1:bas_point),1); % poly2sym,������ֱ�ߵ�ϵ��
%     angle=atan(p(1))*180/pi;
    pv=[-1/p(1),0]; % ���ֱ�ߵĴ���
    fishdist=(pv(1)/abs(pv(1)))*(pv(1)*x+pv(2)-y*1)/((pv(1)^2+1^2)^1/2);
    [~,mininx]=min(fishdist);
    fir_pot=[x(mininx),y(mininx)];
    