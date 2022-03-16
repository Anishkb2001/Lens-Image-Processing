P = 'C:\Users\DL6\Desktop\lens\.gitignore\data\data\x-5_y+5';
D = dir(fullfile(P,'*.pgm'));
C = cell(size(D));

for k = 1:numel(D)
    A = imread(fullfile(P,D(k).name));
    V = size(A);
    C{k} = imcrop(A,[0,0,V(2)/2,V(1)/2]);
end


figure(1)


subplot(1,3,1)
imshow(C{3})

subplot(1,3,2)
gr = C{3};
size = size(gr);

% perform closing using a 5x5 circular structuring element
sel = strel('disk', 2, 4);
mcl = imclose(gr, sel);
% cluster gray levels using kmeans: using 3 clusters
x = double(mcl(:));
% figure(2)
% % for l = 1:10
% %     subplot(1,10,l)
% %     idx = kmeans(x, 2);
% %     cl = reshape(idx, size);
% %     rgb = label2rgb(cl);
% %     imshow(rgb)
% % end
% idx = kmeans(x, 2,"MaxIter",100);
opts = statset('Display','final');
[idx,cent] = kmeans(x,2,'Distance','cityblock',...
    'Replicates',5,'Options',opts);
tdx = kmeans(x,2,'Start',cent,'MaxIter',100);
cl = reshape(tdx, size);
rgb = label2rgb(cl);
imshow(medfilt3(rgb))

figure(2)
dtx = dbscan(x,1,5);
c2 = reshape(dtx,size);
grey_db = im2gray(c2);
imshow(grey_db)


% plot(x(idx==1,1),x(idx==1,2),'r.','MarkerSize',12)
% hold on
% plot(x(idx==2,1),x(idx==2,2),'b.','MarkerSize',12)
% plot(C(:,1),C(:,2),'kx',...
%      'MarkerSize',15,'LineWidth',3) 
% legend('Cluster 1','Cluster 2','Centroids',...
%        'Location','NW')
% title 'Cluster Assignments and Centroids'
% hold off


% figure(1)
% subplot(1,3,3)
% numColors = 2;
% L = imsegkmeans(rgb,numColors,'MaxIterations',100,'Start',C);
% B = labeloverlay(rgb,L);
% imshow(im2gray(B))
% title("Labeled Image RGB")


