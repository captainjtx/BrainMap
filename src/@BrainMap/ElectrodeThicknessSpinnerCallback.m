function ElectrodeThicknessSpinnerCallback(obj)

thick=obj.JElectrodeThicknessSpinner.getValue();
if ~isempty(obj.SelectedElectrode)
    electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
    ind=find(electrode.selected);
    
    electrode.thickness(ind)=thick;
    for i=1:length(ind)
        userdat.name=electrode.channame{ind(i)};
        userdat.ele=obj.SelectedElectrode;
        
        [faces,vertices] = createContact3D...
            (electrode.coor(ind(i),:),electrode.norm(ind(i),:),...
            electrode.radius(ind(i))*electrode.radius_ratio(ind(i)),...
            electrode.thickness(ind(i))*electrode.thickness_ratio(ind(i)));
        try
            delete(electrode.handles(ind(i)));
        catch
        end
        
        if electrode.selected(ind(i))
            edgecolor='y';
        else
            edgecolor='none';
        end
        
        electrode.handles(ind(i))=patch('faces',faces,'vertices',vertices,...
            'facecolor',electrode.color(ind(i),:),'edgecolor',edgecolor,'UserData',userdat,...
            'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src),'facelighting','gouraud');
    end
    material dull;
    obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
    if electrode.ind==obj.electrode_settings.select_ele
        notify(obj,'ElectrodeSettingsChange')
    end
end
end