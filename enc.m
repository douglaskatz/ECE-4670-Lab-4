function tx = enc(bits)
kc = 0; % number of samples for channel to return to 0
gammak = 1; % peak amplitude for OOK
dataLength = 10; % how long each data block should be
tx=[];
% Training block X1[k] = gamma*exp(-jpi/2)
% for(n=1:dataLength)
%     X1(n) = -gammak*i;
%     
% end

for n=1:100/dataLength
    % Modulate bits independently onto the real and imaginary parts of each
    % sample to get X1.
    tail = 1;
    for ind= ((n-1)*dataLength)+1:n*dataLength
       
       if(bits(ind) == 0)
           X1(tail) = 0;
       else
           X1(tail) = i*gammak;
       end
       tail = tail + 1;
    end

    % Pad X1 with 0 at beginning for DC part and its hermetian conjugate at
    % the end
    
    X0 = [0, X1, fliplr(conj(X1))];
    
    % Multiply by iDFT matrix to get x0.
    x0 = dftmtx(length(X0))'*transpose(X0);
    
    % Prepend cyclic prefix to get x which will be sent through the channel.
    x = [x0(dataLength-(kc):dataLength); x0];
    % Add symbol to vector that will be transmitted and add guard band
    tx = [tx; x];
end
%put all symbols together
%wavwrite(tx, 96000, 24, 'tx.wav');
end