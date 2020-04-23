function [fir_pot,basline]=calcu_distang(image,bw_thre,remove,remtimes,bas_rate)
    bw=im2bw(image,bw_thre);
    se = strel('disk',2);
    openbw=imopen(bw,se);
    openbw=abs(1-openbw);
    BW = bwareaopen(openbw,remove);
    [x,y]=find(BW==1);
    
    skeletonizedImage = bwmorph(BW, 'skel', inf); % 提取初始骨架
    BW1 = bwmorph(skeletonizedImage,'spur',remtimes); % 骨架去骨刺
    [x11,y11]=find(BW1==1);
    % 中线竖直方向单列化
%     e=unique(sort(x11));
    e=sort(x11); 
    f=zeros(size(e,1),1);
    for j=1:size(e)
        f(j,1)=mean(y11(x11==e(j)));   
    end
    basline=[e,f];
    
    bb=size(e,1);
    bas_point=fix(0.01*bas_rate*size(e,1)); % 头部基准点通过比例确定（弯曲/直立的中心点数差异较大±30）
    p=polyfit(e(1:bas_point),f(1:bas_point),1); % poly2sym,求出拟合直线的系数
%     angle=atan(p(1))*180/pi;
    pv=[-1/p(1),0]; % 拟合直线的垂线
    fishdist=(pv(1)/abs(pv(1)))*(pv(1)*x+pv(2)-y*1)/((pv(1)^2+1^2)^1/2);
    [~,mininx]=min(fishdist);
    fir_pot=[x(mininx),y(mininx)];
    