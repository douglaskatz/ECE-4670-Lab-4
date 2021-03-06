function tx = enc(bits)
kc = 200; % number of samples for channel to return to 0
gammak = 1; % peak amplitude for OOK
inputLength = length(bits); % how long each data block should be
% Training block X1[k] = gamma*exp(-jpi/2)
% for(n=1:dataLength)
%     X1(n) = -gammak*i;
%     
% end

% Modulate bits independently onto the real and imaginary parts of each
% sample to get X1.
for ind= 1:inputLength
   if(bits(ind) == 0)
       X1(ind) = 0;
   else
       X1(ind) = 1i*gammak;
   end
end

% Pad X1 with 0 at beginning for DC part and its conjugate at
% the end  
X0 = [0, X1, 0, fliplr(conj(X1))];

% Multiply by iDFT matrix to get x0.
%x0 = conj(dftmtx(length(X0)))/length(X0)*transpose(X0);
x0 = ifft(transpose(X0));
x0 = real(x0); % get rid of tiny imaginary parts

% Prepend cyclic prefix to get x which will be sent through the channel.
tx = [x0(mod(length(x0)-kc:length(x0)-1,length(x0))+1); x0];

%put all symbols together
wavwrite(tx, 96000, 24, 'tx.wav');
end