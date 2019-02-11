function f=BP_xor_function(L1,L2)
    %precise equation
    %f=log((1+L1*L2)/(L1+L2));
    
    %approximate
    f=sign(L1)*sign(L2)*min(abs(L1),abs(L2));
    %disp(['f(',L1,L2,') = ',f]);
end