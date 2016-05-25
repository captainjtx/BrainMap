function KeyPress(obj,src,evt)
%**************************************************************************
%Exit the special channel selection mode

if isempty(evt.Modifier)
    if strcmpi(evt.Key,'escape')
        obj.JTogNavigation.setSelected(true);
        set(obj.fig,'pointer','arrow');
        return
    end
elseif length(evt.Modifier)==1
    if (ismember('command',evt.Modifier)&&ismac)||(ismember('control',evt.Modifier)&&ispc)
        if strcmpi(evt.Key,'E')
            obj.JTogPickElectrode.setSelected(true);
        end
    elseif ismember('alt',evt.Modifier)
    end
end
%**************************************************************************

if ~isempty(obj.SelectedElectrode)
    electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
    
    ind=find(electrode.selected);
    
    redraw_electrode=false;
    if isempty(evt.Modifier)
        if strcmpi(evt.Key,'leftarrow')
            electrode.coor(ind,:)=...
                perspectiveRotate(obj.axis_3d,electrode.coor(ind,:),0,-0.002);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'rightarrow')
            electrode.coor(ind,:)=...
                perspectiveRotate(obj.axis_3d,electrode.coor(ind,:),0,0.002);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'uparrow')
            electrode.coor(ind,:)=...
                perspectiveRotate(obj.axis_3d,electrode.coor(ind,:),0.002,0);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'downarrow')
            electrode.coor(ind,:)=...
                perspectiveRotate(obj.axis_3d,electrode.coor(ind,:),-0.002,0);
            redraw_electrode=true;
        end
    else
        if length(evt.Modifier)==1
            if (ismember('command',evt.Modifier)&&ismac)||(ismember('control',evt.Modifier)&&ispc)
                if strcmpi(evt.Key,'uparrow')
                    electrode.coor(ind,:)=axialTranslate(electrode.coor(ind,:),camtarget(obj.axis_3d),0.025);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'downarrow')
                    electrode.coor(ind,:)=axialTranslate(electrode.coor(ind,:),camtarget(obj.axis_3d),-0.025);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'leftarrow')
                    electrode.coor(ind,:) = selfRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),0.06);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'rightarrow')
                    electrode.coor(ind,:) = selfRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),-0.06);
                    redraw_electrode=true;
                end
                
            elseif ismember('shift',evt.Modifier)
                if strcmpi(evt.Key,'leftarrow')
                    electrode.coor(ind,:)=...
                        perspectiveRotate(obj.axis_3d,electrode.coor(ind,:),0,-0.0004);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'rightarrow')
                    electrode.coor(ind,:)=...
                        perspectiveRotate(obj.axis_3d,electrode.coor(ind,:),0,0.0004);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'uparrow')
                    electrode.coor(ind,:)=...
                        perspectiveRotate(obj.axis_3d,electrode.coor(ind,:),0.0004,0);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'downarrow')
                    electrode.coor(ind,:)=...
                        perspectiveRotate(obj.axis_3d,electrode.coor(ind,:),-0.0004,0);
                    redraw_electrode=true;
                end
            end
        elseif length(evt.Modifier)==2
            if (ismember('command',evt.Modifier)&&ismac)||(ismember('control',evt.Modifier)&&ispc)
                if ismember('shift',evt.Modifier)
                    if strcmpi(evt.Key,'uparrow')
                        electrode.coor(ind,:)=axialTranslate(electrode.coor(ind,:),camtarget(obj.axis_3d),0.005);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'downarrow')
                        electrode.coor(ind,:)=axialTranslate(electrode.coor(ind,:),camtarget(obj.axis_3d),-0.005);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'leftarrow')
                        electrode.coor(ind,:) = selfRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),0.02);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'rightarrow')
                        electrode.coor(ind,:) = selfRotate(electrode.coor(ind,:),camtarget(obj.axis_3d),-0.02);
                        redraw_electrode=true;
                    end
                end
            end
            
        end
    end
    
    if redraw_electrode
        for i=1:length(ind)
            userdat.name=electrode.channame{ind(i)};
            userdat.ele=electrode.ind;
            
            electrode.norm(ind(i),:)=electrode.coor(ind(i),:)-camtarget(obj.axis_3d);
            [faces,vertices] = createContact3D(electrode.coor(ind(i),:),electrode.norm(ind(i),:),electrode.radius(ind(i)),electrode.thickness(ind(i)));
            try
            delete(electrode.handles(ind(i)));
            catch
            end
            electrode.handles(ind(i))=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
                'facecolor',electrode.color(ind(i),:),'edgecolor','y','UserData',userdat,...
                'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
        end
        material dull;
        
        if electrode.ind==obj.electrode_settings.select_ele
            notify(obj,'ElectrodeSettingsChange')
        end
    end
end

end

