% Written By Shicai Yang (shicai.yang@gmail.com)
% This function is used to Generate Data Sets!
% ----------------Input---------------
% N: Numbers of Points.
% dstype: Type of Data  Sets. Such as:
% ----------------DS Type---------------
% Swiss Roll: 'swissroll','sr';
% Incomplete Tire: 'incomplete tire','incompletetire','tire'
% InterSections: 'intersections','is','sect'
% S Roll: 'sroll','s roll','s'
% Roman Surface: 'roman surface','rs'
% Trefoil Knot: 'trefoil knot','knot','tk'
function [t,s,X]=MyData(N,dstype)
switch lower(dstype)
    case {'swissroll','sr'}
        t = (3*pi/2)*(1+2*rand(1,N)); 
        s = 21*rand(1,N); 
        X=[t.*cos(t);s;t.*sin(t)];        
    case {'incomplete tire','incompletetire','tire'}
        t=pi*5*rand(1,N)./3; 
        s=pi*5*rand(1,N)./3; 
        X=[(3+cos(s)).*cos(t); (3+cos(s)).*sin(t);sin(s)]; 
    case {'intersections','is','sect'}
        t=(3*rand(1,N)-1)*pi; 
        s=2*rand(1,N)-1; 
        X=[cos(t)+rand(1); s; (cos(2*t)).*sign(pi/2-t)]; 
    case {'sroll','s roll','s'}
        t=(3*rand(1,N)-1)*pi; 
        s=5*rand(1,N); 
        X=[cos(t); s; (sin(t)-1).*sign(pi/2-t)]; 
    case {'roman surface','rs'}
        t = pi*rand(1,N); 
        s = pi*rand(1,N); 
        X=[cos(t).*sin(s).*cos(s);sin(t).*sin(s).*cos(s);cos(t).*sin(s).*cos(s).^2];
    case {'trefoil knot','knot','tk'}
        t=rand(1,N)*7/4; 
        x=-10*cos(t) - 2*cos(5*t) + 15*sin(2*t); 
        y= -15*cos(2*t) + 10*sin(t) -2*sin(5*t); 
        z= 10*cos(3*t); 
        s=[];
        X=[x;y;z];
end
figure,scatter3(X(1,:),X(2,:),X(3,:),12,t,'+');view([10,10]);title(dstype);grid off;
