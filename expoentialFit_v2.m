clear;close all;clc;
% data_dir='E:\UCLA_files\projects\PhosFluo\2022\glucose\no_phantom\0000';
data_dir='G:\Artem\glucose_2\02_24\0.5_water\0017';
cd('C:\Users\DL9\Downloads')
data_setc=load_pgm_folder(data_dir, 600, 800, 1);

background = imread(fullfile(data_dir, 'BG2 deltaT=0800.pgm'));
background = double(background(1:600, 1:800));  
background = pixel_binning(background, 5);

Nf = size(data_setc,3);

[H, W, ~] = size(data_setc);
x_fit = 1460:20:1660;
lifetime_map = zeros(H,W);
lifetime_map_2 = zeros(H,W);
LFM = zeros(H,W); % final life time
init_map = zeros(H,W);
score_rsq = zeros(H,W);
score_rmse = zeros(H,W);
% bqs = get_bqs(0);
%% exp(linear) fitting
for ii=1:H
    for jj=1:W
        % Fiting using left div y=c*exp(a*x);   lny=lnc+a*x=b+ax;
        xx = x_fit';
        %yy = max(squeeze(data_setc(ii,jj,:)) - background(ii, jj), 0);
        yy = squeeze(data_setc(ii,jj,:));
        lny = log(yy);
        XX = [ones(length(xx),1) xx];
        betac = XX\lny;
        b = betac(1); % b=lnc
        a = betac(2); % a
        lifetime_map(ii,jj) = a;
        init_map(ii,jj) = b;
        % get error
        yCalc = XX*betac;
        % R2 for linear
        rsq = 1 - sum((lny - yCalc).^2)/sum((lny - mean(lny)).^2);
        % residual for all
        rmse = sqrt(sum(exp(yCalc)-exp(lny)).^2);
        score_rsq(ii,jj) = rsq;
        score_rmse(ii,jj) = rmse;
%         if jj==W,fprintf('ii: %3d.      ',ii);toc,end

        lifetime_map_2(ii,jj) = (11 * (x_fit*lny) - sum(x_fit)*sum(lny))/(11*sum(x_fit.^2)-sum(x_fit)^2);
    end
end
% figure,imshow(lifetime_map,[]),title('a');
figure (1),imshow(-1./lifetime_map,[0 1000]),title('-1/a');
figure (2),imshow(-1./lifetime_map_2,[0 1000]),title('-1/a_VS');
figure (3),imshow(score_rsq,[]),title('R2 value'); colorbar;
% figure,imshow(score_rmse,[]),title('rmse value');

%% masking: low intensity (eps) for first four and low R2 fitting
low_threshold = 30;
frame_include = 4;
mask_lowint = false([H,W]);

mask_frame = sum(data_setc(:,:,1:frame_include) < low_threshold,3); % true for LF=0
mask_lowint = mask_lowint | mask_frame;
%% R2 masking
% mask_r2 = ordfilt2(score_rsq,15,true(5));
mask_r2 = (score_rsq>0.5);
mask_r2 = bwareaopen(mask_r2, 0); 
J = imclose(mask_r2,true(1));
Jd = imopen(J,true(1));
%Jd=J
%Jf = imfill(Jd,'holes');
Jf = bwareaopen(Jd, 0);    
Jc = bwconvhull(Jf,'objects');
Jo = imopen(Jc,true(1));    
LTM0 = (-1./lifetime_map);
LTM0(isnan(LTM0))=0;
LTM0(LTM0>300)=300;
LTM0(LTM0<0)=0;
LTM = LTM0.*Jo;

figure(4)
subplot(2,3,1)
imshow(mask_r2)
subplot(2,3,2)
imshow(J)
subplot(2,3,3)
imshow(Jd)
subplot(2,3,4)
imshow(Jf)
subplot(2,3,5)
imshow(Jc)
subplot(2,3,6)
imshow(Jo)
stats = regionprops(Jo,LTM0,'MeanIntensity','WeightedCentroid');
figure (5),imshow(LTM, [0 300]),title('lifetime');colormap jet;colorbar;
stats.MeanIntensity

%%
cd('D:\Artem\phosphorescence lifetime imager\barcode_data')
ltime = imread('lifetimeUnscaled.pgm');
figure (6),imshow(ltime, [0 300]),title('lifetime');colormap jet;colorbar;