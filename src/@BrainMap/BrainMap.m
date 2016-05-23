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
        
        ViewMenu
        JViewMenu
        JViewLayoutMenu
        JViewCameraMenu
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
        VolumeColorMapPopup
        
        JVolumeMinSpinner
        JVolumeMaxSpinner
        JVolumeSmoothSpinner
        
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
        
        TextInfo
        
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
        end
        
        function val=get.SelectedElectrode(obj)
            id=char(obj.JFileLoadTree.getSelectedItem());
            val=[];
            if isempty(id)
                return
            end
            
            if regexp(id,'^Electrode')
                val=str2double(id(10:end));
                if isnan(val)
                    val=[];
                end
            end
        end
        function val=get.SelectedSurface(obj)
            id=char(obj.JFileLoadTree.getSelectedItem());
            val=[];
            if isempty(id)
                return
            end
            
            if regexp(id,'^Surface')
                val=str2double(id(8:end));
                if isnan(val)
                    val=[];
                end
            end
        end
        function val=get.SelectedVolume(obj)
            id=char(obj.JFileLoadTree.getSelectedItem());
            val=[];
            if isempty(id)
                return
            end
            
            if regexp(id,'^Volume')
                val=str2double(id(7:end));
                if isnan(val)
                    val=[];
                end
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
                val=ishandle(obj.fig)&&isvalid(obj.fig);
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
            camorbit(obj.axis_3d,-dx/factor,-dy/factor);
            
            if ~isempty(obj.light)
                obj.light = camlight(obj.light,'headlight');        % adjust light
            end
            obj.loc=locend;
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
            newp=copyobj(obj.ViewPanel,f);
            set(newp,'units','normalized','position',[0,0,1,1]);

            obj.NotifyTaskEnd('Figure print complete !');
        end
        
        function NotifyTaskStart(obj,str)
            set(obj.TextInfo,'String',str,'fontunits','normalized','fontsize',0.4,...
                'ForegroundColor',[12,60,38]/255,'HorizontalAlignment','center');
            drawnow
        end
        function NotifyTaskEnd(obj,str)
            set(obj.TextInfo,'String',str,'fontunits','normalized','fontsize',0.4,...
                'ForegroundColor',[12,60,38]/255,'HorizontalAlignment','center');
            drawnow
        end
        function RecenterCallback(obj)
            obj.NotifyTaskStart('Reset origin ...');
            if ~isempty(obj.SelectedVolume)
                vol=obj.mapObj(['Volume',num2str(obj.SelectedVolume)]);
                [center,~]=getVolumeCenter(vol.volume,vol.xrange,vol.yrange,vol.zrange);
                camtarget(obj.axis_3d,center);
            else
                camtarget(obj.axis_3d,'auto');
            end
            obj.NotifyTaskEnd('Origin reset complete !');
        end
        
        function CheckChangedCallback(obj,src,evt)
            obj.NotifyTaskStart('Add/Remove objects from axis ...');
            mapval=obj.mapObj(char(evt.getKey()));
            if evt.ischecked
                set(mapval.handles,'visible','on');
                mapval.checked=true;
            else
                set(mapval.handles,'visible','off');
                mapval.checked=false;
            end
            obj.mapObj(char(evt.getKey()))=mapval;
            if mapval.ind==obj.electrode_settings.select_ele
                notify(obj,'ElectrodeSettingsChange')
            end
            obj.NotifyTaskEnd('Add/Remove objects complete !');
        end
        
        function LightOffCallback(obj)
            obj.JLight.setIcon(obj.IconLightOn);
            obj.JLight.setToolTipText('Light on');
            try
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
        end
        
        function NewElectrode(obj)
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
            if ~isempty(obj.SelectEvt)&&obj.SelectEvt.level==2
                mapval=obj.mapObj(char(obj.SelectEvt.getKey()));
                set(mapval.handles,'facealpha',alpha/100);
            end
        end
        
        function SurfaceAlphaSliderCallback(obj)
            alpha=obj.JSurfaceAlphaSlider.getValue();
            
            obj.JSurfaceAlphaSpinner.setValue(alpha);
            drawnow
            if ~isempty(obj.SelectEvt)&&obj.SelectEvt.level==2
                mapval=obj.mapObj(char(obj.SelectEvt.getKey()));
                set(mapval.handles,'facealpha',alpha/100);
            end
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
            
            if ~isempty(obj.SelectedElectrode)
                electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
                set(electrode.handles(logical(electrode.selected)),'facecolor',newcol);
                
                electrode.color(logical(electrode.selected),:)=ones(sum(electrode.selected),1)*newcol;
                obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
                if electrode.ind==obj.electrode_settings.select_ele
                    notify(obj,'ElectrodeSettingsChange')
                end
            end
        end
       
        function ClickOnElectrode(obj,src,evt)
            dat=get(src,'UserData');
            electrode=obj.mapObj(['Electrode',num2str(dat.ele)]);
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
            
            obj.mapObj(['Electrode',num2str(dat.ele)])=electrode;
            
            if electrode.ind==obj.electrode_settings.select_ele
                notify(obj,'ElectrodeSettingsChange')
            end
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
            
            if ~isempty(obj.SelectedElectrode)
                electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
                electrode.map_alpha=alpha/100;
                
                if is_handle_valid(electrode.map_h)
                    set(electrode.map_h,'FaceAlpha',alpha/100);
                end
                
                obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
            end
        end
        function MapAlphaSpinnerCallback(obj)
            alpha=obj.JMapAlphaSpinner.getValue();
            obj.JMapAlphaSlider.setValue(alpha);
            drawnow
            
            if ~isempty(obj.SelectedElectrode)
                electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
                electrode.map_alpha=alpha/100;
                
                if is_handle_valid(electrode.map_h)
                    set(electrode.map_h,'FaceAlpha',alpha/100);
                end
                
                obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)])=electrode;
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
            if ~isempty(obj.SelectedElectrode)
                electrode=obj.mapObj(['Electrode',num2str(obj.SelectedElectrode)]);
                try
                    delete(electrode.handles);
                catch
                end
                try
                    delete(electrode.map_h);
                catch
                end
                remove(obj.mapObj,['Electrode',num2str(obj.SelectedElectrode)]);
                obj.JFileLoadTree.deleteSelectedNode();
            end
            
        end
        function DeleteSurface( obj )
            if ~isempty(obj.SelectedSurface)
                surface=obj.mapObj(['Surface',num2str(obj.SelectedSurface)]);
                try
                    delete(surface.handles);
                catch
                end
                obj.JFileLoadTree.deleteSelectedNode();
            end
        end
        
        
        function DeleteVolume(obj)
            if ~isempty(obj.SelectedVolume)
                volume=obj.mapObj(['Volume',num2str(obj.SelectedVolume)]);
                try
                    delete(volume.handles);
                catch
                end
                obj.JFileLoadTree.deleteSelectedNode();
            end
        end
        function ChangeInterface( obj,src )
            if obj.JViewInterfaceVolumeMenu.isSelected()
                obj.JFileLoadTree.clickVolume();
            elseif obj.JViewInterfaceSurfaceMenu.isSelected()
                obj.JFileLoadTree.clickSurface();
            elseif obj.JViewInterfaceElectrodeMenu.isSelected()
                obj.JFileLoadTree.clickElectrode();
            end
        end
        function SaveElectrode(obj)
            ele=obj.SelectedElectrode;
            if ~isempty(ele)
                electrode=obj.mapObj(['Electrode',num2str(ele)]);
                electrode.save();
            end
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
    end
    events
        ElectrodeSettingsChange
    end
end