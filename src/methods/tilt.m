function new_coor = tilt( coor,point,Vn,theta)
%Rigid body tilt
% coor: n by 3 coordinates
% point: tilt point (imagine you touch your finger)
% Vn: tilt direction

% new_coor: output

center=mean(coor,1);

point=point(:)';
Vn=Vn(:)';

V=cross(center-point,Vn);
R=rot(V,theta);

new_coor=R*(coor'-center'*ones(1,size(coor,1)));
new_coor=new_coor';

new_coor=new_coor+ones(size(coor,1),1)*center;

end

