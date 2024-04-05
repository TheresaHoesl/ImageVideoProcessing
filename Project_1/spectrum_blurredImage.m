image = 'lena512.bmp'; 
grayImage= imread(image); %we need to be able to read the image

r = 8; % this is the radius of the Gaussian kernel
h = myblurgn('gaussian', r); % the blurring function is obtained 

g = min(max(round(conv2(double(grayImage), h, 'same')), 0), 255); % this is the distorted image. 

I = fft2(grayImage); % we compute the transform function onto the original image 
I =  fftshift(I); % we center the spectra 
I = abs(I); %  we obtain the magnitude
I = log(I+1); % we use log, for perceptual scaling, and +1 since log(0) is undefined

G = fft2(g); 
G = fftshift(G); % Center FFT
G = abs(G); % Get the amplitude 
G = log(G+1); % By spectra we need to obtain the log of the amplitude 

figure;
subplot(1, 3, 1), imshow(I, []); 
subplot(1, 3, 2), imshow(G, []);


% FUNCTION GIVEN TO US IN THE FILE 

% Generates the blur functions
% USAGE: h = myblurgen(type, r)
% type:         
% 'outoffocus'  ideal out-of-focus blur
% 'gaussian'    Gaussian blur
function h = myblurgn(type, r)
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


function [f] = GaussKernel(mask_size,sigma2)
% GAUSSKERNEL 2-D Gaussian kernel 
%
% Usage: [f] = GaussKernel(mask_size)
%
% Input:  mask_size         size of mask
%         sigma2            x and y variance
%
% Output: f                 mask
%
% v1.0 Mattias.Nilsson@s3.kth.se 13-Oct-2004

f = zeros(mask_size);
mx = (mask_size+1)/2;
my = mx;

for x = 1:mask_size,
    for y = 1:mask_size,
    f(x,y) = exp(-((x-mx)^2+(y-my)^2)/(2*sigma2))/(2*pi*sigma2);     
    end
end 
end 

