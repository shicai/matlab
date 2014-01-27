function pcatest=sc_pcatest(testcol, pcatrain)

% PCA Perform the test data of PCA algorithm
%
%   [pcatest] = sc_pcatest(testcol, pcatrain)
%
% testcol is an D-by-N matrix with N samples and D-dimensional features. 
% 
% The function returns information in pcatest.
% % % 
% (C) Shicai Yang, 2012 - 2014. All rights reserved.
% Institute of Systems Engineering, Southeast University, Nanjing, China

testplusmean  = bsxfun(@minus, testcol, pcatrain.mean);
pcatest.test  = pcatrain.vecs' * testplusmean;
pcatest.train = pcatrain.trainweight;
