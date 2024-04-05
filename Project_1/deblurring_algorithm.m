% ORIGINAL IMAGE 
file = ['lena512.bmp'];
gray_image = imread(file);  % we need to be able to read the image


% DEFINITION OF BLURRING FUNCTION
r = 8;% this is the radius of the Gaussian kernel
h = myblurgen('gaussian', r);% the blurring function is obtained 

% DEGRADED IMAGE 
g = conv2(double(gray_image), h, 'same'); % this is the image convoluted with the blurring function 
quantized_g = min(max(round(double(g)), 0), 255); % this is the distorted image.

% NOISE VARIANCE
difference = g-quantized_g; 
variance = var(difference); % in order to obtain the variance of the noise,
% we compute the variance of th difference between the out-of-focus image and the quantized image

% RESTORED IMAGE
r = wiener_filtering(quantized_g,h, variance); 

% Display original, degraded, and restored images
figure;
subplot(1, 3, 1), imshow(gray_image, []);
subplot(1, 3, 2), imshow(quantized_g, []);
subplot(1, 3, 3), imshow(r, []);


% Generates the blur functions
function h = myblurgen(type, r)
switch lower(type)
case 'outoffocus'
    support = r*2+1;
    [X, Y] = meshgrid(1:support, 1:support);
    distance = sqrt((X-r-1).^2+(Y-r-1).^2);
    h = double(distance<=r);
    h = h./sum(h(:));
case 'gaussian'
    h = GaussKernel(r*2+1, r/2);
    h = h./sum(h(:));
otherwise
    error('Unknown blur type.');
end
end 

% Generates the Gaussian Kernel 
function [f] = GaussKernel(mask_size,sigma2)
f = zeros(mask_size);
mx = (mask_size+1)/2;
my = mx;
for x = 1:mask_size,
    for y = 1:mask_size,
    f(x,y) = exp(-((x-mx)^2+(y-my)^2)/(2*sigma2))/(2*pi*sigma2);     
    end
end 
end 

% WIENER FILTER 
function restored_image = wiener_filtering(degraded_image, blur_function, variance)

    degraded_image = edgetaper(degraded_image, blur_function);  % we apply the edge taper 

    degraded_image_fft = fft2(degraded_image); % we compute the fft2 transform on the degraded_image 
    blur_function_fft = fft2(blur_function, size(degraded_image, 1), size(degraded_image, 2)); % we compute the fft2 transform on the blurring function
    
    H_wiener = conj(blur_function_fft) ./ (abs(blur_function_fft).^2 + variance/var(degraded_image(:))); % we apply the Wiener filter, using the ratio of the noise variance and the 
    F = H_wiener.* degraded_image_fft; % we apply the Wiener filter 
    f = ifft2(F); % inverse transform 
    restored_image = abs(f); 
    
    
end














    



