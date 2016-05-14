function MouseDown(obj)
currp=get(obj.axis_3d,'CurrentPoint');
currp=currp(:);

if obj.JTogNewElectrode.isSelected()
    origin=camtarget(obj.axis_3d);
    origin=origin(:);
    
    eye=campos(obj.axis_3d);
    eye=eye(:);
    
    allkeys=keys(obj.mapObj);
    is_vol=regexp(allkeys,'^Volume');
    
    interp=[];
    
    for i=1:length(is_vol)
        if ~isempty(is_vol{i})
            mapval=obj.mapObj(allkeys{i});
            if mapval.checked
                for l=1:length(mapval.handles)
                    x=get(mapval.handles(l),'XData');
                    y=get(mapval.handles(l),'YData');
                    z=get(mapval.handles(l),'ZData');
                    alpha=get(mapval.handles(l),'AlphaData');
                    
                    % p1  p2
                    % p3  p4
                    p1=[x(1,1),y(1,1),z(1,1)]';
                    p2=[x(1,end),y(1,end),z(1,end)]';
                    p3=[x(end,1),y(end,1),z(end,1)]';
                    p4=[x(end,end),y(end,end),z(end,end)]';
                    
                    p0=intersection(p1,p2,p3,currp+(origin-eye),currp);
                    
                    p0_i=round(dot(p0-p1,(p3-p1)/norm(p3-p1))/sqrt((p3-p1)'*(p3-p1))*size(alpha,1));
                    p0_j=round(dot(p0-p1,(p2-p1)/norm(p2-p1))/sqrt((p2-p1)'*(p2-p1))*size(alpha,2));
                    
                    if alpha(p0_i,p0_j)
                        interp=cat(1,interp,p0');
                    end
                end
                %find the closeset one to the camera position
                
                tmpv=interp-repmat(eye',size(interp,1),1);
                
                [~,ind]=min(sum(tmpv.^2),2);
                
                new_pos=interp(ind,:);
                
                if ~isempty(obj.SelectedElectrode)
                    %create a new electrode 
                    
                end
            end
        end
    end
end

end