function W=demo_pa()
% Demo for Online Passive Aggressive Algorithms
% Reference:   K. Crammer, et al. Online Passive-Aggressive Algorithms, JMLR, 2006.
% Written by:  Shicai Yang (April 10, 2014)

    clear all; close all; clc;
    
    % set parameters
    N = 300;  % Number of samples for both classes
    type = 2; % PA-II, if linearly separatable, just use PA-I (set type=1)
    C = 10;   % Aggressiveness parameter

    % generate data
    mu0 = [0 0];
    mu1 = [5 5];
    sigma0 = [1 0; 0 1];
    sigma1 = [1 .5; 0.5 1];
    r0 = mvnrnd(mu0, sigma0, N); % 2D postive samples
    r1 = mvnrnd(mu1, sigma1, N); % 2D negtive samples
    lb0 = -1 * ones(1, N);       % postive labels
    lb1 = +1 * ones(1, N);       % negtive labels

    % plot data truth
    figure; subplot(1, 2, 1);
    plot(r0(:,1), r0(:,2), 'ro');
    hold on;
    plot(r1(:,1), r1(:,2), 'bx');
    axis([-3 8 -3 8]);
    xlabel('X');ylabel('Y');title('Data Truth');

    % randomly shuffle
    X = [r0; r1]';
    lb = [lb0, lb1];
    idx = randperm(2*N);
    X = [ones(1, 2*N);X(:, idx)];
    lb = lb(idx);

    W = cell(1, 2*N); % to save all the weights
    w = [0; 0; 0];    % initialize weight
    subplot(1, 2, 2);
    
    % online learning
    for i=1: 2*N    
        x = X(:, i);
        w = sc_pa(x, lb(i), type, w, C);

        plot(x(2), x(3), 'r.');
        if mod(i,10) == 0
            disp(i);
            sc_line(w, 'g-');    
        end;
        axis([-3 8 -3 8]);
        hold on;
        drawnow;

        W{i} = w;
    end
    sc_line(w, 'b-');
    xlabel('X');ylabel('Y');
    title('PA-II for Binary Classfication, C=10');
    
    W =cat(2, W{:});
end

% Plot Lines
function sc_line(w, type)
    b = w(1);
    w1 = w(2);
    w2 = w(3);
    x = linspace(-15, 15, 2);
    y = (- b - w1 .* x ) ./ w2;
    h = plot(x, y , type); 
    set(h, 'erasemode', 'none');
    hold on;
end

function w = sc_pa(X, label, type, w, C)
% Passive Aggressive Algorithms
%     X: Data, Dim x Num
%     label: ground truth
%     type: 1, 2, 3 for PA-I/PA-II/PA-III algorithm
%     w: initial weight, or previously learned weight
%     C: aggressiveness parameter for PA-II or PA-III

    [D, N] = size(X);
    
    if ~exist('type', 'var')
        type = 1;
    end    
    if ~exist('w', 'var')
        w = 0.001 * randn(D, 1);
    end    
    if ~exist('C', 'var')
        C = 1;
    end

    for i = 1 : N
        x = X(:, i);
        y = label(i);
        loss = max(0, 1 - y * w' * x);
        
        % select update rule
        switch type
            case 1 % hard margin
                tau = loss ./ (norm(x)^2);
            case 2 % soft margin
                tau = min(C, loss ./ (norm(x)^2));
            case 3 % soft margin
                tau = loss ./ (norm(x)^2 + 1 / (2 * C));
            otherwise
                tau = loss ./ (norm(x)^2);
        end        
        w = w + tau * y * x; % update weight
    end
end
