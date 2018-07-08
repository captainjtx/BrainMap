classdef BrainMap < handle
    %ELE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Dependent)
        valid
        brainmap_path
        ecolor
        
        cfg_name
        toolpane
        
        SelectedElectrode
        
        SelectedSurface
        
        SelectedVolume
        
    end
    
    properties
        fig
        axis_3d
        axis_sagittal
        axis_coronal
        axis_axial
        
        FileMenu
        JFileMenu
        JLoadMenu
        JLoadVolumeMenu
        JLoadSurfaceMenu
        JLoadElectrodeMenu
        
        JSaveAsMenu
        JSaveAsVolumeMenu
        JSaveAsSurfaceMenu
        JSaveAsElectrodeMenu
        JSaveAsFigureMenu
        
        SettingsMenu
        JSettingsMenu
        JSettingsBackgroundColorMenu
        
        ElectrodeMenu
        JElectrodeMenu
        JElectrodeRotateMenu
        JElectrodeRotateLeftMenu
        JElectrodeRotateRightMenu
        JElectrodeRotateUpMenu
        JElectrodeRotateDownMenu
        
        JElectrodePushPullMenu
        JElectrodePullOutMenu
        JElectrodePushInMenu
        
        JElectrodeSpinMenu
        JElectrodeSpinClockwiseMenu
        JElectrodeSpinCounterClockwiseMenu
        
        JElectrodeTiltMenu
        JElectrodeTiltOutMenu
        JElectrodeTiltInMenu
        
        JElectrodeMoveSensitivity
        
        ViewMenu
        JViewMenu
        JViewLayoutMenu
        JViewCameraMenu
        JViewCameraSpecifyMenu
        JViewCameraLoadMenu
        JViewCameraSaveMenu
        JViewLayoutOneMenu
        JViewLayoutTwoTwoMenu
        JViewLayoutOneThreeHorizontalMenu
        JViewLayoutOneThreeVerticalMenu
        
        JViewLayoutSagittalMenu
        JViewLayoutCoronalMenu
        JViewLayoutAxialMenu
        JViewLayout3DMenu
        
        JViewInterfaceMenu
        JViewInterfaceVolumeMenu
        JViewInterfaceSurfaceMenu
        JViewInterfaceElectrodeMenu
        
        ViewPanel
        View3DPanel
        ViewSagittalPanel
        ViewCoronalPanel
        ViewAxialPanel
        
        InfoPanel
        
        Toolbar
        JToolbar
        
        JRecenter
        
        JTogNavigation
        JTogNewElectrode
        JTogPickElectrode
        
        JFileLoadTree
        JLight
        JCanvasColor
        
        JZoomIn
        JZoomOut
        
        IconLightOn
        IconLightOff
        
        IconLoadSurface
        IconDeleteSurface
        IconNewSurface
        IconSaveSurface
        
        IconLoadVolume
        IconDeleteVolume
        IconNewVolume
        IconSaveVolume
        Icon3DVolume
        
        IconLoadElectrode
        IconDeleteElectrode
        IconNewElectrode
        IconSaveElectrode
        
        
        JLoadBtn
        JDeleteBtn
        JNewBtn
        JSaveBtn
        
        SidePanel
        toolbtnpane
        
        surfacetoolpane
        electrodetoolpane
        volumetoolpane
        
        JSurfaceAlphaSpinner
        JSurfaceAlphaSlider
        
        JSurfaceDownsampleSpinner
        
        VolumeColorMapPopup
        
        JVolumeMinSpinner
        JVolumeMaxSpinner
        JVolumeSmoothSpinner
        JVolumeFlipLeftRight
        
        JElectrodeColorBtn
        JExtraBtn1
        JExtraBtn2
        
        JElectrodeRadiusSpinner
        JElectrodeThicknessSpinner
        
        JElectrodeRadiusRatioSpinner
        JElectrodeThicknessRatioSpinner
        
        IconInterpolateElectrode
        IconLoadMap
        
        HExtraBtn1
        HExtraBtn2
        
        JSettingsBtn
        
        JMapMaxSpinner
        JMapMinSpinner
        
        MapColorMapPopup
        
        JMapAlphaSpinner
        JMapAlphaSlider
        
        JMapInterpolationSpinner
        JMapTriCanvas
        JMapOnlyShowSig
        
        TextInfo1
        TextInfo2
        TextInfo3
        
    end
    properties
        light
        RotateTimer
        ZoomTimer
        loc
        
        inView
        
        mapObj
        
        cmin
        cmax
        
        smooth_sigma
        
        electrode_settings
        
        cmapList
        cfg
        
        move_sensitivity
        
        grid_col
        grid_row
        grid_r
        grid_spacing
        grid_thickness
    end
    
    methods
        function obj=BrainMap()
            if exist(obj.cfg_name,'file')==2
                obj.cfg=load(obj.cfg_name,'-mat');
            else
                cfg.layout=[1,4];%1 3D
                cfg.interface=1;%volume
                obj.cfg=cfg;
                
            end
            
            obj.varinit();
            
            obj.electrode_settings=ElectrodeSettings(obj);
            addlistener(obj,'CameraPositionChange',@(src,evt) updateCameraPosition(obj));
        end
        
        function val=get.SelectedElectrode(obj)
            id=char(obj.JFileLoadTree.getSelectedItem());
            val=[];
            if isempty(id)
                return
            end
            
            if ~isempty(regexp(id,'^Electrode','ONCE'))&&~strcmp(id,'Electrode')
                val=obj.mapObj(id);
            end
        end
        
        function val=get.SelectedSurface(obj)
            id=char(obj.JFileLoadTree.getSelectedItem());
            val=[];
            if isempty(id)
                return
            end
            
            if ~isempty(regexp(id,'^Surface','ONCE'))&&~strcmp(id,'Surface')
                val=obj.mapObj(id);
            end
        end
        
        function val=get.SelectedVolume(obj)
            id=char(obj.JFileLoadTree.getSelectedItem());
            val=[];
            if isempty(id)
                return
            end
            
            if ~isempty(regexp(id,'^Volume','ONCE'))&&~strcmp(id,'Volume')
                val=obj.mapObj(id);
            end
        end
        
        
        function val=get.cfg_name(obj)
            val=[obj.brainmap_path,'/db/cfg/brainmap.cfg'];
        end
        
        function val=get.ecolor(obj)
            val=[ obj.JElectrodeColorBtn.getBackground().getRed(),...
                obj.JElectrodeColorBtn.getBackground().getGreen(),...
                obj.JElectrodeColorBtn.getBackground().getBlue()]/255;
        end
        function val=get.brainmap_path(obj)
            [val,~,~]=fileparts(which('brainmap.m'));
        end
        function val=get.toolpane(obj)
            if strcmpi(get(obj.volumetoolpane,'visible'),'on');
                val=1;
            elseif strcmpi(get(obj.surfacetoolpane,'visible'),'on');
                val=2;
            elseif strcmpi(get(obj.electrodetoolpane,'visible'),'on');
                val=3;
            end
        end
        function val=get.valid(obj)
            try
                val=~isempty(obj.fig)&&ishandle(obj.fig);
            catch
                val=0;
            end
        end
        function varinit(obj)
            obj.light=[];
            obj.inView=[];
            
            obj.mapObj=containers.Map;
            
            obj.cmin=0;
            obj.cmax=1;
            
            obj.smooth_sigma=0;
            obj.move_sensitivity=1;
            
            obj.grid_col=12;
            obj.grid_row=10;
            obj.grid_r=0.6;
            obj.grid_spacing=4;
            obj.grid_thickness=0.4;
        end
        
        function OnClose(obj)
            try
                delete(obj.fig);
            catch
            end
            try
                delete(obj.RotateTimer)
            catch
            end
            obj.electrode_settings.OnClose();
            obj.fig=[];
            
            saveConfig(obj);
        end
        
        function f=panon(obj)
            f=strcmp(get(pan(obj.fig),'Enable'),'on');
        end
        function f=isIn(obj,cursor,position)
            f=cursor(1)>position(1)&&cursor(1)<position(1)+position(3)&&cursor(2)>position(2)&&cursor(2)<position(2)+position(4);
        end

        
        function MouseUp_View(obj)
            %             set(obj.fig,'windowbuttonmotionfcn',[]);    % unassign windowbuttonmotionfcn
            set(obj.fig,'windowbuttonupfcn',[]);        % unassign windowbuttonupfcn
            stop(obj.RotateTimer);
        end
        
        function RotateTimerCallback(obj)
            locend = get(obj.fig, 'CurrentPoint'); % get mouse location
            dx = locend(1) - obj.loc(1);           % calculate difference x
            dy = locend(2) - obj.loc(2);           % calculate difference y
            factor = 2;                         % correction mouse -> rotation
            camorbit(obj.axis_3d,-dx/factor,-dy/factor,'camera');
            
            if ~isempty(obj.light)
                obj.light = camlight(obj.light,'headlight');        % adjust light
            end
            obj.loc=locend;
            notify(obj,'CameraPositionChange');
        end
        
        function Scroll_View(obj,src,evt)
            vt=-evt.VerticalScrollCount;
            factor=1.05^vt;
            camzoom(obj.axis_3d,factor);
        end
        
        function SaveAsFigure(obj)
            obj.NotifyTaskStart('Printing figure ...')
            
            position=getpixelposition(obj.ViewPanel);
            figpos=get(obj.fig,'position');
            position(1)=position(1)+figpos(1);
            position(2)=position(2)+figpos(2);
            f=figure('Name','Axis 3D','Position',position,'visible','on','color',get(obj.ViewPanel,'BackgroundColor'));
            listIdx = get(obj.VolumeColorMapPopup,'Value');
            cmapName=get(obj.VolumeColorMapPopup,'UserData');
            cmapName=cmapName{listIdx};
            colormap(f,lower(cmapName));
            
            newp=copyobj(obj.ViewPanel,f);
            set(newp,'units','normalized','position',[0,0,1,1]);

            obj.NotifyTaskEnd('Figure print complete !');
        end
        
        function NotifyTaskStart(obj,str)
            set(obj.TextInfo2,'String',str,'fontunits','normalized','fontsize',0.3,...
                'ForegroundColor',[12,60,38]/255,'HorizontalAlignment','center');
            drawnow
        end
        function NotifyTaskEnd(obj,str)
            set(obj.TextInfo2,'String',str,'fontunits','normalized','fontsize',0.3,...
                'ForegroundColor',[12,60,38]/255,'HorizontalAlignment','center');
            drawnow
        end
        function RecenterCallback(obj)
            obj.NotifyTaskStart('Reset origin ...');
            vol=obj.SelectedVolume;
            surface=obj.SelectedSurface;
            
            if ~isempty(vol)
                [center,~]=getVolumeCenter(vol.volume,vol.xrange,vol.yrange,vol.zrange);
                camtarget(obj.axis_3d,center);
            elseif ~isempty(surface)
                center=mean(surface.vertices,1);
                camtarget(obj.axis_3d,center);
            else
                camtarget(obj.axis_3d,'auto');
            end
            obj.NotifyTaskEnd('Origin reset complete !');
        end
        
        function CheckChangedCallback(obj,src,evt)
            obj.NotifyTaskStart('Add/Remove objects from axis ...');
            mapval=obj.mapObj(char(evt.getKey()));
            
            switch mapval.category
                case 'Electrode'
                    if evt.ischecked
                        set(mapval.handles,'visible','on');
                        mapval.checked=true;
                    else
                        set(mapval.handles,'visible','off');
                        mapval.checked=false;
                    end
                    if mapval.ind==obj.electrode_settings.select_ele
                        notify(obj,'ElectrodeSettingsChange')
                    end
                case 'Volume'
                    if evt.ischecked
                        set(mapval.handles,'visible','on');
                        set(mapval.h_sagittal,'visible','on');
                        set(mapval.h_coronal,'visible','on');
                        set(mapval.h_axial,'visible','on');
                        if ~isempty(mapval.campos)
                            campos(obj.axis_3d,mapval.campos);
                            notify(obj,'CameraPositionChange');
                        end
                        if ~isempty(mapval.camtarget)
                            camtarget(obj.axis_3d,mapval.camtarget);
                        end
                        mapval.checked=true;
                    else
                        set(mapval.handles,'visible','off');
                        set(mapval.h_sagittal,'visible','off');
                        set(mapval.h_coronal,'visible','off');
                        set(mapval.h_axial,'visible','off');
                        mapval.campos=get(obj.axis_3d,'CameraPosition');
                        mapval.camtarget=get(obj.axis_3d,'CameraTarget');
                        mapval.checked=false;
                    end 
                case 'Surface'
                    if evt.ischecked
                        set(mapval.handles,'visible','on');
                        mapval.checked=true;
                    else
                        set(mapval.handles,'visible','off');
                        mapval.checked=false;
                    end 
                    
            end
            
            
            obj.NotifyTaskEnd('Add/Remove objects complete !');
        end
        
        function LightOffCallback(obj)
            obj.JLight.setIcon(obj.IconLightOn);
            obj.JLight.setToolTipText('Light on');
            try
                delete(obj.light);
                delete(findobj(obj.axis_3d,'type','light'));
            catch
            end
            obj.light=[];
            set(handle(obj.JLight,'CallbackProperties'),'MousePressedCallback',@(h,e) LightOnCallback(obj));
        end
        
        function LightOnCallback(obj)
            obj.JLight.setIcon(obj.IconLightOff);
            obj.JLight.setToolTipText('Light off');
            obj.light=camlight('headlight','infinite');
            set(handle(obj.JLight,'CallbackProperties'),'MousePressedCallback',@(h,e) LightOffCallback(obj));
            material dull;
        end
        
        
        function NewSurface(obj)
        end
        function NewVolume(obj)
        end
        
        function SaveVolume(obj)
        end
        function SaveSurface(obj)
        end
        function SurfaceAlphaSpinnerCallback(obj)
            
            alpha=obj.JSurfaceAlphaSpinner.getValue();
            
            obj.JSurfaceAlphaSlider.setValue(alpha);
            drawnow
            surface=obj.SelectedSurface;
            if ~isempty(surface)
                set(surface.handles,'facealpha',alpha/100);
            end
        end
        
        function SurfaceAlphaSliderCallback(obj)
            alpha=obj.JSurfaceAlphaSlider.getValue();
            
            obj.JSurfaceAlphaSpinner.setValue(alpha);
            drawnow
            
            surface=obj.SelectedSurface;
            if ~isempty(surface)
                set(surface.handles,'facealpha',alpha/100);
            end
        end
        
        function SurfaceDownsampleSpinnerCallback(obj)
            obj.NotifyTaskStart('Reduce surface patches...');
            
            downsample=obj.JSurfaceDownsampleSpinner.getValue();        
            drawnow
            
            downsample=downsample/100;
            
            surface=obj.SelectedSurface;
            if ~isempty(surface)
                [faces,vertices]=reducepatch(surface.faces,surface.vertices,downsample);
                axis(obj.axis_3d);
                
                alpha=get(surface.handles,'facealpha');
                delete(surface.handles);
                
                surface.handles=patch('parent',obj.axis_3d,'faces',faces,'vertices',vertices,...
                    'edgecolor','none','facecolor',[0.85 0.85 0.85],...
                    'facealpha',alpha,'FaceLighting','gouraud');
                surface.downsample=downsample;
                material dull
%                 axis vis3d
            end
            
            obj.NotifyTaskStart('Surface downsample complete !');
        end
        
        function ChangeCanvasColor(obj)
            col=uisetcolor(get(obj.View3DPanel,'BackgroundColor'),'Background');
            set(obj.View3DPanel,'BackgroundColor',col);
            set(obj.ViewSagittalPanel,'BackgroundColor',col);
            set(obj.ViewCoronalPanel,'BackgroundColor',col);
            set(obj.ViewAxialPanel,'BackgroundColor',col);
        end
        
        function VolumeColormapCallback(obj)
            listIdx = get(obj.VolumeColorMapPopup,'Value');

            cmapName=get(obj.VolumeColorMapPopup,'UserData');
            cmapName=cmapName{listIdx};
            
            colormap(obj.axis_3d,lower(cmapName));
            colormap(obj.axis_sagittal,lower(cmapName));
            colormap(obj.axis_coronal,lower(cmapName));
            colormap(obj.axis_axial,lower(cmapName));
        end
        function VolumeScaleSpinnerCallback(obj)
            min=obj.JVolumeMinSpinner.getValue();
            max=obj.JVolumeMaxSpinner.getValue();
            
            drawnow
            
            if min<max
                obj.cmin=min;
                obj.cmax=max;
                set(obj.axis_3d,'clim',[obj.cmin,obj.cmax]);
            end
        end
        function ElectrodeColorCallback(obj)
            newcol=uisetcolor(obj.ecolor,'Electrode');
            obj.JElectrodeColorBtn.setBackground(java.awt.Color(newcol(1),newcol(2),newcol(3)));
            
            electrode=obj.SelectedElectrode;
            if ~isempty(electrode)
                set(electrode.handles(logical(electrode.selected)),'facecolor',newcol);
                electrode.color(logical(electrode.selected),:)=ones(sum(electrode.selected),1)*newcol;
                if electrode.ind==obj.electrode_settings.select_ele
                    notify(obj,'ElectrodeSettingsChange')
                end
            end
        end
       
        function ClickOnElectrode(obj,src,evt)
            dat=get(src,'UserData');
            electrode = dat.ele;
            type=get(obj.fig,'selectiontype');

            datind=strcmp(dat.name,electrode.channame);
            switch type
                case 'normal'
                    electrode.selected=ones(size(electrode.selected))*false;
                    electrode.selected(datind)=true;
                case 'alt'
                    electrode.selected(datind)=~electrode.selected(datind);
            end
            
            set(electrode.handles,'edgecolor','none');
            set(electrode.handles(logical(electrode.selected)),'edgecolor','y');
            
            if obj.electrode_settings.valid
                if electrode.ind==obj.electrode_settings.select_ele.ind
                    notify(obj,'ElectrodeSettingsChange')
                end
            end
            
            obj.NotifyTaskStart({dat.name,num2str(electrode.coor(datind,:))});
        end
        

        
        function maps=getCheckedObjects(obj,opt)
            allvalues=obj.mapObj.values;
            maps={};
            for i=1:length(allvalues)
                if strcmpi(allvalues{i}.category,opt)
                    if allvalues{i}.checked
                        maps=cat(1,maps,allvalues(i));
                    end
                end
            end
        end
        
        function VolumeSettingsCallback(obj)
        end
        function ElectrodeSettingsCallback(obj)
            obj.electrode_settings.buildfig();
        end
        function SurfaceSettingsCallback(obj)
        end
        
        function MapAlphaSliderCallback(obj)
            alpha=obj.JMapAlphaSlider.getValue();
            obj.JMapAlphaSpinner.setValue(alpha);
            drawnow
            
            electrode=obj.SelectedElectrode;
            if ~isempty(electrode)
                electrode.map_alpha=alpha/100;
                
                if is_handle_valid(electrode.map_h)
                    set(electrode.map_h,'FaceAlpha',alpha/100);
                end
            end
        end
        function MapAlphaSpinnerCallback(obj)
            alpha=obj.JMapAlphaSpinner.getValue();
            obj.JMapAlphaSlider.setValue(alpha);
            drawnow
            
            electrode=obj.SelectedElectrode;
            if ~isempty(electrode)
                electrode.map_alpha=alpha/100;
                
                if is_handle_valid(electrode.map_h)
                    set(electrode.map_h,'FaceAlpha',alpha/100);
                end
            end
        end
        
        function resize(obj)
            if isempty(obj.fig)
                return
            end
            
            pos=get(obj.fig,'position');
            
            side_h=max(pos(4)-100,600);
            side_w=side_h/2;
            
            pos(3)=max(pos(3),side_w);
            pos(4)=max(pos(4),side_h);
            
            set(obj.ViewPanel,'position',[0,pos(4)-side_h,pos(3)-side_w,side_h]);
            set(obj.SidePanel,'position',[pos(3)-side_w,pos(4)-side_h,side_w,side_h]);
            set(obj.InfoPanel,'position',[0,0,pos(3),pos(4)-side_h]);
            
            set(obj.fig,'position',pos);
        end
        
        
        function saveConfig(obj)
            newcfg=obj.cfg;
            fpath=fileparts(obj.cfg_name);
            
            if exist(fpath,'dir')==7
                save(obj.cfg_name,'-struct','newcfg','-mat');
            else
                mkdir(fpath);
                save(obj.cfg_name,'-struct','newcfg','-mat');
            end
        end
        
        function DeleteElectrode( obj )
            electrode=obj.SelectedElectrode;
            if ~isempty(electrode)
                try
                    delete(electrode.handles);
                catch
                end
                try
                    delete(electrode.map_h);
                catch
                end
                remove(obj.mapObj,['Electrode',num2str(obj.SelectedElectrode.ind)]);
                obj.JFileLoadTree.deleteSelectedNode();
            end
            
        end
        function DeleteSurface( obj )
            surface=obj.SelectedSurface;
            if ~isempty(surface)
                try
                    delete(surface.handles);
                catch
                end
                remove(obj.mapObj,['Surface',num2str(obj.SelectedSurface.ind)]);
                obj.JFileLoadTree.deleteSelectedNode();
            end
        end
        
        
        function DeleteVolume(obj)
            volume=obj.SelectedVolume;
            if ~isempty(volume)
                try
                    delete(volume.handles);
                catch
                end
                try
                    delete(volume.h_sagittal);
                catch
                end
                try
                    delete(volume.h_coronal);
                catch
                end
                try
                    delete(volume.h_axial);
                catch
                end
                remove(obj.mapObj,['Volume',num2str(obj.SelectedVolume.ind)]);
                obj.JFileLoadTree.deleteSelectedNode();
            end
        end
        function ChangeInterface(obj,src)
            if obj.JViewInterfaceVolumeMenu.isSelected()
                obj.JFileLoadTree.clickVolume();
            elseif obj.JViewInterfaceSurfaceMenu.isSelected()
                obj.JFileLoadTree.clickSurface();
            elseif obj.JViewInterfaceElectrodeMenu.isSelected()
                obj.JFileLoadTree.clickElectrode();
            end
        end
        function SaveElectrode(obj)
            electrode=obj.SelectedElectrode;
            if ~isempty(electrode)
                electrode.save();
            end
        end
        
        function MapShowSigCallback(obj)
            electrode=obj.SelectedElectrode;
            if ~isempty(electrode)
                electrode=obj.redrawNewMap(electrode);
            end
        end
        
        function SpecifyCamera(obj)
            prompt={'Camera Target','Camera Position'};
            
            def={num2str(camtarget(obj.axis_3d)),num2str(campos(obj.axis_3d))};
            
            title='Camera specification';
            
            answer=inputdlg(prompt,title,1,def);
            
            if isempty(answer)
                return
            end
            
            ct=str2num(answer{1});
            
            if ~isempty(ct)&&~any(isnan(ct))
                camtarget(obj.axis_3d,ct);
            end
            
            cp=str2num(answer{2});
            if ~isempty(cp)&&~any(isnan(cp))
                campos(obj.axis_3d,cp);
            end
        end
        
        function SaveCamera(obj)
            [FileName,FilePath,~]=uiputfile({'*.txt';'*.csv'}...
                ,'save your camera view','view');
            if FileName~=0
                filename=fullfile(FilePath,FileName);
                fid=fopen(filename,'w');
                
                ct=camtarget(obj.axis_3d);
                cp=campos(obj.axis_3d);
                fprintf(fid,'%s\n%s\n%f,%f,%f\n%s\n%f,%f,%f','%Rows commented by % will be ignored',...
                    '%Camera Target',ct(1),ct(2),ct(3),...
                    '%Camera Position',cp(1),cp(2),cp(3));
                fclose(fid);
            end
        end
        function LoadCamera(obj)
            [FileName,FilePath,~]=uigetfile({...
                '*.txt';'*.csv'},...
                'Select your camera view file','view');
            if ~FileName
                return
            end
            
            filename=fullfile(FilePath,FileName);
            
            fileID = fopen(filename);
            C = textscan(fileID,'%f%f%f',...
                'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
            fclose(fileID);
            
            if ~any(isempty(C{1}))&&~any(isempty(C{2}))&&~any(isempty(C{3}))
                
                if length(C{1})==1&&length(C{2})==1&&length(C{3})==1
                    camtarget(obj.axis_3d,[C{1}(1),C{2}(1),C{3}(1)]);
                elseif length(C{1})==2&&length(C{2})==2&&length(C{3})==2
                    camtarget(obj.axis_3d,[C{1}(1),C{2}(1),C{3}(1)]);
                    campos(obj.axis_3d,[C{1}(2),C{2}(2),C{3}(2)]);
                    notify(obj,'CameraPositionChange');
                end
            end
        end
        
        function updateCameraPosition(obj)
            p=campos(obj.axis_3d);
            info={[num2str(p(1),'%5.1f'),': Cam X'],[num2str(p(2),'%5.1f'),': Cam Y'],[num2str(p(3),'%5.1f'),': Cam Z']};
            set(obj.TextInfo3,'String',info,'FontSize',0.2,'Foregroundcolor','k','HorizontalAlignment','right');
        end
        
        function VolumeFlipCallback(obj)
        end
        
        function ZoomInCallback(obj)
            zoom(1.1);
        end
        function ZoomOutCallback(obj)
            zoom(1/1.1);
        end
    end
    methods
        LoadSurface(obj)
        LoadElectrode(obj)
        BuildToolbar(obj)
        BuildIOBar(obj)
        BuildFig(obj)
        TreeSelectionCallback(obj,src,evt)
        ElectrodeInterpolateCallback(obj)
        LoadMap(obj)
        MapColormapCallback(obj)
        MapSpinnerCallback(obj)
        electrode=redrawNewMap(obj,electrode)
        MapInterpolationCallback(obj)
        ElectrodeThicknessSpinnerCallback(obj)
        ElectrodeRadiusSpinnerCallback(obj)
        ElectrodeThicknessRatioSpinnerCallback(obj)
        ElectrodeRadiusRatioSpinnerCallback(obj)
        MoveElectrode(obj,opt)
        VolumeSmoothSpinnerCallback(obj)
        MouseMove(obj)
        KeyPress(obj,src,evt)
        MouseDown_View(obj)
        VolumeRenderCallback(obj)
        MakeMenu(obj)
        ChangeLayout(obj,src)
        NewElectrode(obj)
        MoveElectrodeSensitivity(obj)
    end
    events
        ElectrodeSettingsChange
        CameraPositionChange
    end
end
