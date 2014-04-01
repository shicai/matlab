function value = sc_sigmoid( x )
% SIGMOID sigmoid function for logistic regression
% 
%   f(x) = 1./ (1 + exp(-x))
% 
% % % 
% (C) Shicai Yang, 2012 - 2014. All rights reserved.
% Institute of Systems Engineering, Southeast University, Nanjing, China

value = 1./ (1 + exp(-x));

end
