function u_decoded=BPdecode(y)
    global PCparams;
    N = size(y);
    N = N(1);
    n = log2(N);
    
    %initialization LHS. frozen=0->infinity, frozen=1->-infinity, message->0
    factor_graph_L = ones(N,n+1);
%     for i=1:N
%         if PCparams.FZlookup(i) == 0
%             factor_graph_L(i,1)=realmax;
%         elseif PCparams.FZlookup(i) == 1
%             factor_graph_L(i,1)=realmin;
%         else
%             factor_graph_L(i,1)=0;
%         end
%     end
    %initialization RHS with y
    for i=1:N
        factor_graph_L(i,n+1)=-(4*sqrt(PCparams.Ec)/PCparams.N0)*y(i);
    end
    
    %initialization LHS. frozen=0->infinity, frozen=1->-infinity, message->0
    factor_graph_R = realmax*ones(N,n+1);
    for i=1:N
        if PCparams.FZlookup(i) == 0
            factor_graph_R(i,1)=realmax;
        elseif PCparams.FZlookup(i) == 1
            factor_graph_R(i,1)=realmin;
        else
            factor_graph_R(i,1)=0;
        end
    end
    %initialization RHS with y
%     for i=1:N
%         factor_graph_R(i,n+1)=y(i);
%     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Starting iteration
    %%%%%%%%%%%%%%%%%%%%%%%s%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    num_itert=N;%set number of iteration to be N
    for i=1:num_itert
        %new_factor_graph_L=factor_graph_L;
        %new_factor_graph_R=factor_graph_R;
        %acts as a register(?) for the factor graph. All modifications are
        %made in new_factor_graph and factor_graph is read-only
        for j=1:n %iteration from left most column to right most column
            number_per_block=N/(2^j);
            number_of_blocks=N/number_per_block/2;
            for k=1:number_of_blocks
                for L=1:number_per_block
                    col_1=j;
                    col_2=col_1+1;
                    row_1=(k-1)*number_per_block*2+L;
                    row_2=row_1+number_per_block;
                    %if j~=n+1
                    factor_graph_L(row_1,col_1)=...
                     BP_xor_function(factor_graph_L(row_2,col_2)+factor_graph_R(row_2,col_1),factor_graph_L(row_1,col_2));
                    factor_graph_L(row_2,col_1)=...
                     BP_xor_function(factor_graph_R(row_1,col_1),factor_graph_L(row_1,col_2))+factor_graph_L(row_2,col_2);
                    %end
                end
            end
            
            j2=n+1-j;
            number_per_block=N/(2^j2);
            number_of_blocks=N/number_per_block/2;
            for k=1:number_of_blocks
                for L=1:number_per_block
                    col_1=j2;
                    col_2=col_1+1;
                    row_1=(k-1)*number_per_block*2+L;
                    row_2=row_1+number_per_block;
                    
                    %if j~=1
                    factor_graph_R(row_1,col_2)=...
                     BP_xor_function(factor_graph_L(row_2,col_2)+factor_graph_R(row_2,col_1),factor_graph_R(row_1,col_1));
                    factor_graph_R(row_2,col_2)=...
                     BP_xor_function(factor_graph_R(row_1,col_1),factor_graph_L(row_1,col_2))+factor_graph_R(row_2,col_1);
                    %end
                end
            end
        end
        
%         for j=1:n %iteration from left most column to right most column
%             number_per_block=N/(2^j);
%             number_of_blocks=N/number_per_block/2;
%             for k=1:number_of_blocks
%                 for L=1:number_per_block
%                     col_1=j;
%                     col_2=col_1+1;
%                     row_1=(k-1)*number_per_block*2+L;
%                     row_2=row_1+number_per_block;
%                     
%                     %if j~=1
%                     factor_graph_R(row_1,col_2)=...
%                      BP_xor_function(factor_graph_L(row_2,col_2)+factor_graph_R(row_2,col_1),factor_graph_R(row_1,col_1));
%                     factor_graph_R(row_2,col_2)=...
%                      BP_xor_function(factor_graph_R(row_1,col_1),factor_graph_L(row_1,col_2))+factor_graph_R(row_2,col_1);
%                     %end
%                 end
%             end
%         end
        
        %factor_graph_L=new_factor_graph_L;
        %factor_graph_R=new_factor_graph_R;
        %copy all the values
    end
    %print('finish');
    u_decoded=(factor_graph_L(:,1)<=0);
    %u_decoded=~(0.5*(sign(factor_graph_L(:,1)+factor_graph_R(:,1))+1));
end