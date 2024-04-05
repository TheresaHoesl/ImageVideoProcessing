clear; close all;

%% trial
% different scale vectors
load('coeffs.mat');

sig =  [1; 4; -3; 0];

% create periodic signal
signal = [sig; sig; sig];


% filtering
test_coeff = an_filter_bank_conv(signal, haar);
test_signal = sys_filter_bank_conv(test_coeff, haar);


%% 2. Filtering Harbour

clear; close all;

daubechies = [-0.00011747678400228192
0.0006754494059985568
-0.0003917403729959771
-0.00487035299301066
0.008746094047015655
0.013981027917015516
-0.04408825393106472
-0.01736930100202211
0.128747426620186
0.00047248457399797254
-0.2840155429624281
-0.015829105256023893
0.5853546836548691
0.6756307362980128
0.3128715909144659
0.05441584224308161
];

image = imread("harbour512x512.tif");

% making vector out of matrix + create periodic signal
harbour = [image(:); image(:); image(:)];


% allocation for efficiency
signal_rec = uint8(zeros(1,length(harbour)));
harbour_rec = uint8(zeros(512));

% filtering
harbour_coeff = an_filter_bank_conv(harbour, daubechies);
harbour_signal = uint8(sys_filter_bank_conv(harbour_coeff, daubechies));

harbour_signal = harbour_signal(length(image(:))+length(daubechies)-1: 2*length(image(:))+length(daubechies)-2);
% making matrix out of vector
for i=1:512
    buffer = harbour_signal(1+(i-1)*512:i*512);
    harbour_rec(i,:) = buffer;
end

% turning image by 90 degree
harbour_rec = harbour_rec';

% checking for perf reconstruction
error = image(:) - harbour_rec(:);
sum = 0;
for i=1:length(error)
    sum = sum + error(i);
end

figure(1)
imshow(harbour_rec);

%% filtering harbour scale 4

close all;

input = harbour;

% filtering
for m=1:4
    coeffs = an_filter_bank_conv(input, daubechies);
    % split coeffs into approx and det
    approx = coeffs(1:length(coeffs)/2);
    det = coeffs(length(coeffs)/2+1: end);
    if m==1
        det_1 = det;
    elseif m==2
        det_2 = det;
    elseif m==3
        det_3 = det;
    else
        det_4 = det;
    end
    input = approx;
end

% plot wavelet coeffs
% cutting for just one image as input instead of three

% @ Tsin Yu: those are your coefficients
approx_plot = approx(length(approx)/3+1:2*length(approx)/3);
det_plot = det(length(det)/3+1:2*length(det)/3);
n = linspace(1, length(approx)/3, length(approx)/3);
% approx
figure(2)
plot(n, approx_plot);
axis([1 16384 0 1000]);
title('Approximation coefficients after filtering with scale 4');
xlabel('n');
% det
figure(3)
plot(n, det_plot);
axis([1 16384 -250 250]);
title('Detail coefficients after filtering with scale 4');
xlabel('n');

% reconstruction
for m=1:4
    if m==1
        input = [approx; det_4];
    elseif m==2
        approx = output(length(daubechies)-1 : length(det_3)+length(daubechies)-2)';
        input = [approx; det_3];
    elseif m==3
        approx = output(length(daubechies)-1 : length(det_2)+length(daubechies)-2)';
        input = [approx; det_2];
    else
        approx = output(length(daubechies)-1 : length(det_1)+length(daubechies)-2)';
        input = [approx; det_1];
    end
    output = sys_filter_bank_conv(input, daubechies);
end

signal_out = uint8(output(length(image(:))+length(daubechies)-1: 2*length(image(:))+length(daubechies)-2));


harbour_rec = uint8(zeros(512));
% making matrix out of vector
for i=1:512
    buffer = signal_out(1+(i-1)*512:i*512);
    harbour_rec(i,:) = buffer;
end


% turning image by 90 degree
harbour_rec = harbour_rec';

figure(5)
imshow(harbour_rec);







