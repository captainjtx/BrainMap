function  LoadVolume(obj)
[FileName,FilePath,FilterIndex]=uigetfile({...
    '*.mat;*.nii',...
    'Supported formats (*.mat;*.nii)';...
    '*.mat','Matlab Format';...
    '*.nii','Neuroimaging Informatics Technology Initiative (NIfTI)'},...
    'Select your volume file','volume');
if ~FileName
    return
end

[~, ~, ext]=fileparts(FileName);

fpath=fullfile(FilePath,FileName);

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

obj.NotifyTaskStart('Loading volume ...');

cam_pos=[];
cam_target=[];
if ismember(ext,{'.nii','.mgz','.mgh','.bhdr','.hdr','.img','.nii.gz'})
    out= MRIread(fpath);
    volume=out.vol;

    vol_max=max(max(max(volume)));
    vol_min=min(min(min(volume)));
    volume=(volume-vol_min)/(vol_max-vol_min);
    
%     volume(volume==0)=nan;
%     tmp=histeq(reshape(volume,[],size(volume,3)));
%     volume=reshape(tmp,size(volume,1),size(volume,2),size(volume,3));
%     volume(isnan(volume))=0;
    pixdim=out.volres;
   
%     volume(volume>0.7)=0;

    %For usual axial scan only, e.g. vol(:,:,n) is an axial plane
    %Needs to be changed according to the scan direction
    if obj.JVolumeFlipLeftRight.isSelected();
        volume=flip(volume,2);
    end
    
    xdata=[0,pixdim(1)*size(volume,2)];
    ydata=[0,pixdim(2)*size(volume,1)];
    zdata=[0,pixdim(3)*size(volume,3)];
    
    %backward compatibility
%     volume=permute(volume,[3,2,1]);
%     pixdim=pixdim([3,2,1]);
%     
%     volume=fliplr(volume);
%     xdata=[0,pixdim(2)*size(volume,2)];
%     ydata=[0,pixdim(1)*size(volume,1)];
%     zdata=[0,pixdim(3)*size(volume,3)];
elseif strcmp(ext,'.mat')
    dat=load(fpath);
    volume=dat.volume;
    
    vol_max=max(max(max(volume)));
    vol_min=min(min(min(volume)));
    volume=(volume-vol_min)/(vol_max-vol_min);
    
    pixdim=ones(1,3);
    if isfield(dat,'PixelSpacing')
        pixdim(1:2)=dat.PixelSpacing;
    end
    if isfield(dat,'SpacingBetweenSlices')
        pixdim(3)=dat.SpacingBetweenSlices;
    end
    
    if isfield(dat,'CameraLocation')
        cam_pos=dat.CameraLocation;
    end
    
    if isfield(dat,'CameraTarget')
        cam_target=dat.CameraTarget;
    end
    
    xdata=[0,pixdim(2)*size(volume,2)];
    ydata=[0,pixdim(1)*size(volume,1)];
    zdata=[0,pixdim(3)*size(volume,3)];
    
    
end

axis(obj.axis_3d);

LightOffCallback(obj)

% [X,Y,Z]=meshgrid(1:size(volume,2),1:size(volume,1),1:size(volume,3));
% [newX,newY,newZ]=meshgrid(1:0.5:size(volume,2),1:0.5:size(volume,1),1:0.5:size(volume,3));
% newV=interp3(X,Y,Z,volume,newX,newY,newZ);

mapval=Volume;

mapval.volume=volume;
mapval.pixdim=pixdim;
mapval.xrange=xdata;
mapval.yrange=ydata;
mapval.zrange=zdata;

%%
%2D plot
mapval.h_sagittal=imagesc('Parent',obj.axis_sagittal,'XData',xdata,'YData',ydata,'CData',squeeze(volume(:,:,round(end/2))));
mapval.h_coronal=imagesc('Parent',obj.axis_coronal,'XData',xdata,'YData',zdata,'CData',squeeze(volume(:,round(end/2),:)));
mapval.h_axial=imagesc('Parent',obj.axis_axial,'XData',ydata,'YData',zdata,'CData',squeeze(volume(round(end/2),:,:)));

num=obj.JFileLoadTree.getVolumeID()+1;
mapval.file=fpath;
mapval.ind=num;
mapval.checked=true;
mapval.campos=cam_pos;
mapval.camtarget=cam_target;

obj.mapObj([mapval.category,num2str(num)])=mapval;

VolumeColormapCallback(obj);
obj.JFileLoadTree.addVolume(fpath,true);
VolumeRenderCallback(obj);
if ~isempty(cam_pos)
    campos(obj.axis_3d,cam_pos);
end

if ~isempty(cam_target)
    camtarget(obj.axis_3d,cam_target);
end
obj.NotifyTaskEnd('Volume load complete !');
end

