function rx = dec(received)
    %received = wavread(rx.wav,96000,24);
    
    kc = 2; % number of samples for channel to return to 0
    gammak = 0; % peak amplitude for OOK
    preLength = 0; % how long the cyclic prefix should be
    dataLength = 4; % how long each data block should be
    avgWindow = 0 % A window for averaging in order to determine L1 and L2
    totalData = 36; % Total length of data L1 - L2
    sentDataLength = dataLength*2+1;
   
    
    % determine start of signal (L1) and end of signal (L2)
%     m=1;
%     avg = 0;
%     for n=1:avgWindow
%        avg = avg + received(m); 
%     end
%     while(avg < gammak) % m should be equal to L1 after this loop
%             avg = avg + received(avgWindow + m) - received(m);
%             m=m+1;     
%     end
%     L1 = m;
%     
%     m=length(received);
%     avg = 0;
%     for n=1:avgWindow
%        avg = avg + received(m); 
%     end
%     while(avg < gammak)
%         avg = avg + received(m-avgWindow) - received(m);
%         m=m-1;
%     end
    
    data(1:totalData/sentDataLength) = 0;
    
    % learn channel from first block to get lambda
    
    % decode message
    % Drop cyclic prefix to get and separate data into blocks y
    for block=1:totalData/sentDataLength
        for ind=1:sentDataLength+kc
            z(ind) = received(ind+(block-1)*(sentDataLength+kc));
          
        end
        x = z(kc+1:end);
        for ind2=1:sentDataLength
            data(block,ind2) = x(ind2);
        end
        % multiply by DFT to get Y
        [rows,columns] = size(data);
        Y = dftmtx(rows)*data(block);
        
        disp('dft');
        disp(dftmtx(rows));
        
        disp('data(block)');
        disp(data(block));
        
        disp('Y');
        disp(Y);
        % Get rid of conjugate part of signal to get Y1
        Y1 = Y(2:dataLength);
        % Multiply by obtained lamda

        % Decode using MAP/ML rule to get bits
        for ind3=1:dataLength
            if(Y1(ind3) > (gammak*i)/2)
                rx((block-1)*dataLength+ind3) = 1;
            else
                rx((block-1)*dataLength+ind3) = 0;
            end
        end
    end
end