function [eigens,p] = Eigens(n, path, filename, core_num)
%% From raw data matrix to ordered eigenvalues (descend)

%% Program
path = char(path);
filename = string(filename);
p = 0;
X = zeros(n);

if length(filename) > 1 && core_num > 1
    parpool(core_num);
    parfor i = 1:length(filename)
        disp(['Processing file ', num2str(i), '...'])
        C_struct = load([path, '\', char(filename(i)), '.mat']);
        C = getfield(C_struct, filename(i));
        C_struct = [];

        % centerlize and scale
        mu = mean(C, 1, 'omitnan');
        q = (sum(C, 1, 'omitnan') + 1) / (2*n + 2);
        M = (C - mu) ./ sqrt(2*q.*(1-q));
        C = [];

        % replace initial missing data and the NaN caused by deviding 0 mean
        M = fillmissing(M,'constant',0); 

        p_i = length(M);
        X = X + M*M';
        M = [];
        p = p + p_i;
    end

    X = 1/p * X;
    eigens = sort(eig(X),'descend');    
else
    for i = 1:length(filename)
        disp(['Processing file ', num2str(i), '...'])
        C_struct = load([path, '\', char(filename(i)), '.mat']);
        C = getfield(C_struct, char(filename(i)));
        C_struct = [];

        % centerlize and scale
        mu = mean(C, 1, 'omitnan');
        q = (sum(C, 1, 'omitnan') + 1) / (2*n + 2);
        M = (C - mu) ./ sqrt(2*q.*(1-q));
        C = [];

        % replace initial missing data and the NaN caused by deviding 0 mean
        M = fillmissing(M,'constant',0); 

        p_i = length(M);
        X = X + M*M';
        M = [];
        p = p + p_i;
    end

    X = 1/p * X;
    eigens = sort(eig(X),'descend');
end