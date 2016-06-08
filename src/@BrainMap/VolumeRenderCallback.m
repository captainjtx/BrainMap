function VolumeRenderCallback( obj )
obj.NotifyTaskStart('Rendering volume ...');

if ~isempty(obj.SelectedVolume)
    mapval=obj.mapObj(['Volume',num2str(obj.SelectedVolume)]);
    
    if obj.smooth_sigma>0
        img_vol=smooth3(mapval.volume,'gaussian',2*round(obj.smooth_sigma./mapval.pixdim/2)+1);
    else
        img_vol=mapval.volume;
    end
    
    % alpha=img_vol;
    % max_val=max(max(max(img_vol)));
    % min_val=min(min(min(img_vol)));
    %
    % alpha=(alpha-min_val)/(max_val-min_val)*1;
    % alpha(alpha<0.2)=0;
    % alpha(alpha>0.6)=0;
    % alpha(alpha>0)=1;
    
    
    tmp=vol3d('cdata',img_vol,'texture','3D','Parent',obj.axis_3d,...
        'XData',mapval.xrange,'YData',mapval.yrange,'ZData',mapval.zrange);
    mapval.handles=tmp.handles;
    
    axis vis3d
    axis equal off
    set(obj.axis_3d,'clim',[obj.cmin,obj.cmax]);
    
    hold on;
    material dull
end
obj.NotifyTaskEnd('Volume rendering complete !');
end

