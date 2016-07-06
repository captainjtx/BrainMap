function TreeSelectionCallback(obj,src,evt)
import javax.swing.KeyStroke;
import java.awt.event.KeyEvent;
import java.awt.event.ActionEvent;
is_pc=ispc;
is_mac=ismac;

if ~strcmp(evt.oldcategory,evt.category)
    if strcmpi(evt.category,'Volume')
        obj.JLoadBtn.setIcon(obj.IconLoadVolume);
        obj.JLoadBtn.setToolTipText('Load volume');
        
        obj.JDeleteBtn.setIcon(obj.IconDeleteVolume);
        obj.JDeleteBtn.setToolTipText('Delete volume');
        
        obj.JNewBtn.setIcon(obj.IconNewVolume);
        obj.JNewBtn.setToolTipText('New volume');
        
        obj.JSaveBtn.setIcon(obj.IconSaveVolume);
        obj.JSaveBtn.setToolTipText('Save volume');
        
        obj.JExtraBtn1.setIcon(obj.Icon3DVolume);
        obj.JExtraBtn1.setToolTipText('3D rendering');
        
        set(obj.HExtraBtn1,'visible','on');
        set(obj.HExtraBtn2,'visible','off');
        
        set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadVolume(obj));
        set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteVolume(obj));
        set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewVolume(obj));
        set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveVolume(obj));
        set(handle(obj.JSettingsBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) VolumeSettingsCallback(obj));
        set(handle(obj.JExtraBtn1,'CallbackProperties'),'MousePressedCallback',@(h,e) VolumeRenderCallback(obj));
        
        set(obj.volumetoolpane,'visible','on');
        set(obj.surfacetoolpane,'visible','off');
        set(obj.electrodetoolpane,'visible','off');
        
        obj.JLoadSurfaceMenu.setAccelerator([]);
        obj.JLoadElectrodeMenu.setAccelerator([]);
        obj.JSaveAsSurfaceMenu.setAccelerator([]);
        obj.JSaveAsElectrodeMenu.setAccelerator([]);
        if is_pc
            obj.JLoadVolumeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_O,ActionEvent.CTRL_MASK)));
            obj.JSaveAsVolumeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_S,ActionEvent.CTRL_MASK)));
        elseif is_mac
            obj.JLoadVolumeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_O,ActionEvent.META_MASK)));
            obj.JSaveAsVolumeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_S,ActionEvent.META_MASK)));
        end
        
        obj.cfg.interface=1;

    elseif strcmpi(evt.category,'Surface')
        obj.JLoadBtn.setIcon(obj.IconLoadSurface);
        obj.JLoadBtn.setToolTipText('Load surface');
        
        obj.JDeleteBtn.setIcon(obj.IconDeleteSurface);
        obj.JDeleteBtn.setToolTipText('Delete surface');
        
        obj.JNewBtn.setIcon(obj.IconNewSurface);
        obj.JNewBtn.setToolTipText('New surface');
        
        obj.JSaveBtn.setIcon(obj.IconSaveSurface);
        obj.JSaveBtn.setToolTipText('Save surface');
        
        set(obj.HExtraBtn1,'visible','off');
        set(obj.HExtraBtn2,'visible','off');
        
        set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadSurface(obj));
        set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteSurface(obj));
        set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewSurface(obj));
        set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveSurface(obj));
        set(handle(obj.JSettingsBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SurfaceSettingsCallback(obj));
        
        set(obj.volumetoolpane,'visible','off');
        set(obj.surfacetoolpane,'visible','on');
        set(obj.electrodetoolpane,'visible','off');
        
        if evt.level==2
            electrode=obj.mapObj(char(evt.getKey()));
            alpha=get(electrode.handles,'facealpha');
            obj.JSurfaceAlphaSpinner.setValue(round(alpha*100));
            obj.JSurfaceAlphaSlider.setValue(round(alpha*100));
        end
        
        obj.JLoadVolumeMenu.setAccelerator([]);
        obj.JLoadElectrodeMenu.setAccelerator([]);
        obj.JSaveAsVolumeMenu.setAccelerator([]);
        obj.JSaveAsElectrodeMenu.setAccelerator([]);
        if is_pc
            obj.JLoadSurfaceMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_O,ActionEvent.CTRL_MASK)));
            obj.JSaveAsSurfaceMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_S,ActionEvent.CTRL_MASK)));
            
        elseif is_mac
            obj.JLoadSurfaceMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_O,ActionEvent.META_MASK)));
            obj.JSaveAsSurfaceMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_S,ActionEvent.META_MASK)));
        end
        obj.cfg.interface=2;
    elseif strcmpi(evt.category,'Electrode')
        obj.JLoadBtn.setIcon(obj.IconLoadElectrode);
        obj.JLoadBtn.setToolTipText('Load electrode');
        
        obj.JDeleteBtn.setIcon(obj.IconDeleteElectrode);
        obj.JDeleteBtn.setToolTipText('Delete electrode');
        
        obj.JNewBtn.setIcon(obj.IconNewElectrode);
        obj.JNewBtn.setToolTipText('New electrode');
        
        obj.JSaveBtn.setIcon(obj.IconSaveElectrode);
        obj.JSaveBtn.setToolTipText('Save electrode');
        
        obj.JExtraBtn1.setIcon(obj.IconInterpolateElectrode);
        obj.JExtraBtn1.setToolTipText('Interpolate');
        
        set(obj.HExtraBtn1,'visible','on');
        set(obj.HExtraBtn2,'visible','on');
        
        set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadElectrode(obj));
        set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteElectrode(obj));
        set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewElectrode(obj));
        set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveElectrode(obj));
        set(handle(obj.JSettingsBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) ElectrodeSettingsCallback(obj));
        set(handle(obj.JExtraBtn1,'CallbackProperties'),'MousePressedCallback',@(h,e) ElectrodeInterpolateCallback(obj));
        set(handle(obj.JExtraBtn2,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadMap(obj));
        
        set(obj.volumetoolpane,'visible','off');
        set(obj.surfacetoolpane,'visible','off');
        set(obj.electrodetoolpane,'visible','on');
        
        obj.JLoadSurfaceMenu.setAccelerator([]);
        obj.JLoadVolumeMenu.setAccelerator([]);
        obj.JSaveAsSurfaceMenu.setAccelerator([]);
        obj.JSaveAsVolumeMenu.setAccelerator([]);
        if is_pc
            obj.JLoadElectrodeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_O,ActionEvent.CTRL_MASK)));
            obj.JSaveAsElectrodeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_S,ActionEvent.CTRL_MASK)));
        elseif is_mac
            obj.JLoadElectrodeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_O,ActionEvent.META_MASK)));
            obj.JSaveAsElectrodeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_S,ActionEvent.META_MASK)));
        end
        obj.cfg.interface=3;
    elseif strcmpi(evt.category,'Others')
        
    end
end

if strcmpi(evt.category,'Electrode')&&evt.level==2
    electrode=obj.mapObj(char(evt.getKey()));
    electrode.selected=ones(size(electrode.coor,1),1)*true;
    try
        set(electrode.handles,'edgecolor','y');
    catch
    end
    
    if electrode.ind==obj.electrode_settings.select_ele
        notify(obj,'ElectrodeSettingsChange')
    end
else
    if strcmpi(evt.oldcategory,'Electrode')&&evt.oldind~=0
        oldelectrode=obj.mapObj([char(evt.oldcategory),num2str(evt.oldind)]);
        oldelectrode.selected=ones(size(oldelectrode.coor,1),1)*false;
        try
            set(oldelectrode.handles,'edgecolor','none');
        catch
        end
        
        if oldelectrode.ind==obj.electrode_settings.select_ele
            notify(obj,'ElectrodeSettingsChange')
        end
    end
end
end