cd('C:\Users\DL6\Desktop\lens\.gitignore\data\data\x-5_y+5')

im1 = imread('deltaT=1460.pgm');
im1 = im1(1:size(im1,1)/2, 1:size(im1,2)/2);

im2 = imread('deltaT=1480.pgm');
im2 = im2(1:size(im2,1)/2, 1:size(im2,2)/2);

im3 = imread('deltaT=1500.pgm');
im3 = im3(1:size(im3,1)/2, 1:size(im3,2)/2);

im4 = imread('deltaT=1520.pgm');
im4 = im4(1:size(im4,1)/2, 1:size(im4,2)/2);

param = uint16(75);
%im1 = imadjust(im1);

ltime_im = imread('lifetimeHeatmap.ppm');
ltime_raw = imread('lifetimeUnscaled.pgm');

disp(size(im1));
disp(size(ltime_im));

mask = uint16(zeros(size(im1)));
im1_edge = activecontour(im1, mask);

figure(1)

subplot(3,2,1)
imshow(uint16(im1))
subplot(3,2,2)
imshow(im1_edge)

subplot(3,2,3)
imshow(ltime_im)

subplot(3,2,5)
imshow(imadjust(ltime_raw))

for row = 1:size(im1,1)
    for col = 1:size(im1,2)
        if im1(row, col) < param || im2(row, col) < param
            ltime_im(ceil(row/5), ceil(col/5), 1) = 0;
            ltime_im(ceil(row/5), ceil(col/5), 2) = 0;
            ltime_im(ceil(row/5), ceil(col/5), 3) = 33641;
            ltime_raw(ceil(row/5), ceil(col/5)) = 0;
        end
    end
end

subplot(3,2,4)
imshow(ltime_im)

subplot(3,2,6)
imshow(imadjust(ltime_raw))


ltime_raw = bwareaopen(ltime_raw, 10, 8);

%SE = strel('diamond',1);
%ltime_raw = imerode(ltime_raw,SE);

ltime_maxes = max(ltime_im(:,:,1:2), [], 3);
ltime_maxes = bwareaopen(ltime_maxes, 10, 8);

figure(3)
imshow(ltime_maxes)
for row = 1:size(ltime_raw,1)
    for col = 1:size(ltime_raw,2)
        if ltime_raw(row,col) == 0 || ltime_maxes(row,col) == 0
            ltime_im(row, col, 1) = 0;
            ltime_im(row, col, 2) = 0;
            ltime_im(row, col, 3) = 33641;
        end
    end
end


figure (2)
subplot(1,2,1)
imshow(ltime_raw);
subplot(1,2,2)
imshow(ltime_im);


imwrite(imadjust(im1, [0, double(max(im1(:)))/65535], [0, 1]), 'deltaT=1460.png');
imwrite(imadjust(im2, [0, double(max(im2(:)))/65535], [0, 1]), 'deltaT=1480.png');
imwrite(imadjust(im3, [0, double(max(im3(:)))/65535], [0, 1]), 'deltaT=1500.png');
imwrite(imadjust(im4, [0, double(max(im4(:)))/65535], [0, 1]), 'deltaT=1520.png');

imwrite(ltime_raw, 'lifetimeUnscaled.png');
imwrite(ltime_im, 'lifetimeMap.png');
