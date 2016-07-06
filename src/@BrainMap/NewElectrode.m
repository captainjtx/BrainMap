function NewElectrode(obj)

prompt={'Row number','Column number',...
    'Contact radius (mm)','Contact distance (mm)',...
    'Contact thickness (mm)','Curvature (1/R)'};

def={'8','8','2','10','1.5',num2str(2/0.15)};

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

row=str2double(answer{1});
col=str2double(answer{2});
radius=str2double(answer{3});
dist=str2double(answer{4});
thickness=str2double(answer{5});
R=1/str2double(answer{6})*1000;

origin=camtarget(obj.axis_3d);
viewpos=campos(obj.axis_3d);

allkeys=keys(obj.mapObj);

grid_center=(viewpos-origin)/norm(viewpos-origin)*R;

for i=1:length(allkeys)
    map=obj.mapObj(allkeys{i});
    if map.checked
        if ~isempty(regexp(allkeys{i},'^Surface','ONCE'))
            tri=convhulln(map.vertices);
            [points, ~, ~] = intersectLineMesh3d([origin(:);origin(:)-viewpos(:)], map.vertices, tri);
            [~,ind]=min(sum((points-ones(size(points,1),1)*viewpos(:)').^2,2));
            grid_center=points(ind,:);
            R=norm(grid_center(:)-origin(:));
        elseif ~isempty(regexp(allkeys{i},'^Volume','ONCE'))
            
        else
            
        end
    end
end

%%


lfrange=linspace(-col/2,col/2,col)*dist/R;
midrow=round(row/2);
udrange=((-(midrow-1)):(row-midrow))*dist/R;



midcoor=[];
channame={};

for ind=1:length(lfrange)
    midcoor= cat(1,midcoor,perspectiveRotate(obj.axis_3d,grid_center(:)',0,lfrange(ind)));
end
coor=[];
for ind=1:length(udrange)
    coor= cat(1,coor,perspectiveRotate(obj.axis_3d,midcoor,udrange(ind),0));
    
    newrow=cell(col,1);
    for i=1:col
        newrow{i}=['C',num2str((ind-1)*col+i)];
    end
    channame=cat(1,channame,newrow);
end

%%
fpath=fullfile(obj.brainmap_path,'db/electrode');
if ~isdir(fpath)
    mkdir(fpath);
end
fpath=fullfile(fpath,['new_',num2str(row),'_',num2str(col),'.mat']);

num=obj.JFileLoadTree.getElectrodeID+1;
electrode=Electrode;

for i=1:size(coor,1)
    userdat.ele=num;
    userdat.name=channame{i};
    
    [faces,vertices] = createContact3D(coor(i,:),coor(i,:)-origin(:)',radius,thickness);
    
    electrode.handles(i)=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
        'facecolor',obj.ecolor,'edgecolor','none','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src,evt),'facelighting','gouraud');
end
material dull;

electrode.file=fpath;
electrode.ind=num;
electrode.coor=coor;
electrode.radius=ones(size(coor,1))*radius;
electrode.thickness=ones(size(coor,1))*thickness;
electrode.color=ones(size(coor,1),1)*obj.ecolor(:)';
electrode.norm=coor-repmat(origin(:)',size(coor,1),1);
electrode.checked=true;
electrode.selected=ones(size(electrode.coor,1),1)*true;
electrode.channame=channame;

electrode.radius_ratio=ones(size(electrode.coor,1),1);
electrode.thickness_ratio=ones(size(electrode.coor,1),1);

% electrode=obj.redrawNewMap(electrode);

obj.mapObj([electrode.category,num2str(num)])=electrode;
obj.JFileLoadTree.addElectrode(fpath,true);
end

