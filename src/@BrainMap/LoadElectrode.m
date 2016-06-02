function LoadElectrode( obj )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[filename,pathname]=uigetfile({'*.mat;*.txt','Data format (*.mat)'},'Please select electrode file');
fpath=[pathname filename];
if ~filename
    return;
end

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

tmp=load(fpath,'-mat');

if ~isfield(tmp,'norm')
    tmp.norm=tmp.coor;
end

if ~isfield(tmp,'channame')
    tmp.channame=num2cell(1:size(tmp.coor,1));
    tmp.channame=cellfun(@num2str,tmp.channame,'UniformOutput',false);
end

if ~isfield(tmp,'map')
    tmp.map=ones(size(tmp.coor,1),1)*nan;
end

if ~isfield(tmp,'map_sig')
    tmp.map_sig=zeros(size(tmp.coor,1),1);
end
    

num=obj.JFileLoadTree.addElectrode(fpath,true);

mapval=Electrode;

for i=1:size(tmp.coor,1)
    userdat.ele=num;
    userdat.name=tmp.channame{i};
    
    [faces,vertices] = createContact3D(tmp.coor(i,:),tmp.norm(i,:),tmp.radius(i),tmp.thickness(i));
    
    if tmp.map_sig(i)==0
        col=tmp.color(i,:);
    else
        col='w';
    end
    mapval.handles(i)=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
        'facecolor',col,'edgecolor','none','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
end
material dull;

mapval.file=fpath;
mapval.ind=num;
mapval.coor=tmp.coor;
mapval.radius=tmp.radius;
mapval.thickness=tmp.thickness;
mapval.color=tmp.color;
mapval.norm=tmp.norm;
mapval.checked=true;
mapval.selected=ones(size(mapval.coor,1),1)*true;
mapval.channame=tmp.channame;
mapval.map=tmp.map;
mapval.map_sig=tmp.map_sig;
mapval.map_h=[];
mapval.coor_interp=10;
mapval.map_alpha=0.8;
mapval.map_colormap='jet';
mapval.F=[];
mapval.radius_ratio=ones(size(mapval.coor,1),1);
mapval.thickness_ratio=ones(size(mapval.coor,1),1);

mapval=obj.redrawNewMap(mapval);

obj.mapObj([mapval.category,num2str(num)])=mapval;

end


