P = 'C:\Users\DL6\Desktop\lens\data\data\x+5_y+5';
D = dir(fullfile(P,'*.pgm'));
C = cell(size(D));

for k = 1:numel(D)
    A = imread(fullfile(P,D(k).name));
    V = size(A);
    C{k} = imcrop(A,[0,0,V(2)/2,V(1)/2]);
end


figure(1)

subplot(1,3,1)
imshow(C{1})

subplot(1,3,2)
A = imadjust(C{1},[0 1250]);
imshow(A)

% %%background subtraction
% bw_grayThresh = im2bw(A, graythresh(A));
% % attempt with different thresholding
% bw_adaptThresh = imbinarize(A,'adaptive','Sensitivity',0.65);
% 
% 
% subplot(1,3,3)
% I_subtracted = A;
% I_subtracted(~bw_adaptThresh) = 0;
% I_subtracted(~bw_grayThresh) = 0;
% imshow(I_subtracted)
% title('background subtraction')



