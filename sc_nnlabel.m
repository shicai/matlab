function [precsion,lbmat,precsion2]=sc_nnlabel(labelTrain,labelTest,nnResult)
% INPUT:
%   labelTrain: ground truth for training samples
%   labelTest:  ground truth for testing samples
%   nnResult:   nxm nn assigned matrix, n neighbors for m samples
% OUTPUT:
%   precision:  classfication accuracy
%   lbmat:      nxm label matrix, n neighbors for m samples
% 
% % %
% (C) Shicai Yang, 2012
% Institute of Systems Engineering, Southeast University, Nanjing

lbmat=labelTrain(nnResult);
[n,m]=size(nnResult);
precsion=zeros(1,n);
precsion2=zeros(1,n);
for i=1:n
    rate=lbmat(i,:)-labelTest;
    pre=sum(rate==0)/length(labelTest);
    rate2=zeros(1,m);
    for j=1:m
        rate2(j)=sum(labelTest(j)==lbmat(1:i,j))~=0;
    end
    precsion(1,i)=sum(rate2)/length(labelTest);
    precsion2(1,i)=pre;
end
