function [P0,isin]=intersection(P1,P2,P3,Q1,Q2)
%Find the intersection of surface (defined by P1,P2,P3) and line (defined by Q1,Q2)
%Writen by Tianxiao Jiang, May 13 2016
P1=P1(:);
P2=P2(:);
P3=P3(:);
Q1=Q1(:);
Q2=Q2(:);

N=cross(P2-P1,P3-P1);
P0=Q1+dot(P1-Q1,N)/dot(Q2-Q1,N)*(Q2-Q1);

n12=norm(P2'-P1');
n13=norm(P3'-P1');
d1=(P0'-P1')*(P2-P1)/n12;
d2=(P0'-P1')*(P3-P1)/n13;

if d1>=0&&d1<=n12&&d2<=n13&&d2>=0
    isin=true;
else
    isin=false;
end
end

