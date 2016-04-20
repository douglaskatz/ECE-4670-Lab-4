function rx = dec()
    received = wavread('tx.wav');
    
    kc = 200; % number of samples for channel to return to 0
    gammak = 1; % peak amplitude for OO
    encodedLength = 100000; % amount of bits that were encoded
    avgWindow = 0 % A window for averaging in order to determine L1 and L2
    sentDataLength = encodedLength*2+2; % length of received data - prefix
    
    % determine start of signal (L1) and end of signal (L2)
    
    % learn channel from first block to get lambda
    
    L1 = 1
    TXdata = received(L1:L1+sentDataLength+kc-1);
    % Drop cyclic prefix to get and separate data into blocks to get y
    y=TXdata(kc+1:end);
    
    % Multiply by DFT to get Y
    Y = fft(y);
    
    % Drop DC components and conjugate to get Y1
    Y1 = Y(1:encodedLength+1);
    Y1 = Y1(2:end);
    
    % Use lambda to find threasholds
    gain = ones(encodedLength,1);
    % Decode using MAP/ML rule to get bits
    for ind=1:encodedLength
        if(imag(Y1(ind)) >= (gain(ind)*gammak)/2)
            rx(ind) = 1;
        else
            rx(ind) = 0;
        end
    end
    rx = rx';
end