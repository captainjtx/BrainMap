function  new_coor= perspectiveRotate(a,coor,ud,lr,varargin)
%Rotate V with respect to the perspective vector Vp
%ud, rad of up and down rotation, postive is up, negative is down
%lr, degree of left and right rotation, positive is right, negative is left

%Vp is usually defined as the camera location with respect to the center of
%the object

%By Tianxiao Jiang
%Apr-15-2016


origin=camtarget(a);
viewpos=campos(a);
Vup=camup(a);

for i=1:length(varargin)
    switch i
        case 1
            origin=varargin{1};
        case 2
            viewpos=varargin{2};
        case 3
            Vup=varargin{3};
    end
end

Vp=viewpos-origin;
Vr=cross(Vup,Vp);

center=mean(coor,1);
V=center-origin;


R1=rot(Vup,-lr);
V=V(:);
Vtmp=R1*V;

R2=rot(Vr,-ud);

V=R2*Vtmp;

new_coor=coor-ones(size(coor,1),1)*center+ones(size(coor,1),1)*(V'+origin);

end


