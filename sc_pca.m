function [mapping] = sc_pca(X, num_dims)

% [PCA] Perform the Principle Component Analysis (PCA) algorithm
% 
%   [mapping] = sc_pca(X, num_dims)
% 
% X is an D-by-N matrix with N samples and D-dimensional features. 
% num_dims sets the number of dimensions of the feature points in the 
% embedded feature space.
% 
% For num_dims, you can specify a number between 0 and 1, determining 
% the amount of variance you want to retain in the PCA step. You can
% also specify a number, 1 < num_dims < 2, to keep all the eigenvectors
% and eigenvalues. The default is 1 + eps (float form of 100%), which
% keeps K-1 components (the K-th is meaningless, K = min(D, N)). 
% If num_dims = 1, it will only keep the first principle component.
% 
% The function returns the locations of the embedded trainingdata in 
% mapping.trainweight. Furthermore, it returns information in mapping.
% % % 
% (C) Shicai Yang, 2012 - 2014. All rights reserved.
% Institute of Systems Engineering, Southeast University, Nanjing, China

    [d, n] = size(X);
    if ~exist('num_dims', 'var')
        num_dims = 1.0 + eps;              % keep all the eigenvectors and eigenvalues for mapping
    end

    % Make sure data is zero mean
    mapping.mean = mean(X, 2);
    X = bsxfun(@minus, X, mapping.mean);   % remove mean

    % Compute covariance matrix
    if d <= n
        C = cov(X');                       % if D <= N
    else
        C = (1 / (n-1)) * (X' * X);        % if D >  N, we better use this matrix for the eigendecomposition
    end

    % Perform eigendecomposition of C
    C(isnan(C)) = 0;
    C(isinf(C)) = 0;
    [U, S]      = eig(C);

    % Sort eigenvectors in descending order
    [S, ind]    = sort(diag(S), 'descend');
    
    if num_dims < 1
        num_dims = find(cumsum(S ./ sum(S)) >= num_dims, 1, 'first');
        fprintf('PCA Embedding into %d dimensions.\n', num_dims);
    end
    if num_dims > 1.0 && num_dims < 2.0
        num_dims = size(U, 2) - 1;
        fprintf('PCA Embedding into %d dimensions.\n', num_dims);
    end
    if num_dims > size(U, 2)
        num_dims = size(U, 2) - 1;
        warning('Target dimensionality reduced to %d.\n', num_dims);
    end
    
    num_dims = floor(num_dims);
    U        = U(:, ind(1:num_dims));
    S        = S(1:num_dims);

    % normalize in order to get eigenvectors of covariance matrix
    if ~(d <= n)
        U = bsxfun(@times, X * U, (1 ./ sqrt((n - 1) .* S))');
    end
    
    % Store information for out-of-sample extension
    mapping.vecs        = U;            % eigen vectors
    mapping.vals        = S;            % eigen values
    mapping.dims        = num_dims;     % dimension kept
    mapping.trainweight = U' * X;       % representation in the pca subspace
end % end of the function
