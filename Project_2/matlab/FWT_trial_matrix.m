clear; close all;

%% trial
% different scale vectors
load('coeffs.mat');
scale = [0.32580343; 1.01094572; 0.8922014; -0.03967503; -0.26450717; 
    0.0436163; 0.0465036; -0.01498699]';

sig =  [1; 4; -3; 0];

% create periodic signal
signal = [sig; sig; sig];


% filtering
test_coeff = an_filter_bank(signal, scale);
test_signal = sys_filter_bank(test_coeff, scale);

error = signal - test_signal;

%% 2. Filtering Harbour

clear; close all;

% scale vector in row form
daubechies = [0.32580343; 1.01094572; 0.8922014; -0.03967503; -0.26450717; 
    0.0436163; 0.0465036; -0.01498699]';

image = imread("harbour512x512.tif");

% making vector out of matrix + create periodic signal
harbour = [image(:); image(:); image(:)];


% allocation for efficiency
signal_rec = uint8(zeros(1,length(harbour)));
harbour_rec = uint8(zeros(512));

% filtering
harbour_coeff = an_filter_bank(harbour, daubechies);
harbour_signal = sys_filter_bank(harbour_coeff, daubechies);


% making matrix out of vector
for i=1:512
    buffer = harbour_signal(1+(i-1)*512:i*512);
    harbour_rec(i,:) = buffer;
end

% turning image by 90 degree
harbour_rec = harbour_rec';

imshow(harbour_rec);

%% filtering harbour scale 4


clear; close all;

% scale vector in row form
daubechies = [0.32580343; 1.01094572; 0.8922014; -0.03967503; -0.26450717; 
    0.0436163; 0.0465036; -0.01498699]';

image = imread("harbour512x512.tif");

% making vector out of matrix + create periodic signal
harbour = [image(:)];

% filtering
for m=1:4
    harbour = an_filter_bank(harbour, daubechies);
end

% obtaining the coefficients
approx = harbour(1: length(harbour)/2);
det = harbour(length(harbour)/2+1:end);
 
% % plot
% n = linspace(1, length(harbour)/2, length(harbour)/2);
% figure(1)
% plot(n,approx)
% title('Approximation coefficients of harbour', 'FontSize', 11);
% xlabel('n')
% ylabel('y0')
% 
% figure(2)
% plot(n, det)
% title('Detail coefficients of harbour', 'FontSize', 11);
% xlabel('n')
% ylabel('y1')


for m=1:4
    harbour = sys_filter_bank(harbour, daubechies);
end

signal_out = uint8(harbour);


harbour_rec = uint8(zeros(512));
% making matrix out of vector
for i=1:512
    buffer = signal_out(1+(i-1)*512:i*512);
    harbour_rec(i,:) = buffer;
end


% turning image by 90 degree
harbour_rec = harbour_rec';

imshow(harbour_rec);







