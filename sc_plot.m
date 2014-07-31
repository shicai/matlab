function sc_plot(X,Y,spec)
% Plot - Plot Curves with various Marker, Color and Line specifications
%
%   sc_plot(X,Y,spec)
%
% Input: 
%   - X (a vector)
%   - Y (a vector or a matrix,if using matrix, each row vector of this matrix is a plot)
%   - spec (a 1x4 row vector, or a Nx4 matrix,[1 1 1 0]~[12 7 4 1])
%          [12 markers, 7 colors, 4 line types, marker fullfilled or not]
% 
% The function plots a figure.
%
% Example:
%     X=1:20;
%     Y=cumsum(rand(3,20),2);
%     spec=[4 2 3 1;2 1 1 0;5 3 1 1;]; 
%     %or for short: spec=[4231;2110;5311];
%     sc_plot(X,Y,spec);
% % % 
% (C) Shicai Yang, 2012
% Institute of Systems Engineering, Southeast University, Nanjing
    
    if nargin<3 || isempty(spec)
        spec=[2 1 1 0];
    end
    
    marker={'+';'*';'x';'o';'s';'d';'p';'h';'v';'^';'>';'<';'.'};
    lcolor={'r';'g';'b';'m';'c';'y';'k'};
    fcolor={[221 68 59];[88 169 29];[0 91 175];[143 46 124];[0 170 159];[241 181 0];[39 52 52];};
    line={'-';'--';':';'-.';''};
    
    nn=size(Y,1);
    if nn>1 && size(spec,1)<nn
        spec=repmat(spec,[nn,1]);
    end
    for ii=1:nn        
        specii=spec(ii,:);
        if numel(specii)==1 && specii>=1110 && specii<=13741 && mod(specii,10)<2
            th=floor(specii/1000);
            hu=mod(floor(specii/100),10);
            de=mod(floor(specii/10),10);
            di=mod(specii,10);
            if hu>0 && hu<8 && de>0 && de<6
                specii=[th,hu,de,di];
            else
                error('Input wrong [spec], it should be [1 1 1 0]~[12 7 4 1].');
            end
        end
        m=[marker{specii(1)},lcolor{specii(2)},line{specii(3)}];
        if specii(1)==1 || specii(1)==2 || specii(1)==3
            hold on,plot(X,Y(ii,:),m);
        elseif specii(4)>0 && specii(2)>1
            hold on,plot(X,Y(ii,:),m,'markeredgecolor','w','markerfacecolor',fcolor{specii(2)}/255);    
        elseif specii(4)>0 && specii(2)==1
            hold on,plot(X,Y(ii,:),m,'markeredgecolor','w','markerfacecolor',fcolor{specii(2)}/255);
        else
            hold on,plot(X,Y(ii,:),m);
        end
    end    
end
