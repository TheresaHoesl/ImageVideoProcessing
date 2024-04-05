clear;
close all;

rng(42); % Set seed for reproducibility

im = imread('lena512.bmp');

% Gaussian image
im_gauss = im + uint8(mynoisegen('gaussian', 512, 512, 0, 64));

% Salty and peppery image
im_saltp = im;
n = mynoisegen('saltpepper', 512, 512, 0.05, 0.05);
im_saltp(n == 0) = 0;
im_saltp(n == 1) = 255;
   
figure;
subplot(1, 3, 1), imshow(im, []);
subplot(1, 3, 2), imshow(im_gauss, []);
subplot(1, 3, 3), imshow(im_saltp, []);

res1 = uint8(apply_filter(im_gauss, 'mean'));
res2 = uint8(apply_filter(im_gauss, 'median'));
res3 = uint8(apply_filter(im_saltp, 'mean'));
res4 = uint8(apply_filter(im_saltp, 'median'));

[N1] = imhist(res1);
[N2] = imhist(res2);
[N3] = imhist(res3);
[N4] = imhist(res4);


% plot
figure;
subplot(1, 2, 1), bar(N1);
subplot(1, 2, 2), bar(N2);
figure;
subplot(1, 2, 1), bar(N3);
subplot(1, 2, 2), bar(N4);


function noise = mynoisegen(type, m, n, param1, param2)
    if strcmpi(type, 'uniform')
        if nargin < 4
            param1 = -1;
        end
        if nargin < 5
            param2 = 1;
        end
        noise = param1 + (param2 - param1) * rand(m, n);
    elseif strcmpi(type, 'gaussian')
        if nargin < 4
            param1 = 0;
        end
        if nargin < 5
            param2 = 1;
        end
        noise = param1 + sqrt(param2) * randn(m, n);
    elseif strcmpi(type, 'saltpepper')
        if nargin < 4
            param1 = 0.5;
        end
        if nargin < 5
            param2 = 1;
        end
        noise = 0.5 * ones(m, n);
        nn = rand(m, n);
        noise(nn <= param1) = 0;
        noise(nn > param1 & nn <= param1 + param2) = 1;
    else
        error('Unknown noise type.');
    end
end

function result = apply_filter(img, filter_name)
    mean_filter = ones(3) / 9;
    if strcmp(filter_name, 'mean')
        result = conv2(img, mean_filter, 'same');
    elseif strcmp(filter_name, 'median')
        result = medfilt2(img, [3, 3]);
    else
        error('Not a valid filter name');
    end
end