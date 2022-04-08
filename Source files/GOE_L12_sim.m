function GOE_L12_dist = GOE_L12_sim(n, rep, core_num)
%% Similate the distributions of the top 2 eigenvaules of GOE metrics

%% Program
disp('Simulating null distribution for testing...')
nprime = n-1; % adjust because of centerlization
GOE_L12_dist = zeros(2,rep); % contains L1 and L2

if core_num > 1
    parpool(core_num);
    parfor i = 1:rep
        main = sqrt(2) * randn(1,nprime);
        off = randn(nprime);
        W_n = tril(off,-1) + triu(off',1);
        W_n(logical(eye(nprime))) = main;

        w = sort(eig(W_n), 'descend');
        GOE_L12_dist(:,i) = w(1:2);
    end
else
    for i = 1:rep
        main = sqrt(2) * randn(1,nprime);
        off = randn(nprime);
        W_n = tril(off,-1) + triu(off',1);
        W_n(logical(eye(nprime))) = main;

        w = sort(eig(W_n), 'descend');
        GOE_L12_dist(:,i) = w(1:2);
    end
end

GOE_L12_dist = sort(GOE_L12_dist, 'descend');
