function MouseDown_View(obj)
            
currp=get(obj.axis_3d,'CurrentPoint');
currp=currp(1,:)';

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
                    
                    if p0_i>=1&&p0_i<=size(alpha,1)&&p0_j>=1&&p0_j<=size(alpha,2)&&alpha(p0_i,p0_j)
                        interp=cat(1,interp,p0');
                    end
                end
            end
        end
    end
    
    
    %find the closeset one to the camera position
    %%
    tmpv=interp-repmat(eye',size(interp,1),1);
    [~,ind]=min(sum(tmpv.^2,2));
    new_coor=interp(ind,:);
    
    new_radius=obj.JElectrodeRadiusSpinner.getValue();
    new_thickness=obj.JElectrodeThicknessSpinner.getValue();
    origin=camtarget(obj.axis_3d);
    new_norm=origin(:)'-new_coor;
    %%
    if isempty(obj.SelectedElectrode)
        %create a new electrode
        fpath=[pwd,'/Electrode',num2str(obj.JFileLoadTree.getElectrodeID()+1)];
        num=obj.JFileLoadTree.addElectrode(fpath,true);
        mapval=Electrode;
        
        mapval.file=fpath;
        mapval.ind=num;
        mapval.coor=new_coor;
        mapval.radius=new_radius;
        mapval.thickness=new_thickness;
        mapval.color=obj.ecolor;
        mapval.norm=new_norm;
        mapval.checked=true;
        mapval.selected=true;
        mapval.channame='1';
        mapval.coor_interp=10;
        mapval.map_alpha=0.8;
        mapval.map_colormap='jet';
        mapval.radius_ratio=1;
        mapval.thickness_ratio=1;
        
        obj.mapObj([mapval.category,num2str(num)])=mapval;
    else
        new_channame=num2str(size(mapval.coor,1));
        mapval=obj.mapObj(['mapval',num2str(obj.SelectedElectrode)]);
        
        mapval.coor=cat(1,mapval.coor,new_coor);
        mapval.norm=cat(1,mapval.norm,new_norm);
        mapval.radius=cat(1,mapval.radius(:),new_radius);
        mapval.thickness=cat(1,mapval.thickness(:),new_thickness);
        mapval.color=cat(1,mapval.color,obj.ecolor);
        
        mapval.selected=ones(size(mapval.coor,1),1)*false;
        mapval.selected(end)=true;
        
        mapval.channame=cat(1,mapval.channame(:),new_channame);
        
        [faces,vertices] = createContact3D(new_coor,new_norm,new_radius,new_thickness);
        
        userdat.name=new_channame;
        userdat.ele=mapval.ind;
        
        new_h=patch('faces',faces,'vertices',vertices,...
        'facecolor',new_color,'edgecolor','y','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
        set(mapval.handles,'edgecolor','none');
        mapval.handles=cat(1,mapval.handles(:),new_h);
        
        obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=mapval;
        
        if mapval.ind==obj.mapval_settings.select_ele
            notify(obj,'ElectrodeSettingsChange')
        end
        
        material dull;
    end
else
    obj.loc = get(obj.fig,'CurrentPoint');    % get starting point
    start(obj.RotateTimer);
    set(obj.fig,'windowbuttonupfcn',@(src,evt) MouseUp_View(obj));
end

end