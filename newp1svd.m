% Do a Poisson singular value decomposition with a constant column.
%   x: matrix to be analyzed
%   l: number of factors to find (incl the constant column)
%   iters: computation limit
%   startu, startv: starting point for optimization
% Returns u (with l columns) and v (with l rows) such that (x - exp(u*v))
% is small.  First column of u is constrained to be constant (which 
% implies that the first element of each column of v is a bias term which
% will be used to make sure that exp(u*v) has the same column sums that 
% x does).

% http://www.cs.cmu.edu/~ggordon/psvd/

%% Example
%% build a random matrix whose componentwise log has low rank
% uu = randn(10,4);
% vv = randn(4,100);
% x = exp(uu*vv*.1);

%% decompose it using EPCA and report error
% [u,v]=newp1svd(x,4,50);
% norm(x-exp(u*v))/norm(x)

function [u, v] = newp1svd(x, l, iters, startu, startv)


% starting point for optimization (can be overridden by args)
[n, d] = size(x);
u = randn(n, l)*1e-5/l;
v = randn(l, d)*1e-5/l;

% process input parameters
if (nargin < 3)
  iters = 50;
end
if (nargin >= 4)
  u = startu;
end
if (nargin >= 5)
  v = startv;
end

% first column of u is constant
unif = 1/n;
u(:,1) = unif * ones(n,1);


% this loop can be terminated early if convergence check is passed
converge = 1e-5;
for iter = 1:iters

  % save parameters for convergence check
  lastu = u;
  lastv = v;

  % Newton step to improve v as a predictor of x given u
  for i = 1:d

    % residual for i-th column of x
    expectx = exp(u*v(:,i));
    err = x(:,i) - expectx;

    % rescale residual by derivative of link (avoiding divide-by-zero)
    deriv = expectx;
    derivnz = deriv;
    derivnz(deriv == 0) = 1;
    adjx = u*v(:,i) + err ./ derivnz;

    % weighted regression (regularized in case v is underdetermined)
    wts = spdiags(deriv,0,n,n);
    covar = (u' * wts * u + 1e-8*speye(l));
    v(:,i) = covar \ (u' * wts * adjx);

  end

  % Newton step to improve u as a predictor of x given v
  for i = 1:n

    % residual for i-th row of x
    expectx = exp(u(i,:)*v);
    err = x(i,:) - expectx;

    % rescale residual by derivative of link (avoiding divide-by-zero)
    deriv = expectx;
    derivnz = deriv;
    derivnz(deriv == 0) = 1;
    adjx = u(i,:)*v + err ./ derivnz;

    % Weighted regression (regularized in case u is underdetermined). Note
    % that we modify our update to leave u(:,1) unchanged: the update for u
    % would have been the solution to the (weighted) normal equations 
    %   [u(i,:) * covar == adjx * wts * v']
    % but the constraint u(i,1)=const introduces a Lagrange multiplier that
    % lets us drop the first column of the normal equations.  (And the
    % first row goes away too since we just plug in the current value for
    % u(i,1).)
    wts = spdiags(deriv',0,d,d);
    covar = (v * wts * v' + 1e-8*speye(l));
    target = adjx * wts * v(2:end,:)' - u(i,1) * covar(1,2:end);
    u(i,2:end) = target / covar(2:end, 2:end);

  end
  
  % rescale so that u and v have comparable norm in corresponding
  % rows/columns -- this probably isn't necessary, but might help us from
  % getting accidental underflow on u or v, and makes the output look
  % pretty.
  usum = sum(abs(u),1);
  vsum = sum(abs(v),2);
  scale = sqrt(usum' ./ vsum);
  u = u .* repmat(1./scale', [n 1]);
  v = v .* repmat(scale, [1 d]);

  % check convergence
  curnorm = sum(sum(exp(u*v))) / numel(x);
  change = sum(sum(abs(exp(u*v)-exp(lastu*lastv)))) / numel(x);

  fprintf('%3d: %g %g\n', iter, curnorm, change);
  if (i > 1 && (change / (curnorm + converge) < converge))
    break;
  end

end

