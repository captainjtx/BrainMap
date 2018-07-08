function MapInterpolationCallback( obj )
obj.NotifyTaskStart('Start map interpolation ..');
interp=obj.JMapInterpolationSpinner.getValue();
electrode=obj.SelectedElectrode;
proj_cam_tgt = obj.JMapTriCanvas.isSelected();
if ~isempty(electrode)
    electrode.coor_interp=interp;
    if is_handle_valid(electrode.map_h)
        
        
        newpos=interp_tri(electrode.coor,electrode.coor_interp, proj_cam_tgt);
        
        newmap=electrode.F(newpos(:,1),newpos(:,2),newpos(:,3));
        
        [x, y] = project_3d_to_2d( newpos, proj_cam_tgt );
        tri=delaunay(x, y);

        cmapv=zeros(length(newmap),3);
        
        cmin=obj.JMapMinSpinner.getValue();
        cmax=obj.JMapMaxSpinner.getValue();
        
        fcn=str2func(electrode.map_colormap);
        cmap=fcn(64);
        
        for i=1:length(newmap)
            index=min(max(1,round((newmap(i)-cmin)/(cmax-cmin)*(size(cmap,1)-1))+1),size(cmap,1));
            cmapv(i,:)=cmap(index,:);
        end
        
        try
            delete(electrode.map_h)
        catch
        end
        
        electrode.map_h=patch('parent',obj.axis_3d,'Faces',tri,'Vertices',newpos,'facelighting','gouraud',...
            'FaceVertexCData',cmapv,'FaceColor','interp','EdgeColor','none','FaceAlpha',electrode.map_alpha,...
            'UserData',newmap);
        material dull
    end
end
obj.NotifyTaskEnd('Map interpolation complete !');

end

