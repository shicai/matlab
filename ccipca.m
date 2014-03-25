function [V, D, n]=ccipca(X,k,iteration,oldV, access)

%CCIPCA --- Candid Covariance-free Increment Principal Component Analysis
%[V,D]=ccipca(X)  ,Batch mode: take input matrix return the eigenvector 
%matrix
%[V,D]=ccipca(X,k) , Batch mode: take input matrix and number of
%eigenvector and return the eigenvector and eigenvalue
%[V,D]=ccipca(X,k,iteration,oldV,access) , Incremental mode: Take input matirx and
%number of eigenvector and number of iteration, and the old eigenvector
%matrix, return the eigenvector and eigenvalue matrix
%
%[V,D]=ccipca(...) return both the eigenvector and eigenvalue matrix
%V=ccipca(...) return only the eigenvector matrix
%Algorithm

%ARGUMENTS:
%INPUT
%X --- Sample matrix, samples are column vectors. Note the samples must be
%centered (subtracted by mean)
%k --- number of eigenvectors that will be computed
%iteration --- number of times the data are used
%oldV --- old eigen vector matrix, column wise
%access --- the number of updatings of the old eigenvector matrix
%OUTPUT
%V --- Eigenvector matrix, column-wise
%D --- Diagonal matrix of eigenvalue
%n --- Updating occurance

%get sample matrix dimensinality
	
	[datadim, samplenum]=size(X);
	
	%samplemean=mean(X,2);
	%scatter=X-samplemean*ones(1, samplenum); %subtract the sample set by its mean
	vectornum = datadim;
	repeating=1;
	n=2; % the number of times the eigenvector matrix get updated. Magic number to prevent div by 0 error
	
	if nargin == 1
	% batch	mode, init the eigenvector matrix with samples
	if datadim>samplenum
        error('No. of samples is less than the dimension. You have to choose how many eigenvectors to compute. ');
    end
    V = X(:,1:datadim);
	elseif nargin ==2
		% number of eigenvector given
		if k > datadim
			k=datadim;
		end
		vectornum=k;
		V=X(:,1:vectornum);
	elseif nargin ==3
		% number of eigenvector given, number of iteration given
		if k > datadim
			k=datadim;
		end
		vectornum=k;
		V=X(:,1:vectornum);
		repeating = iteration;
	elseif nargin ==4
		% if given oldV the the argument k will not take effect.
		if datadim~=size(oldV,1)
			error('The dimensionality of sample data and eigenvector are not match. Program ends.');	
		end
		vectornum=size(oldV,2);
		V=oldV;
		repeating = iteration;
		n=access;
	end
	Vnorm=sqrt(sum(V.^2)); 
	for iter = 1:repeating
		for  i = 1:samplenum
			residue = X(:, i);  % get the image 
			[w1, w2]=amnesic(n);
			n=n+1;
			for j= 1:vectornum
				V(: , j) = w1 * V(:,j) + w2 * V(:,j)' * residue * residue / Vnorm(j);
                		Vnorm(j)=norm(V(:,j)); % updata the norm of eigen vecor
                		normedV=V(:,j)/Vnorm(j);
				residue = residue - residue' * normedV * normedV; 
			end
		end
	end
	D=sqrt(sum(V.^2)); %length of the updated eigen vector, aka eigen value
    [Y,I]=sort(-D);
    V=V(:,I);
    V=normc(V); %normalize V
	if nargout==2
        D=D(I);
        D=diag(D);
	end
    
return
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w1, w2]=amnesic(i)
%AMNESIC --- Calculate the amnesic weight
%
%INPUT 
%i --- accessing time
%OUTPUT
%w1, w2 ---two amnesic weights

n1=20;
n2=500;
m=1000;
if i < n1
    L=0;
elseif i >= n1 & i < n2
    L=2*(i-n1)/(n2-n1);
else 
    L=2+(i-n2)/m;
end
w1=(i-1-L)/i;    
w2=(1+L)/i;
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
