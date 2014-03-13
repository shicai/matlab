function w = sc_pa(X, label, w)

    [D, N] = size(X);
    if ~exist('w', 'var')
        w = 0.001 * randn(D, 1);
    end

    for i = 1 : N
        x = X(:, i);
        o = label(i);
        y = o * w' * x;
        e = max(0, 1 - y);
        t = e / (norm(x)^2);
        w = w + t * o * x; 
    end
end
