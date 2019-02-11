N=128; K=64; Ec=1; N0=2; %0dB SNR
initPC(N,K,Ec,N0);
u= (rand(K,1)>0.5);
disp(u);
x= pencode(u);
y= (2*x-1)*sqrt(Ec) + sqrt(N0/2)*randn(N,1);
global PCparams;
%y=[1.47586058727834;0.412232686444504;1.02260848430960;-1.04786941022021;2.70133465427496;-1.50971171276743;-1.00285496014432;1.91986707980640];
u_decoded= BPdecode(y);
info=false(K,1);
idx=1;
for i=1:N
    if PCparams.FZlookup(i) == -1
        info(idx)=u_decoded(i);
        idx=idx+1;
    end
end
%info_logical=(info>0.5);
correct=0;
for i=1:K
    if u(i)==info(i)
        correct=correct+1;
    end
end
disp(correct);