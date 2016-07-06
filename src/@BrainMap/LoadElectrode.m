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

if ~isfield(tmp,'norm')||isempty(tmp.norm)
    tmp.norm=tmp.coor;
end

if ~isfield(tmp,'channame')||isempty(tmp.channame)
    tmp.channame=num2cell(1:size(tmp.coor,1));
    tmp.channame=cellfun(@num2str,tmp.channame,'UniformOutput',false);
end

if ~isfield(tmp,'map')||isempty(tmp.map)
    tmp.map=ones(size(tmp.coor,1),1)*nan;
end

if ~isfield(tmp,'map_sig')||isempty(tmp.map_sig)
    tmp.map_sig=zeros(size(tmp.coor,1),1);
end
    

num=obj.JFileLoadTree.getElectrodeID+1;

electrode=Electrode;

for i=1:size(tmp.coor,1)
    userdat.ele=num;
    userdat.name=tmp.channame{i};
    
    [faces,vertices] = createContact3D(tmp.coor(i,:),tmp.norm(i,:),tmp.radius(i),tmp.thickness(i));
    
    if tmp.map_sig(i)==0
        col=tmp.color(i,:);
    else
        col=obj.ecolor;
    end
    electrode.handles(i)=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
        'facecolor',col,'edgecolor','none','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
end
material dull;

electrode.file=fpath;
electrode.ind=num;
electrode.coor=tmp.coor;
electrode.radius=tmp.radius;
electrode.thickness=tmp.thickness;
electrode.color=tmp.color;
electrode.norm=tmp.norm;
electrode.checked=true;
electrode.selected=ones(size(electrode.coor,1),1)*true;
electrode.channame=tmp.channame;
electrode.map=tmp.map;
electrode.map_sig=tmp.map_sig;

electrode.radius_ratio=ones(size(electrode.coor,1),1);
electrode.thickness_ratio=ones(size(electrode.coor,1),1);

if any(~isnan(electrode.map))
    electrode=obj.redrawNewMap(electrode);
end

obj.mapObj([electrode.category,num2str(num)])=electrode;
obj.JFileLoadTree.addElectrode(fpath,true);
end


