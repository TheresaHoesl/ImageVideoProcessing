function [coe] = an_filter_bank (sig_in, h0)
% sig_ in is the input signal
% h0 is the scaling vector in row form
% coe is the vector of the wavelet coefficients containing first detail and
% then approximation

    % find wavelet vector using slide 19
    h1 = zeros(1, length(h0));
    buffer = h0;
    for n = 1:length(h0)
        h1(n) = (-1)^(n+1) * buffer(length(h0) - n + 1);
    end

    % prepare matrix H
    H = [h1' h0'];

    %split input in even and odd
    even = zeros(1, floor(length(sig_in)/2));
    odd = zeros(1, ceil(length(sig_in)/2));
    for i=1:length(sig_in)
        if mod(i,2) ~= 0
            odd(i/2+0.5) = sig_in(i);
        else 
            even(i/2) = sig_in(i);
        end
    end
    
    % merging even and odd in vector
    X = [even; odd];

    % calculation of output
    Y = H*X;

    
    % taking the needed values
    approx = zeros(length(h0)/2, length(odd)/2);
    for i = 1:length(h0)/2
        for j = 1:length(odd)/2
            approx(i, j) = Y(2*i-1, 2*j-1);
        end
    end
    
    % taking the needed values
    det = zeros(length(h0)/2, length(odd)/2);
    for i = 1:length(h0)/2
        for j = 1:length(odd)/2
            det(i, j) = Y(2*i, 2*j);
        end
    end

    approx = approx(:);
    det = det(:);
    coe = [approx; det];

    % coe = zeros(2, length(even));
    % for i = 1:length(even)
    %     for j = 1:length(h0)/2
    %         %approx
    %         coe(1, i) = coe (1, i) + Y(j, i);
    %         %det
    %         coe(2, i) = coe (2, i) + Y(j+4, i);
    %     end
    %     coe(1, i) = coe(1, i)/2;
    %     coe(2, i) = coe(2, i)/2;
    % end
    % coe = [coe(1, :)'; coe(2, :)'];

end
