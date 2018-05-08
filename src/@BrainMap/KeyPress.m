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
electrode=obj.SelectedElectrode;
if ~isempty(electrode)
    sel_ind=find(electrode.selected);
    mov_ind=find(electrode.selected);
    
    redraw_electrode=false;
    
    center=mean(electrode.coor(sel_ind,:),1);
    if isempty(evt.Modifier)
        if strcmpi(evt.Key,'leftarrow')
            electrode.coor(sel_ind,:)=...
                perspectiveRotate(obj.axis_3d,electrode.coor(sel_ind,:),0,0.02*obj.move_sensitivity);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'rightarrow')
            electrode.coor(sel_ind,:)=...
                perspectiveRotate(obj.axis_3d,electrode.coor(sel_ind,:),0,-0.02*obj.move_sensitivity);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'uparrow')
            electrode.coor(sel_ind,:)=...
                perspectiveRotate(obj.axis_3d,electrode.coor(sel_ind,:),0.02*obj.move_sensitivity,0);
            redraw_electrode=true;
        elseif strcmpi(evt.Key,'downarrow')
            electrode.coor(sel_ind,:)=...
                perspectiveRotate(obj.axis_3d,electrode.coor(sel_ind,:),-0.02*obj.move_sensitivity,0);
            redraw_electrode=true;
        end
    else
        if length(evt.Modifier)==1
            if (ismember('command',evt.Modifier)&&ismac)||(ismember('control',evt.Modifier)&&ispc)
                if strcmpi(evt.Key,'uparrow')
                    electrode.coor(sel_ind,:)=axialTranslate(electrode.coor(sel_ind,:),camtarget(obj.axis_3d),0.025*obj.move_sensitivity);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'downarrow')
                    electrode.coor(sel_ind,:)=axialTranslate(electrode.coor(sel_ind,:),camtarget(obj.axis_3d),-0.025*obj.move_sensitivity);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'leftarrow')
                    electrode.coor(sel_ind,:) = selfRotate(electrode.coor(sel_ind,:),camtarget(obj.axis_3d),0.06*obj.move_sensitivity);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'rightarrow')
                    electrode.coor(sel_ind,:) = selfRotate(electrode.coor(sel_ind,:),camtarget(obj.axis_3d),-0.06*obj.move_sensitivity);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'j')
                    %tilt in
                    electrode.coor=tilt(electrode.coor,center,camtarget(obj.axis_3d)-center,-0.06*obj.move_sensitivity);
                    mov_ind=1:size(electrode.coor,1);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'k')
                    %tilt out
                    electrode.coor=tilt(electrode.coor,center,camtarget(obj.axis_3d)-center,0.06*obj.move_sensitivity);
                    mov_ind=1:size(electrode.coor,1);
                    redraw_electrode=true;
                end
                
            elseif ismember('shift',evt.Modifier)
                if strcmpi(evt.Key,'leftarrow')
                    electrode.coor(sel_ind,:)=...
                        perspectiveRotate(obj.axis_3d,electrode.coor(sel_ind,:),0,0.004*obj.move_sensitivity);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'rightarrow')
                    electrode.coor(sel_ind,:)=...
                        perspectiveRotate(obj.axis_3d,electrode.coor(sel_ind,:),0,-0.004*obj.move_sensitivity);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'uparrow')
                    electrode.coor(sel_ind,:)=...
                        perspectiveRotate(obj.axis_3d,electrode.coor(sel_ind,:),0.004*obj.move_sensitivity,0);
                    redraw_electrode=true;
                elseif strcmpi(evt.Key,'downarrow')
                    electrode.coor(sel_ind,:)=...
                        perspectiveRotate(obj.axis_3d,electrode.coor(sel_ind,:),-0.004*obj.move_sensitivity,0);
                    redraw_electrode=true;
                end
            end
        elseif length(evt.Modifier)==2
            if (ismember('command',evt.Modifier)&&ismac)||(ismember('control',evt.Modifier)&&ispc)
                if ismember('shift',evt.Modifier)
                    if strcmpi(evt.Key,'uparrow')
                        electrode.coor(sel_ind,:)=axialTranslate(electrode.coor(sel_ind,:),camtarget(obj.axis_3d),0.005*obj.move_sensitivity);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'downarrow')
                        electrode.coor(sel_ind,:)=axialTranslate(electrode.coor(sel_ind,:),camtarget(obj.axis_3d),-0.005*obj.move_sensitivity);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'leftarrow')
                        electrode.coor(sel_ind,:) = selfRotate(electrode.coor(sel_ind,:),camtarget(obj.axis_3d),0.02*obj.move_sensitivity);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'rightarrow')
                        electrode.coor(sel_ind,:) = selfRotate(electrode.coor(sel_ind,:),camtarget(obj.axis_3d),-0.02*obj.move_sensitivity);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'j')
                        %tilt in
                        electrode.coor=tilt(electrode.coor,center,camtarget(obj.axis_3d)-center,-0.02*obj.move_sensitivity);
                        mov_ind=1:size(electrode.coor,1);
                        redraw_electrode=true;
                    elseif strcmpi(evt.Key,'k')
                        %tilt out
                        electrode.coor=tilt(electrode.coor,center,camtarget(obj.axis_3d)-center,0.02*obj.move_sensitivity);
                        mov_ind=1:size(electrode.coor,1);
                        redraw_electrode=true;
                    end
                end
            end
            
        end
    end
    
    if redraw_electrode
        for i=1:length(mov_ind)
            userdat.name=electrode.channame{mov_ind(i)};
            userdat.ele=electrode;
            
            electrode.norm(mov_ind(i),:)=electrode.coor(mov_ind(i),:)-camtarget(obj.axis_3d);
            [faces,vertices] = createContact3D(electrode.coor(mov_ind(i),:),electrode.norm(mov_ind(i),:),electrode.radius(mov_ind(i)),electrode.thickness(mov_ind(i)));
            try
            delete(electrode.handles(mov_ind(i)));
            catch
            end
            
            if ismember(mov_ind(i),sel_ind)
                edge_col='y';
            else
                edge_col='none';
            end
            electrode.handles(mov_ind(i))=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
                'facecolor',electrode.color(mov_ind(i),:),'edgecolor',edge_col,'UserData',userdat,...
                'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
        end
        material dull;
        
        if electrode.ind==obj.electrode_settings.select_ele
            notify(obj,'ElectrodeSettingsChange')
        end
    end
end

end

