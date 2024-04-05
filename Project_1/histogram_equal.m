clear; close all;


lena = imread("lena512.bmp");

%% 1. Task: Histogram

% hist
[N] = imhist(lena);

% plot
figure(1)
bar(N);
title('Histogram to "lena"', 'FontSize', 11);
xlabel('Pixel value')
ylabel('Number of pixels')


%% 2. Task: distort image

% apply distortion
a = 0.2;
b= 50;
lena_dist = min(max((a * lena + b), 0), 255);

% hist
[N_dist] = imhist(lena_dist);

% plot
figure(2)
bar(N_dist)
title('Histogram to "lena" after distortion', 'FontSize', 11);
xlabel('Pixel value')
ylabel('Number of pixels')


figure (3)
imshow(lena_dist);

%% 3.Task: Equalization

% algorithm
bins = length(N_dist);
prob = zeros(bins,1);

for i=1:bins
    prob(i) = N_dist(i)/sum(N_dist); % calc probabilities
end

l = uint8(256*cumsum(prob)); % calc cdf


% apply cdf
lena_equ = lena_dist;
for i=1:512
    for j=1:512
        val = lena_dist(i, j);
        lena_equ(i,j) = l(val+1);
    end
end

% hist
[N_equ] = imhist(lena_equ);

% plot
figure(4)
bar(N_equ)
title('Histogram to "lena" after equalization', 'FontSize', 11);
xlabel('Pixel value')
ylabel('Number of pixels')


figure (5)
imshow(lena_equ);


