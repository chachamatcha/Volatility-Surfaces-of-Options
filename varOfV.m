%% Variance given Q2 and Q3
%Calculate the variance for a portfolio existing of two options and a
%stock. Will return a length(Q)xlength(Q) matrix of variances.
function varOfV = varOfV(Q1,Q2,S,C1,C2)
    varOfV=[];
    varOfV=gpuArray(varOfV);
    for i = 1:length(Q1)
        for k = 1:length(Q1)
            V=S+Q1(i)*C1+Q2(k)*C2;
            varOfV(i,k) = var(V);
        end
        i
    end
end