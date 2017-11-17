function ElectrodeRadiusRatioSpinnerCallback(obj)
r=obj.JElectrodeRadiusRatioSpinner.getValue();
electrode=obj.SelectedElectrode;
if ~isempty(electrode)
    ind=find(electrode.selected);
    
    electrode.radius_ratio(ind)=r/100;
    for i=1:length(ind)
        userdat.name=electrode.channame{ind(i)};
        userdat.ele=electrode;
        
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
        
        electrode.handles(ind(i))=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
            'facecolor',electrode.color(ind(i),:),'edgecolor',edgecolor,'UserData',userdat,...
            'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src),'facelighting','gouraud');
    end
    material dull;
end
end
