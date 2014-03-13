function w = sc_perceptron(X, label, w, alpha)

    [D, N] = size(X);
    if ~exist('w', 'var')
        w = 0.001 * randn(D, 1);
    end

    if ~exist('alpha', 'var')
        alpha = 1;
    end

    for i = 1 : N
        x = X(:, i);
        o = label(i);
        y = f(w' * x);
        w = w + alpha * (o - y) * x; 
    end
end

function y = f(x)
    y = (x > 0);
end
