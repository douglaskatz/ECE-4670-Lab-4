function tx = enc(bits)
kc = 0; % number of samples for channel to return to 0
gammak = 0; % peak amplitude for OOK
preLength = 0; % how long the cyclic prefix should be
dataLength = 0; % how long each data block should be

for n=1:100000/dataLength
    % Modulate bits independently onto the real and imaginary parts of each
    % sample to get X1.
    for i=n:n*dataLength
       if(bits(i) == 0)
           X1(i) = 0;
       else
           X1(i) = 1i*gammak;
       end
    end

    % Pad X1 with 0 at beginning for DC part and its hermetian conjugate at
    % the end
    X0 = [0, X1, X1'];
    
    % Multiply by iDFT matrix to get x0.
    x0 = dft(length(X1))'*X1;
    
    % Prepend cyclic prefix to get x which will be sent through the channel.
    x = [x0(dataLength-(kc):datalength), x0];
    % Add symbol to vector that will be transmitted and add guard band
    tx = [tx, x];
end
%put all symbols together
wavwrite(tx, 96000, 24, 'tx.wav');
end