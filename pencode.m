function d=pencode(u)
% PCparams structure is implicit parameter
%
% Encode 'K' message bits in 'u' and
% Return 'N' encoded bits in 'x'
%
% Polar coding parameters (N,K,FZlookup,Ec,N0,LLR,BITS) are taken
% from "PCparams" structure FZlookup is a vector, to lookup each integer
% index 1:N and check if it is a message-bit location or frozen-bit location.
%
% FZlookup(i)==0 or 1 ==> bit-i is a frozenbit
% FZlookup(i)==-1 ==> bit-i is a messagebit

global PCparams;

% Actual logic:
% d(PCparams.FZlookup == -1) = u; %Dimensions should match. Otherwise ERRR here.
% 
% d(PCparams.FZlookup ~= -1) = PCparams(PCparams.FZlookup==-1);
%
% Replaced, better logic:
  d = PCparams.FZlookup; %loads all frozenbits, incl. -1
  d(PCparams.FZlookup == -1) = u; % -1's will get replaced by message bits below

n=PCparams.n;

for i=1:n
    B = 2^(n-i+1);
    nB = 2^(i-1);
    for j=1:nB
        base = (j-1)*B;
        for l=1:B/2
            d(base+l) = mod( d(base+l)+d(base+B/2+l), 2 );
        end
    end
end

%returns d itself
end