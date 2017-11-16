function NewElectrode(obj)
origin=camtarget(obj.axis_3d);
viewpos=campos(obj.axis_3d);

allkeys=keys(obj.mapObj);

R=0.15/2;
for i=1:length(allkeys)
    map=obj.mapObj(allkeys{i});
    if map.checked
        if ~isempty(regexp(allkeys{i},'^Surface','ONCE'))
            tri=convhulln(map.vertices);
            [points, ~, ~] = intersectLineMesh3d([origin(:);origin(:)-viewpos(:)], map.vertices, tri);
            [~,ind]=min(sum((points-ones(size(points,1),1)*viewpos(:)').^2,2));
            intersect_point=points(ind,:);
            R=norm(intersect_point(:)-origin(:))/1000;
        elseif ~isempty(regexp(allkeys{i},'^Volume','ONCE'))
            R=0.15/2;
        else
            R=0.15/2;
        end
    end
end
grid_center=origin+(viewpos-origin)/norm(viewpos-origin)*R*1000;
%%
prompt={'Row number','Column number',...
    'Contact radius (mm)','Contact distance (mm)',...
    'Contact thickness (mm)','Curvature (1/R)'};

def={num2str(obj.grid_row),num2str(obj.grid_col),num2str(obj.grid_r),num2str(obj.grid_spacing),num2str(obj.grid_thickness),num2str(1/R)};

title='Create new grid';

answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end
for i=1:length(answer)
    tmp=str2double(answer{i});
    if isempty(tmp)||isnan(tmp)
        errordlg('Invalid input !');
        return
    end
end

obj.grid_row=str2double(answer{1});
obj.grid_col=str2double(answer{2});
obj.grid_r=str2double(answer{3});
obj.grid_spacing=str2double(answer{4});
obj.grid_thickness=str2double(answer{5});
R=1/str2double(answer{6})*1000;
%%
new_origin=grid_center+(origin-viewpos)/norm(origin-viewpos)*R;

lfrange=linspace(-(obj.grid_col-1)/2,(obj.grid_col-1)/2,obj.grid_col)*obj.grid_spacing/R;
midrow=round(obj.grid_row/2);
udrange=((-(midrow-1)):(obj.grid_row-midrow))*obj.grid_spacing/R;

midcoor=[];
channame={};

for ind=1:length(lfrange)
    midcoor= cat(1,midcoor,perspectiveRotate(obj.axis_3d,grid_center(:)',0,lfrange(ind),new_origin));
end
coor=[];
for ind=1:length(udrange)
    coor= cat(1,coor,perspectiveRotate(obj.axis_3d,midcoor,udrange(ind),0,new_origin));
    
    newrow=cell(obj.grid_col,1);
    for i=1:obj.grid_col
        newrow{i}=['C',num2str((ind-1)*obj.grid_col+i)];
    end
    channame=cat(1,channame,newrow);
end

%%
fpath=fullfile(obj.brainmap_path,'db/electrode');
if ~isdir(fpath)
    mkdir(fpath);
end
fpath=fullfile(fpath,['new_',num2str(obj.grid_row),'_',num2str(obj.grid_col),'.mat']);

num=obj.JFileLoadTree.getElectrodeID+1;
electrode=Electrode;

for i=1:size(coor,1)
    userdat.ele=electrode;
    userdat.name=channame{i};
    
    [faces,vertices] = createContact3D(coor(i,:),coor(i,:)-origin(:)',obj.grid_r,obj.grid_thickness);
    
    electrode.handles(i)=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
        'facecolor',obj.ecolor,'edgecolor','none','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
end
material dull;

electrode.file=fpath;
electrode.ind=num;
electrode.coor=coor;
electrode.radius=ones(size(coor,1))*obj.grid_r;
electrode.thickness=ones(size(coor,1))*obj.grid_thickness;
electrode.color=ones(size(coor,1),1)*obj.ecolor(:)';
electrode.norm=coor-repmat(origin(:)',size(coor,1),1);
electrode.checked=true;
electrode.selected=ones(size(electrode.coor,1),1)*true;
electrode.channame=channame;
electrode.count=electrode.count+size(coor,1);

electrode.map_sig=zeros(size(coor,1),1);
electrode.map=ones(size(coor,1),1)*nan;

electrode.radius_ratio=ones(size(electrode.coor,1),1);
electrode.thickness_ratio=ones(size(electrode.coor,1),1);

% electrode=obj.redrawNewMap(electrode);

obj.mapObj([electrode.category,num2str(num)])=electrode;
obj.JFileLoadTree.addElectrode(fpath,true);
end

