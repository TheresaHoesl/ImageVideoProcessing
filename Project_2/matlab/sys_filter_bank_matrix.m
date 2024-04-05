function [sig_out] = sys_filter_bank (coe, h0)
% coe is the vector of the wavelet coefficients (detail and approximation)
% h is the scaling vector in row form
% sig_ out is the output signal


    % find wavelet vector
    h1 = zeros(1, length(h0));
    buffer = h0;
    for n = 1:length(h0)
        h1(n) = (-1)^(n+1) * buffer(length(h0) - n + 1);
    end

    % prepare matrix H
    H = [h1' h0'];

    % prepare matrix Y out of coe
    % columns = length(coe)/length(h0);
    % for i=1:columns
    %     for j=1:length(h0)
    %         Y(j,i) = coe(length(h0)*(i-1)+j);
    %     end
    % end

    % split code in half
    approx = coe(1:length(coe)/2);
    det = coe(length(coe)/2+1: end);
    % Y = zeros(length(h0), length(coe)/2);
    % for i=1:length(coe)/2
    %     for j=1:4
    %         Y(j,i) = approx(i);
    %         Y(j+4,i) = det(i);
    %     end
    % end

    % rebuild Y
    columns = length(approx)/(length(h0)/2);
    Y = zeros(length(h0), columns*2);
    for i=1:columns
         for j=1:length(h0)/2
             Y(2*j-1,2*i-1) = approx(length(h0)/2*(i-1)+j)*2;
             Y(2*j,2*i) = det(length(h0)/2*(i-1)+j)*2;
         end
    end

    image = uint8(Y);
    imshow(image);

    % calculation of output
    X = H\Y;
    
    % % prep of even and odd
    % even = zeros(1, columns);
    % odd = zeros(1, columns);
    % 
    % split output in even and odd
    even = X(1,:);
    odd = X(2,:);

    % merging even and odd to signal
    sig_out = zeros(length(even)+length(odd),1);
    for i=1:length(sig_out)
        if mod(i,2) ~= 0
            sig_out(i) = odd(i/2 + 0.5);
        else 
            sig_out(i) = even(i/2);
        end
    end

end