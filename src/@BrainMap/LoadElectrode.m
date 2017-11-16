function LoadElectrode( obj )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[filename,pathname,FilterIndex]=uigetfile({'*.mat;*.txt','Data format (*.mat,*.txt)'},'Please select electrode file');
fpath=[pathname filename];
if ~filename
    return;
end

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

[~,~,ext]=fileparts(fpath);

if strcmp(ext,'.mat')
    tmp=load(fpath,'-mat');
elseif strcmp(ext,'.txt')
    tmp=ReadPositionFromTxt(fpath);
end

if ~isfield(tmp,'coor')||isempty(tmp.coor)
    errordlg('No coordinates !');
end

if ~isfield(tmp,'radius')||isempty(tmp.radius)
    tmp.radius=ones(size(tmp.coor,1),1)*0.5;
end

if ~isfield(tmp,'thickness')||isempty(tmp.thickness)
    tmp.thickness=ones(size(tmp.coor,1),1)*0.4;
end

if ~isfield(tmp,'color')||isempty(tmp.color)
    tmp.color=ones(size(tmp.coor,1),1)*[1,0.8,0.6];
end

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
    
if ~isfield(tmp,'count')||isempty(tmp.count)
    tmp.count=0;
end

num=obj.JFileLoadTree.getElectrodeID+1;

electrode=Electrode;

for i=1:size(tmp.coor,1)
    userdat.ele=electrode;
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
electrode.count=tmp.count;

electrode.radius_ratio=ones(size(electrode.coor,1),1);
electrode.thickness_ratio=ones(size(electrode.coor,1),1);

if any(~isnan(electrode.map))
    electrode=obj.redrawNewMap(electrode);
end

obj.mapObj([electrode.category,num2str(num)])=electrode;
obj.JFileLoadTree.addElectrode(fpath,true);
end

function electrode = ReadPositionFromTxt(filename)
%Montage file formats:
%ChannelName,x_pos,y_pos,z_pos(optional)
fileID = fopen(filename);
C = textscan(fileID,'%f %f %f',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);
electrode.coor=[C{1} C{2} C{3}];
end


