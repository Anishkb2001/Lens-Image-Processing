P = 'C:\Users\DL6\Desktop\lens\.gitignore\data\data\x-5_y+5';
D = dir(fullfile(P,'*.pgm'));
C = cell(size(D));

for k = 1:numel(D)
    A = imread(fullfile(P,D(k).name));
    V = size(A);
    C{k} = imcrop(A,[0,0,V(2)/2,V(1)/2]);
end