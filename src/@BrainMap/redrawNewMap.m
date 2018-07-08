function  electrode=redrawNewMap(obj,electrode)
pos=electrode.coor;
map=electrode.map;

if obj.JMapOnlyShowSig.isSelected()
    map(electrode.map_sig==0)=0;
end
%%
max_map=max(map);
min_map=min(map);

step=(max_map-min_map)/20;

obj.JMapMinSpinner.getModel().setStepSize(java.lang.Double(step));
obj.JMapMaxSpinner.getModel().setStepSize(java.lang.Double(step));

cmin=obj.JMapMinSpinner.getValue();
cmax=obj.JMapMaxSpinner.getValue();
%%
F= scatteredInterpolant(pos(:,1),pos(:,2),pos(:,3),map,'natural','linear');
electrode.F=F;

fcn=str2func(electrode.map_colormap);
cmap=fcn(64);

% if ~is_handle_valid(electrode.map_h)

try
    delete(electrode.map_h)
catch
end
    
newpos=interp_tri(pos,electrode.coor_interp, obj.JMapTriCanvas.isSelected());

newmap=F(newpos(:,1),newpos(:,2),newpos(:,3));

% use PCA to project 3d points into 2d plane
[x, y] = project_3d_to_2d(newpos, obj.JMapTriCanvas.isSelected());
tri=delaunay(x, y);

cmapv=zeros(length(newmap),3);
for i=1:length(newmap)
    index=min(max(1,round((newmap(i)-cmin)/(cmax-cmin)*(size(cmap,1)-1))+1),size(cmap,1));
    cmapv(i,:)=cmap(index,:);
end

electrode.map_h=patch('parent',obj.axis_3d,'Faces',tri,'Vertices',newpos,'facelighting','gouraud',...
    'FaceVertexCData',cmapv,'FaceColor','interp','EdgeColor','none','FaceAlpha',electrode.map_alpha,...
    'UserData',newmap);
material dull
% else
%     newpos=get(electrode.map_h,'Vertices');
%
%     newmap=F(newpos(:,1),newpos(:,2),newpos(:,3));
%
%     cmapv=zeros(length(newmap),3);
%     for i=1:length(newmap)
%         index=min(max(1,round((newmap(i)-cmin)/(cmax-cmin)*(size(cmap,1)-1))+1),size(cmap,1));
%         cmapv(i,:)=cmap(index,:);
%     end
%
%     set(electrode.map_h,'UserData',newmap,'FaceVertexCData',cmapv);
% end

% VolumeColormapCallback(obj);
end

