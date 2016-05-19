function VolumeSmoothSpinnerCallback(obj)
obj.NotifyTaskStart('Smoothing volume ...');
obj.smooth_sigma=obj.JVolumeSmoothSpinner.getValue();

allkeys=keys(obj.mapObj);
is_vol=regexp(allkeys,'^Volume');

for i=1:length(is_vol)
    if ~isempty(is_vol{i})
        mapval=obj.mapObj(allkeys{i});
        delete(mapval.handles);
        
        if obj.smooth_sigma>0
            img_vol=imgaussfilt3(mapval.volume,obj.smooth_sigma./mapval.pixdim);
        else
            img_vol=mapval.volume;
        end
        tmp=vol3d('cdata',img_vol,'texture','3D','Parent',obj.axis_3d,...
            'XData',mapval.xrange,'YData',mapval.yrange,'ZData',mapval.zrange);
        mapval.handles=tmp.handles;
        
        if mapval.checked
            set(mapval.handles,'visible','on');
        else
            set(mapval.handles,'visible','off');
        end
        
        obj.mapObj([mapval.category,num2str(mapval.ind)])=mapval;
    end
end

obj.NotifyTaskEnd('Volume smooth complete !');
end

