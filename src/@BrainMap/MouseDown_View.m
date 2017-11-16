function MouseDown_View(obj)

currp=get(obj.axis_3d,'CurrentPoint');
currp=currp(1,:)';

if strcmpi(get(obj.axis_3d,'Projection'),'orthographic')&&strcmpi(get(obj.fig,'renderer'),'opengl')
    opt=1;
elseif strcmpi(get(obj.axis_3d,'Projection'),'perspective')&&strcmpi(get(obj.fig,'renderer'),'opengl')
    opt=2;
else
    %painter renderer
    opt=3;
end

origin=camtarget(obj.axis_3d);
origin=origin(:);

eye=campos(obj.axis_3d);
eye=eye(:);
if obj.JTogNewElectrode.isSelected()
    obj.NotifyTaskStart('Adding electrode ...');
    
    new_radius=obj.JElectrodeRadiusSpinner.getValue();
    new_thickness=obj.JElectrodeThicknessSpinner.getValue();
    allkeys=keys(obj.mapObj);
    is_vol=regexp(allkeys,'^Volume');
    
    interp=[];
    
    vol_flag=false;
    for i=1:length(is_vol)
        if ~isempty(is_vol{i})
            vol=obj.mapObj(allkeys{i});
            if vol.checked
                vol_flag=true;
                for l=1:length(vol.handles)
                    x=get(vol.handles(l),'XData');
                    y=get(vol.handles(l),'YData');
                    z=get(vol.handles(l),'ZData');
                    alpha=get(vol.handles(l),'AlphaData');
                    
                    % p1  p2
                    % p3  p4
                    p1=[x(1,1),y(1,1),z(1,1)]';
                    p2=[x(1,end),y(1,end),z(1,end)]';
                    p3=[x(end,1),y(end,1),z(end,1)]';
                    p4=[x(end,end),y(end,end),z(end,end)]';
                    
                    switch opt
                        case 1
                            p0=intersection(p1,p2,p3,currp+(origin-eye),currp);
                        case 2
                            p0=intersection(p1,p2,p3,eye,currp);
                        case 3
                            p0=intersection(p1,p2,p3,currp+(origin-eye),currp);
                    end
                    p0=p0+(p0-origin)/norm(p0-origin)*new_thickness/2;
                    
                    p0_i=round(dot(p0-p1,(p3-p1)/norm(p3-p1))/sqrt((p3-p1)'*(p3-p1))*size(alpha,1));
                    p0_j=round(dot(p0-p1,(p2-p1)/norm(p2-p1))/sqrt((p2-p1)'*(p2-p1))*size(alpha,2));
                    
                    if p0_i>=1&&p0_i<=size(alpha,1)&&p0_j>=1&&p0_j<=size(alpha,2)&&alpha(p0_i,p0_j)
                        interp=cat(1,interp,p0');
                    end
                end
            end
        end
    end
    
    if ~vol_flag
        return
    end
    %find the closeset one to the camera position
    %%
    tmpv=interp-repmat(eye',size(interp,1),1);
    [~,ind]=min(sum(tmpv.^2,2));
    new_coor=interp(ind,:);
    new_norm=origin(:)'-new_coor;
    radius_ratio=obj.JElectrodeRadiusRatioSpinner.getValue()/100;
    thickness_ratio=obj.JElectrodeThicknessRatioSpinner.getValue()/100;
    %%
    
    electrode=obj.SelectedElectrode;
    if isempty(electrode)
        %create a new electrode
        new_channame='1';
        
        fpath=[pwd,'/Electrode',num2str(obj.JFileLoadTree.getElectrodeID()+1)];
        num=obj.JFileLoadTree.addElectrode(fpath,true);
        electrode=Electrode;
        
        electrode.file=fpath;
        electrode.ind=num;
        electrode.coor=new_coor;
        electrode.radius=new_radius;
        electrode.thickness=new_thickness;
        electrode.color=obj.ecolor;
        electrode.norm=new_norm;
        electrode.checked=true;
        electrode.selected=true;
        electrode.channame={new_channame};
        electrode.coor_interp=10;
        electrode.map_alpha=0.8;
        electrode.map_colormap='jet';
        electrode.radius_ratio=radius_ratio;
        electrode.thickness_ratio=thickness_ratio;
        electrode.map=nan;
        electrode.map_sig=0;
        
    else
        new_channame=num2str(electrode.count+1);
        
        electrode.coor=cat(1,electrode.coor,new_coor);
        electrode.norm=cat(1,electrode.norm,new_norm);
        electrode.radius=cat(1,electrode.radius(:),new_radius);
        electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
        electrode.color=cat(1,electrode.color,obj.ecolor);
        
        electrode.selected=ones(size(electrode.coor,1),1)*false;
        electrode.selected(end)=true;
        
        electrode.radius_ratio=cat(1,electrode.radius_ratio,radius_ratio);
        electrode.thickness_ratio=cat(1,electrode.thickness_ratio,thickness_ratio);
        electrode.channame=cat(1,electrode.channame(:),new_channame);
        electrode.map=cat(1,electrode.map,nan);
        electrode.map_sig=cat(1,electrode.map_sig,0);
        electrode.count=electrode.count+1;
    end
    
    
    [faces,vertices] = createContact3D(new_coor,new_norm,new_radius,new_thickness);
    
    userdat.name=new_channame;
    userdat.ele=electrode;
    
    new_h=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
        'facecolor',obj.ecolor,'edgecolor','y','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
    set(electrode.handles,'edgecolor','none');
    electrode.handles=cat(1,electrode.handles(:),new_h);
    
    obj.mapObj(['Electrode',num2str(electrode.ind)])=electrode;
    
    if electrode.ind==obj.electrode_settings.select_ele
        notify(obj,'ElectrodeSettingsChange')
    end
    
    material dull;
    
    obj.NotifyTaskEnd('Electrode added !');
elseif obj.JTogPickElectrode.isSelected()
    %%
    %try to pick the electrode
    allkeys=keys(obj.mapObj);
    is_ele=regexp(allkeys,'^Electrode');
    
    interp=[];
    interph=[];
    
    Q1=currp;
    Q2=currp+(origin-eye);
    n12=norm(Q1-Q2);
    Q12=(Q1-Q2)/n12;
                    
    for i=1:length(is_ele)
        if ~isempty(is_ele{i})
            electrode=obj.mapObj(allkeys{i});
            if ~isempty(electrode.checked)
                for e=1:length(electrode.handles)
                    patchObj=electrode.handles(e);
                    dat=get(patchObj,'UserData');
                    
                    datind=strcmp(dat.name,electrode.channame);
                    
                    P=electrode.coor(datind,:)';
                    try
                        d=sqrt((P-Q2)'*(P-Q2)-((P-Q2)'*Q12)^2);
                    catch
                        disp(['error: ',num2str(e),'th contact']);
                        return;
                    end
                    
                    interp=cat(1,interp,d);
                    interph=cat(1,interph,patchObj);
                    
                end
            end
        end
    end
    if isempty(interp)
        return
    end
    %find the closeset one to the camera position
    %%
    [~,ind]=min(interp);
    ClickOnElectrode(obj,interph(ind),[]);
else
    obj.loc = get(obj.fig,'CurrentPoint');    % get starting point
    start(obj.RotateTimer);
    set(obj.fig,'windowbuttonupfcn',@(src,evt) MouseUp_View(obj));
end

end
