function [sig_out] = sys_filter_bank (coe, h0)
% coe is the vector of the wavelet coefficients (detail and approximation)
% h is the scaling vector in row form
% sig_ out is the output signal

    % find wavelet vector using slide 19
    h1 = zeros(1, length(h0));
    for i = 1:length(h0)
        h1(i) = (-1)^(i+1) * h0(length(h0) - i + 1);
    end

    % g1 and g0
    g0 = flip(h0);
    g1 = -flip(h1);

    % split coeff in half
    approx_in = coe(1:length(coe)/2);
    det_in = coe(length(coe)/2+1: end);

    % upsampling
    approx = zeros(1, 2*length(approx_in));
    det = zeros(1, 2*length(det_in));
    for i=1:length(approx_in)
        approx(2*i-1) = approx_in(i);
        det(2*i-1) = det_in(i);
    end

    sig_out_1 = conv(g0, approx);
    sig_out_2 = conv(g1, det);
    sig_out = sig_out_1 + sig_out_2;
    
end