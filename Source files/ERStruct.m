function K = ERStruct(n, path, filename, rep, alpha, Kc, core_num)
%% (Main program) Compute the estimated number of top informative PCs

%% Data files requirements
% Data files must be of .mat format. The data matrix must with 0,1,2 and
% NaN (for missing values) entries only, the rows represent indivials and 
% columns represent markers. If there are more than one data files, the
% data matrix inside must with the same number of rows. (Try spliting the
% data files into smaller ones if out of memory error occures)

%% Arguments
% n           Total number of individuals in the study
% path        The path of data file(s)
% filename    The name of the data file(s), can be either a string or a
%                 string array. Extension name (i.e., '.mat') should be 
%                 omitted
% rep         Number of simulation times for the null distribution
% alpha       Significance level, can be either a scaler or a vector
% Kc          A coarse estimate of the top PCs number (set to `floor(n/10)`
%                 by default)
% core_num    Optional, number of CPU cores to be used for 
%                 parallel computing. 

%% Return 
% K           Estimated number of top PCs

%% Examples
% Using example data files inside the toolbox folder
% ERStruct(2504, '.', ["test_chr21","test_chr22"], 5000, 1e-4)

%% Program
if nargin == 5
    Kc = floor(n/10);
    core_num = 1;
elseif nargin == 6
    core_num = 1;
elseif core_num == 0
    core_num = 1;
end

[eigens,p] = Eigens(n, path, filename, core_num);
GOE_L12_dist = GOE_L12_sim(n, rep, core_num);
if core_num > 1
    delete(gcp('nocreate'));
end

disp('Testing...')

K = 0;
K_hat = 0;
n_prime = n;
stats = [0; eigens(2:end-1) ./ eigens(1:end-2)];
xi_GOE_s = zeros(1, Kc);

while K < Kc
    K = K + 1;
    n_prime = n_prime - 1;
    
    a_p_hat = sum(eigens(K:end-1)) / n_prime;
    b_p_hat = p/n_prime * (sum(eigens(K:end-1).^2) / n_prime - a_p_hat^2);

    xi_GOE_rep = (GOE_L12_dist(2,:) * sqrt(b_p_hat / p) + a_p_hat) ./ ...
            (GOE_L12_dist(1,:) * sqrt(b_p_hat / p) + a_p_hat);
    xi_GOE_rep = sort(xi_GOE_rep);
    xi_GOE_s(K) = xi_GOE_rep(ceil(length(xi_GOE_rep)*alpha)); 
    
    if K_hat == 0 && stats(K+1) > xi_GOE_s(K) % jump above threshold
        K_hat = K;
    elseif K_hat ~= 0 && stats(K+1) <= xi_GOE_s(K_hat) % fake K_hat
        K_hat = 0;
    end
end

% if output K_hat == 0, then show error message
if K_hat == 0
    error('Cannot find valid K_hat <= Kc')
end
