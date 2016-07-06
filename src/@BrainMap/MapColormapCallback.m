function MapColormapCallback( obj )
obj.NotifyTaskStart('Refreshing map ...');
electrode=obj.SelectedElectrode;
if ~isempty(electrode)
    listIdx = get(obj.MapColorMapPopup,'Value');
    
    cmapName=get(obj.MapColorMapPopup,'UserData');
    cmapName=lower(cmapName{listIdx});
    electrode.map_colormap=cmapName;
    
    if is_handle_valid(electrode.map_h)
        cmin=obj.JMapMinSpinner.getValue();
        cmax=obj.JMapMaxSpinner.getValue();
        
        if cmin<cmax
            func=str2func(electrode.map_colormap);
            cmap=func();
            
            map=get(electrode.map_h,'UserData');
            
            clevel=linspace(cmin,cmax,size(cmap,1));
            
            cmapv=zeros(length(map),3);
            for i=1:length(map)
                [~,index] = min(abs(clevel-map(i)));
                
                cmapv(i,:)=cmap(index,:);
            end
            
            set(electrode.map_h,'FaceVertexCData',cmapv)
        end
    end
end

obj.NotifyTaskEnd('Map refresh complete !');

end

