function LoadMap(obj)
import javax.swing.SpinnerNumberModel;
electrode=obj.SelectedElectrode;
if ~isempty(electrode)
    open_dir=fileparts(electrode.file);
    
    if exist([open_dir,'/app/spatial map'],'dir')==7
        open_dir=[open_dir,'/app/spatial map'];
    elseif exist([open_dir,'/../app/spatial map'],'dir')==7
        open_dir=[open_dir,'/../app/spatial map'];
    else
        open_dir='.';
    end
    
    [FileName,FilePath,FilterIndex]=uigetfile({'*.smw;*.txt;*.csv','Spatial Map Files (*.smw;*.txt;*.csv)';...
        '*.smw;*.txt;*csv','Text File (*.smw;*.txt;*csv)'},...
        'select your spatial map file',...
        'MultiSelect','off',...
        open_dir);
    try
        if FileName==0
            return
        end
    catch
    end
    
    mapfiles={fullfile(FilePath,FileName)};
    map=ones(size(electrode.coor,1),length(mapfiles))*nan;
    map_sig=zeros(size(electrode.coor,1),length(mapfiles));
    
    for i=1:length(mapfiles)
        sm=ReadSpatialMap(mapfiles{i});
        [~,ib]=ismember(sm.name,electrode.channame);
        map(ib,i)=sm.val;
        map_sig(ib,i)=sm.sig;
    end
    map=mean(map,2);
    map_sig=sum(map_sig,2);
    
    electrode.map=map;
    electrode.map_sig=map_sig;
    %%
    obj.JMapMinSpinner.getModel().setValue(min(map));
    obj.JMapMaxSpinner.getModel().setValue(max(map));
    %set map alpha value
    obj.JMapAlphaSpinner.setValue(electrode.map_alpha*100);
    obj.JMapAlphaSlider.setValue(electrode.map_alpha*100);
    %%
    %set map colormap
    set(obj.MapColorMapPopup,'value',...
        find(strcmpi(electrode.map_colormap,get(obj.MapColorMapPopup,'UserData'))));
    %%
    electrode=obj.redrawNewMap(electrode);
    
    for i=1:size(electrode.coor,1)
        userdat.ele=electrode;
        userdat.name=electrode.channame{i};
        
        [faces,vertices] = createContact3D...
            (electrode.coor(i,:),electrode.norm(i,:),electrode.radius(i),electrode.thickness(i));
        try
            delete(electrode.handles(i));
        catch
        end
        
        if electrode.map_sig(i)==0
            col=electrode.color(i,:);
        else
            col='w';
        end
        electrode.handles(i)=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
            'facecolor',col,'edgecolor','none','UserData',userdat,...
            'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
    end
    material dull;
    if electrode.ind==obj.electrode_settings.select_ele
        notify(obj,'ElectrodeSettingsChange')
    end
end
end



