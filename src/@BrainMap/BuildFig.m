function BuildFig(obj)
import javax.swing.JSlider;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.JButton;
import java.awt.Color;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import src.java.checkboxtree.FileLoadTree;

screensize=get(0,'ScreenSize');
obj.fig=figure('Menubar','none','Name',['Welcome to BrainMap ',char(169),'2016 Tianxiao Jiang'],...
    'units','pixels','position',[screensize(3)/2-500,screensize(4)/2-325,1000,660],...
    'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),'resize','on','Dockcontrols','off',...
    'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'ResizeFcn',@(src,evt) resize(obj));

obj.IconLoadSurface=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/load_surf.png']));
obj.IconDeleteSurface=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/delete_surf.png']));
obj.IconNewSurface=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/new_surf.png']));
obj.IconSaveSurface=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/save_surf.png']));

obj.IconLoadVolume=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/load_vol.png']));
obj.IconDeleteVolume=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/delete_vol.png']));
obj.IconNewVolume=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/new_vol.png']));
obj.IconSaveVolume=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/save_vol.png']));
obj.Icon3DVolume=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/vol3d.png']));

obj.IconLoadElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/load_electrode.png']));
obj.IconDeleteElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/delete_electrode.png']));
obj.IconNewElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/new_electrode.png']));
obj.IconSaveElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/save_electrode.png']));
obj.IconInterpolateElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/interpolate.png']));
obj.IconLoadMap=javaObjectEDT(javax.swing.ImageIcon([obj.brainmap_path,'/db/icon/map.png']));

MakeMenu(obj);
%==========================================================================
obj.ViewPanel=uipanel(obj.fig,'units','pixel','position',[0,60,700,600],'BorderType','none');
obj.InfoPanel=uipanel(obj.fig,'units','pixel','position',[0,0,1000,60]);
obj.SidePanel=uipanel(obj.fig,'units','pixel','position',[700,60,300,600],'BorderType','none');

obj.View3DPanel=uipanel(obj.ViewPanel,'units','normalized','position',[0,0,1,1],...
    'backgroundcolor','k','BorderType','line','visible','off');
obj.ViewSagittalPanel=uipanel(obj.ViewPanel,'units','normalized','position',[0,0,1,1],...
    'backgroundcolor','k','BorderType','line','visible','off');
obj.ViewCoronalPanel=uipanel(obj.ViewPanel,'units','normalized','position',[0,0,1,1],...
    'backgroundcolor','k','BorderType','line','visible','off');
obj.ViewAxialPanel=uipanel(obj.ViewPanel,'units','normalized','position',[0,0,1,1],...
    'backgroundcolor','k','BorderType','line','visible','off');

obj.axis_3d=axes('parent',obj.View3DPanel,'visible','off','CameraViewAngle',10);
daspect(obj.axis_3d,[1,1,1]);
obj.light=camlight('headlight','infinite');
material dull;

obj.axis_sagittal=axes('parent',obj.ViewSagittalPanel,'visible','off','units','normalized','position',[0,0,1,1]);
daspect(obj.axis_sagittal,[1,1,1]);
obj.axis_coronal=axes('parent',obj.ViewCoronalPanel,'visible','off','units','normalized','position',[0,0,1,1]);
daspect(obj.axis_coronal,[1,1,1]);
obj.axis_axial=axes('parent',obj.ViewAxialPanel,'visible','off','units','normalized','position',[0,0,1,1]);
daspect(obj.axis_axial,[1,1,1]);

obj.RotateTimer=timer('TimerFcn',@ (src,evts) RotateTimerCallback(obj),'ExecutionMode','fixedRate','BusyMode','drop','period',0.1);
%             obj.
obj.inView=obj.isIn(get(obj.fig,'CurrentPoint'),getpixelposition(obj.ViewPanel));

obj.BuildToolbar();

obj.JFileLoadTree=javaObjectEDT(FileLoadTree());
obj.JFileLoadTree.buildfig();

jh=obj.JFileLoadTree;
set(handle(jh,'CallbackProperties'),'TreeSelectionCallback',@(src,evt) TreeSelectionCallback(obj,src,evt));
set(handle(jh,'CallbackProperties'),'CheckChangedCallback',@(src,evt) CheckChangedCallback(obj,src,evt));
%             set(handle(obj.JFileLoadTree.span,'CallbackProperties'),'KeyTypedCallback',@(src,evt) KeyTypedCallback(obj,src,evt));

[jh,gh]=javacomponent(obj.JFileLoadTree.span,[0,0,1,1],obj.SidePanel);
set(gh,'Units','Norm','Position',[0,0.8,1,0.2]);

obj.toolbtnpane=uipanel(obj.SidePanel,'units','normalized','position',[0,0.73,1,0.07]);

obj.BuildIOBar();
%%
%suface tool pane==========================================================
obj.surfacetoolpane=uipanel(obj.SidePanel,'units','normalized','position',[0,0,1,0.73]);
%%
%surface downsample
uicontrol('parent',obj.surfacetoolpane,'style','text','units','normalized','position',[0,0.92,0.5,0.06],...
    'string','Surface downsample (%)','horizontalalignment','left','fontunits','normalized','fontsize',0.5);

model = javaObjectEDT(SpinnerNumberModel(100,0,100,10));  
obj.JSurfaceDownsampleSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JSurfaceDownsampleSpinner,[0,0,1,1],obj.surfacetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.92,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SurfaceDownsampleSpinnerCallback(obj));
%%
%surface opacity
uicontrol('parent',obj.surfacetoolpane,'style','text','units','normalized','position',[0,0.84,0.25,0.06],...
    'string','Opacity(%)','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
obj.JSurfaceAlphaSlider=javaObjectEDT(JSlider(JSlider.HORIZONTAL,0,100,90));
[jh,gh]=javacomponent(obj.JSurfaceAlphaSlider,[0,0,1,1],obj.surfacetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.82,0.45,0.1]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SurfaceAlphaSliderCallback(obj));

model = javaObjectEDT(SpinnerNumberModel(90,0,100,10));  
obj.JSurfaceAlphaSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JSurfaceAlphaSpinner,[0,0,1,1],obj.surfacetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) SurfaceAlphaSpinnerCallback(obj));

%%
%volume tool pane==========================================================

obj.volumetoolpane=uipanel(obj.SidePanel,'units','normalized','position',[0,0,1,0.73]);

%%
%volume colormap
uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0,0.92,0.25,0.06],...
    'string','Colormap','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
obj.VolumeColorMapPopup = colormap_popup('Parent',obj.volumetoolpane,'units','normalized','position',[0.25,0.9,0.75,0.08]);
set(obj.VolumeColorMapPopup,'Value',1,'Callback',@(src,evt)VolumeColormapCallback(obj));
%%
%volume color data limit
uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0,0.84,0.2,0.06],...
    'string','Min','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmin),[],java.lang.Double(1),java.lang.Double(0.1)));  
obj.JVolumeMinSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JVolumeMinSpinner,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) VolumeScaleSpinnerCallback(obj));

uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0.5,0.84,0.2,0.06],...
    'string','Max','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.cmax),java.lang.Double(0),[],java.lang.Double(0.1)));
obj.JVolumeMaxSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JVolumeMaxSpinner,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) VolumeScaleSpinnerCallback(obj));
%%
%volume smooth
uicontrol('parent',obj.volumetoolpane,'style','text','units','normalized','position',[0,0.74,0.5,0.06],...
    'string','Gaussian smooth kernel','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(obj.smooth_sigma),java.lang.Double(0),java.lang.Double(10),java.lang.Double(0.1)));
obj.JVolumeSmoothSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JVolumeSmoothSpinner,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.74,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) VolumeSmoothSpinnerCallback(obj));
%%
%volume flip
obj.JVolumeFlipLeftRight=javaObjectEDT(JRadioButton('Flip left and right',1));
[jh,gh]=javacomponent(obj.JVolumeFlipLeftRight,[0,0,1,1],obj.volumetoolpane);
set(gh,'Units','Norm','Position',[0,0.65,1,0.06]);
set(handle(jh,'CallbackProperties'),'MouseReleasedCallback',@(h,e) VolumeFlipCallback(obj));
%%
%electrode tool pane=======================================================
obj.electrodetoolpane=uipanel(obj.SidePanel,'units','normalized','position',[0,0,1,0.73]);
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.92,0.25,0.06],...
    'string','Color','horizontalalignment','left','fontunits','normalized','fontsize',0.5);

obj.JElectrodeColorBtn = javaObjectEDT(JPanel());
obj.JElectrodeColorBtn.setBorder(BorderFactory.createLineBorder(Color.black));
obj.JElectrodeColorBtn.setBackground(Color(1,0.8,0.6));
obj.JElectrodeColorBtn.setOpaque(true);
[jh, hContainer] = javacomponent(obj.JElectrodeColorBtn, [0,0,1,1], obj.electrodetoolpane);
set(hContainer, 'Units','norm','position',[0.25,0.93,0.22,0.05]);
set(handle(jh,'CallbackProperties'),'MousePressedCallback',@(h,e) ElectrodeColorCallback(obj));

%%
%radius and thickness
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.84,0.22,0.06],...
    'string','Radius','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(0.5,0,10,0.1));  
obj.JElectrodeRadiusSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeRadiusSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeRadiusSpinnerCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0.5,0.84,0.22,0.06],...
    'string','Thickness','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(0.4,0,10,0.1));  
obj.JElectrodeThicknessSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeThicknessSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.84,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeThicknessSpinnerCallback(obj));
%%
%radius and thickness percentage
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.74,0.22,0.06],...
    'string','%','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(100),java.lang.Integer(10),java.lang.Integer(500),java.lang.Integer(10)));  
obj.JElectrodeRadiusRatioSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeRadiusRatioSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.74,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeRadiusRatioSpinnerCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0.5,0.74,0.22,0.06],...
    'string','%','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(100),java.lang.Integer(10),java.lang.Integer(500),java.lang.Integer(10)));  
obj.JElectrodeThicknessRatioSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JElectrodeThicknessRatioSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.74,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) ElectrodeThicknessRatioSpinnerCallback(obj));
%%
%map colormap
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.62,0.25,0.06],...
    'string','Colormap','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
obj.MapColorMapPopup = colormap_popup('Parent',obj.electrodetoolpane,'units','normalized','position',[0.25,0.6,0.75,0.08]);
set(obj.MapColorMapPopup,'Value',4,'Callback',@(src,evt)MapColormapCallback(obj));
%%
%map color data limit
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.54,0.22,0.06],...
    'string','Min','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(-6),[],[],java.lang.Double(1)));  
obj.JMapMinSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JMapMinSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.54,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapSpinnerCallback(obj));

uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0.5,0.54,0.22,0.06],...
    'string','Max','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(6),[],[],java.lang.Double(1))); 
obj.JMapMaxSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JMapMaxSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.54,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapSpinnerCallback(obj));
%%
%map opacity
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.45,0.25,0.06],...
    'string','Opacity(%)','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
obj.JMapAlphaSlider=javaObjectEDT(JSlider(JSlider.HORIZONTAL,0,100,90));
[jh,gh]=javacomponent(obj.JMapAlphaSlider,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.25,0.43,0.45,0.1]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapAlphaSliderCallback(obj));

model = javaObjectEDT(SpinnerNumberModel(80,0,100,10));  
obj.JMapAlphaSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JMapAlphaSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.45,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapAlphaSpinnerCallback(obj));
%%
%map interpolation
uicontrol('parent',obj.electrodetoolpane,'style','text','units','normalized','position',[0,0.35,0.5,0.06],...
    'string','Map interpolation level','horizontalalignment','left','fontunits','normalized','fontsize',0.5);
model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(0),java.lang.Integer(0),java.lang.Integer(20),java.lang.Integer(1)));  
obj.JMapInterpolationSpinner =javaObjectEDT(JSpinner(model));
[jh,gh]=javacomponent(obj.JMapInterpolationSpinner,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0.75,0.35,0.22,0.06]);
set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MapInterpolationCallback(obj));
%%
%project 3d->2d
obj.JMapTriCanvas=javaObjectEDT(JRadioButton('Map triangulation based on 2D canvas'));
[jh,gh]=javacomponent(obj.JMapTriCanvas,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0,0.25,1,0.06]);
set(handle(jh,'CallbackProperties'),'MouseReleasedCallback',@(h,e) MapInterpolationCallback(obj));
%%
%significant
obj.JMapOnlyShowSig=javaObjectEDT(JRadioButton('Show only significant channels'));
[jh,gh]=javacomponent(obj.JMapOnlyShowSig,[0,0,1,1],obj.electrodetoolpane);
set(gh,'Units','Norm','Position',[0,0.15,1,0.06]);
set(handle(jh,'CallbackProperties'),'MouseReleasedCallback',@(h,e) MapShowSigCallback(obj));
%%
obj.TextInfo1=uicontrol('parent',obj.InfoPanel,'units','normalized','position',[0,0,0.2,1],...
    'style','Text','String','','HorizontalAlignment','left','fontweight','bold','fontunits','normalized','fontsize',0.2);

obj.TextInfo2=uicontrol('parent',obj.InfoPanel,'units','normalized','position',[0.2,0,0.6,1],...
    'style','Text','String','','HorizontalAlignment','left','fontweight','bold','fontunits','normalized','fontsize',0.15);

obj.TextInfo3=uicontrol('parent',obj.InfoPanel,'units','normalized','position',[0.8,0,0.2,1],...
    'style','Text','String','','HorizontalAlignment','left','fontweight','bold','fontunits','normalized','fontsize',0.2);

%%
set(obj.fig,'WindowButtonMotionFcn',@(src,evt) MouseMove(obj));
%%
p2=[obj.JViewLayoutSagittalMenu,obj.JViewLayoutCoronalMenu,obj.JViewLayoutAxialMenu,obj.JViewLayout3DMenu];
p1=[obj.JViewLayoutOneMenu,obj.JViewLayoutTwoTwoMenu,obj.JViewLayoutOneThreeHorizontalMenu,obj.JViewLayoutOneThreeVerticalMenu];
p1(obj.cfg.layout(1)).setSelected(true);
p2(obj.cfg.layout(2)).setSelected(true);

p3=[obj.JViewInterfaceVolumeMenu,obj.JViewInterfaceSurfaceMenu,obj.JViewInterfaceElectrodeMenu];
p3(obj.cfg.interface).setSelected(true);
end
%%
function h=colormap_popup(varargin)
cmapList = {'Gray','Bone', 'Copper','Jet', 'HSV', 'Hot', 'Cool', 'Spring', 'Summer', 'Autumn', ...
                 'Winter', 'Pink', 'Lines'}';
varargin=cat(2,varargin,{'style','popup','String',cmapList,'FontName','Courier','BackgroundColor','w'});
             
h=uicontrol(varargin{:});
allLength = cellfun(@numel,cmapList);
maxLength = max(allLength);
cmapHTML = [];
for i = 1:numel(cmapList)
    arrow = [repmat('-',1,maxLength-allLength(i)+1) '>'];
    cmapFun = str2func(['@(x) ' lower(cmapList{i}) '(x)']);
    cData = cmapFun(16);
    curHTML = ['<html>' cmapList{i} '<font color="#FFFFFF">' arrow '</font>'];
    for j = 1:16
        HEX = rgb2hex(cData(j,:));
        curHTML = [curHTML '<font bgcolor="' HEX '" color="' HEX '">_</font>'];
    end
    curHTML = [curHTML '</html>'];
    cmapHTML = [cmapHTML; {curHTML}];
end

set(h,'String',cmapHTML);
set(h,'UserData',cmapList);
end


