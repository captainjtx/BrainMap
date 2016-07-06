function LoadSurface(obj)
[filename,pathname]=uigetfile({'*.mat;*.dfs;*.surf','Data format (*,mat,*.dfs,*.surf)'},'Please select surface data');
fpath=[pathname filename];
if filename==0
    return;
end

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

obj.NotifyTaskStart('Loading surface ...');

[~,~,type]=fileparts(fpath);

if strcmp(type, '.mat')
    dat=load(fpath);

    faces=dat.faces;
    vertices=dat.vertices;
elseif strcmp(type, '.dfs')
    %set(obj.info,'string','Reading surface data...');
    [NFV,hdr]=readdfs(fpath);
    
    faces=NFV.faces;
    vertices=NFV.vertices;

elseif strcmp(type,'.pial')
        %set(obj.info,'string','Reading surface data...');
        [vertices, faces] = mne_read_surface(fpath);
        %set(obj.info,'string','Reducing mesh...');
        if size(vertices,1)>2000000
            [faces,vertices]=reducepatch(faces,vertices,0.1);
        elseif size(vertices,1)>1000000
            [faces,vertices]=reducepatch(faces,vertices,0.5);
        end

else
    errordlg('Unrecognized data.', 'Wrong data format');
    return
end

axis(obj.axis_3d);

mapval=Surface;

mapval.handles=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
    'edgecolor','none','facecolor',[0.85 0.85 0.85],...
    'facealpha',1,'FaceLighting','gouraud');
hold on
axis vis3d

obj.light=camlight(obj.light,'headlight');

num=obj.JFileLoadTree.getSurfaceID()+1;

mapval.vertices=vertices;
mapval.faces=faces;
mapval.file=fpath;
mapval.ind=num;
mapval.checked=true;

obj.mapObj([mapval.category,num2str(num)])=mapval;

material dull
RecenterCallback(obj);
obj.JFileLoadTree.addSurface(fpath,true);

obj.NotifyTaskEnd('Surface load complete !');
end

