% Given a Poisson singular value decomposition, project some new vectors
% onto it.
%   x: vectors to be projected
%   u: from Poisson SVD u*v
%   iters: computation limit
%   start: starting point for y
% Returns y such that u*y is close to log(x).

%% Example 
% vhat = newpproject(x, u);

function y = newpproject(x, u, iters, start);

% starting point for optimization
[n, d] = size(x);
[n, l] = size(u);
y = randn(l,d) / sum(sum(abs(u)));

% process input parameters
if (nargin < 3)
  iters = 50;
end
if (nargin >= 4)
  y = start;
end

% this loop can be terminated early if convergence check is passed
converge = 1e-5;
for iter = 1:iters

  % save parameters for convergence check
  lasty = y;

  % Newton step to improve y as a predictor of x given u
  for i = 1:d

    % residual for i-th column of x
    linpred = u*y(:,i);
    expectx = exp(linpred);
    err = x(:,i) - expectx;

    % rescale residual by derivative of link
    adjx = linpred;
    mask = (expectx > 0);
    adjx(mask) = linpred(mask) + err(mask) ./ expectx(mask);

    % weighted regression (regularized in case v is underdetermined)
    uwts = repmat(expectx, [1 l]) .* u;
    y(:,i) = (u' * uwts + 1e-15*speye(l)) \ (uwts' * adjx);

  end

  % check convergence
  % TODO: should probably check for convergence of expectx instead of y
  curnorm = sum(sum(abs(y))) / prod(size(y));
  change = sum(sum(abs(y - lasty))) / prod(size(y));
%  fprintf('%3d: %g\n', iter, change);
  if (change / (curnorm + converge) < converge)
%  fprintf('converged %d\n', iter);
    break;
  end

end
