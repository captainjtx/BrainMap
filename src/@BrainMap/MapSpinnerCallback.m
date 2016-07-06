function MapSpinnerCallback(obj)
electrode=obj.SelectedElectrode;
if ~isempty(electrode)
    
    if is_handle_valid(electrode.map_h)
        cmin=obj.JMapMinSpinner.getValue();
        cmax=obj.JMapMaxSpinner.getValue();
        
        if cmin<cmax
            fcn=str2func(electrode.map_colormap);
            cmap=fcn(64);
            
            map=get(electrode.map_h,'UserData');
            cmapv=zeros(length(map),3);
            for i=1:length(map)
                index=min(max(1,round((map(i)-cmin)/(cmax-cmin)*(size(cmap,1)-1))+1),size(cmap,1));
                cmapv(i,:)=cmap(index,:);
            end
            
            set(electrode.map_h,'FaceVertexCData',cmapv)
        end
    end
end

end

