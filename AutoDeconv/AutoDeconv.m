function [J,blur,new_blur] = AutoDeconv(image,mask)
    if nargin < 2
        mask = ones(size(image));
    end
% tic
%% Canny edge detection
[~,threshold] = edge(image,'canny');
fudgeFactor = 2.5;
BW2 = edge(image,'canny',threshold*fudgeFactor);
% figure,imagesc(BW2);axis image
% hold on

%% mask by thresholding
% se90 = strel('line',18,90);
% se0 = strel('line',18,0);
% BW2dil = imdilate(BW2,[se90 se0]);
% figure,imagesc(BW2dil);axis image
% BWmask = imfill(BW2dil,4,'holes');
% % bwmask = image > mean(image(:));
% % bwmask = imfill(bwmask,'holes');
% figure,imagesc(BWmask);axis image

%% Hough line detection
[H,theta,rho] = hough(BW2);
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW2,theta,rho,P,'FillGap',5,'MinLength',10);
max_len = 0;
p_lines = {};
edges = {};

for k = 1:length(lines)
% for k = 1:2
%    x = (lines(k).point1(1)):(lines(k).point2(1));
   xy = [lines(k).point1; lines(k).point2];
   x = sort(xy(:,1));
   x = x(1):x(2);
   slope = (xy(2,2)-xy(1,2)) / (xy(2,1)-xy(1,1));
   inter = xy(1,2)-slope*xy(1,1);  
   y = x*slope+inter;
   
   points = [x',y'];
   R = [cosd(90) -sind(90); sind(90) cosd(90)];
%    I = [];
   
   j = round(length(points)/2);
   center = repmat(points(j,:)', 1, length(xy));
   rot = R*(xy'-center)+center;
%    plot(rot(1,:),rot(2,:),'LineWidth',2,'Color','red');
   rot(1,:) = sort(rot(1,:));
   rot(2,:) = sort(rot(2,:));
   I = improfile(image,rot(1,:),rot(2,:));
   
   p_lines{k} = rot;    
   edges{k} = (I');
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%    plot(rot(1,:),rot(2,:),'LineWidth',2,'Color','red');

   % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','cyan');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      
      xy_long = xy;
   end
end

%% mtf estiamtion
% functionalised
[res, blur,inds] = calculate_mtf(edges);
%% RL deconvolution
psfi = fspecial('gaussian',size(image),mean(blur));
image_i = image;
% figure,imagesc(psfi);axis image

check = p_lines(inds);
new_edges = {};
metric1 = [];
metric2 = [];
term = [];
for i = 1:100
    [J,psfr] = deconvblind(image_i.*mask,psfi,1);
    for j = 1:length(check)
        rot = check{j};
        I = improfile(J,rot(1,:),rot(2,:));
        new_edges{j} = I';
    end
    [new_res, new_blur] = calculate_mtf(new_edges);
    metric1 = cat(2,metric1,2*10/mean(new_res));
    metric2 = cat(2,metric2,mean(new_blur));
%     dum = gradient(metric2);
    if i > 5       
        term = metric2(i)-metric2(i-1);
        disp(num2str(term))
    end
    if isnan(term)
        iter = 5;
        break
    end
    if abs(term) < 0.01 | term > 0
        disp(['optimal iteration reached at ',num2str(i-1)])
        iter = i-1;
        break
    else
        image_i = J;
%         psfi = psfr;
    end
end
% figure,plot([metric1' metric2']);
% figure,plot(gradient(metric2))
% iter=5;
[J,psfr] = deconvblind(image.*mask,psfi,iter);
% figure,imagesc(J);axis image;colormap('magma')
% caxis([0 2e4])
% figure,imagesc(psfr-psfi);axis image
% clims([2e4])
% toc
end