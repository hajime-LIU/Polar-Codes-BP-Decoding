function initPC(N,K,Ec,N0,designSNRdB,silentflag) %designSNRdB optional
%
% This prepares the collection of all implicit parameters related to
% polar coding & SC decoding; to be used by all subsequent routines later.
%   (Including the memory resources to be used by the polar SC decoding)
%
%        Usage: initPC(N,K,Ec,N0,designSNRdB)
% 
%            N  -  Blocklength');
%            K  -  Message length (Rate = K/N)');
%            Ec -  the BPSK symbol energy (linear scale);
%            N0 (optional) -  Noise power spectral density (default N0/2 = 1) 
%                               (used for Monte-Carlo simulate etc)');
%            designSNRdB (optional) - the SNR at which the polar code construction (PCC) should be performed');
%                                      (As far as PCC is concerned, SNR=Ec/N0, by definition & defaults to "0dB")');
% 
%            silentflag (optional) - whether to print the last result or not
%                                       (defaults to 0)
% 
%        Note: This routine must be called, before we use any other utility around here.\n\n');
% 

if nargin==3 %Normalize noise-power-spectral-density, when not supplied: --- N0/2=1 (default)
    N0=2;
    designSNRdB=0;
    silentflag=0;
elseif nargin==4 
    designSNRdB=0;
    silentflag=0;
elseif nargin==5
    silentflag=0;
elseif (nargin<3 || nargin>6)
    fprintf('\n   Usage: initPC(N,K,Ec,N0,designSNRdB)\n');
    fprintf('\n       N  -  Blocklength');
    fprintf('\n       K  -  Message length (Rate = K/N)');
    fprintf('\n       Ec -  the BPSK symbol energy');
    fprintf('\n       N0 (optional) -  Noise power spectral density (default N0/2 = 1)');
    fprintf('\n                           (used for Monte-Carlo simulate etc)');
    fprintf('\n       designSNRdB (optional) - the SNR at which the polar code should be constructed');
    fprintf('\n                                 (Here, SNR=Ec/N0 - by definition for a PCC, defaults to "0dB")');
    fprintf('\n\n   Note: This routine must be called, before we use any other utility around here.\n\n');
    return;
end

addpath(genpath('./functions')); %All helping routines.

global PCparams;

PCparams = struct('N', N, ...
                  'K', K, ...
                  'n', 0, ...
                  'FZlookup', zeros(N,1), ...
                  'Ec', Ec, ...
                  'N0', N0, ...        %N0/2 =1 normalization
                  'LLR', zeros(1,2*N-1), ...
                  'BITS', zeros(2,N-1), ...
                  'designSNRdB', designSNRdB);

PCparams.n = log2(N);
PCparams.FZlookup = pcc(N,K,designSNRdB); %polar code construction at the given design-SNR (default 0dB)

if(~silentflag)
fprintf('\n All polar coding parameters/resources initialized. (in a structure - "PCparams") \n');
disp(PCparams);
end

end