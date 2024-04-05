function [coe] = an_filter_bank (sig_in, h0)
% sig_ in is the input signal
% h0 is the scaling vector in row form
% coe is the vector of the wavelet coefficients containing first detail and
% then approximation

    % find wavelet vector using slide 19
    h1 = zeros(1, length(h0));
    for i = 1:length(h0)
        h1(i) = (-1)^(i) * h0(length(h0) - i + 1);
    end

    % filtering
    approx_full = conv(h0, sig_in);
    det_full = conv(h1, sig_in);

    % truncating
    approx_full = approx_full(1:length(sig_in));
    det_full = det_full(1:length(sig_in));
    
    approx = zeros(1, length(sig_in)/2);
    det = zeros(1, length(sig_in)/2);

    % downsampling
    for i=1:(length(sig_in)/2)
        approx(i) = approx_full(2*i);
        det(i) = det_full(2*i);
    end

    approx = approx(:);
    det = det(:);
    coe = [approx; det];

end
