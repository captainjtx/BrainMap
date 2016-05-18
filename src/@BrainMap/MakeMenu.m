function MakeMenu(obj)

import javax.swing.JMenu; 
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.ImageIcon;
import javax.swing.KeyStroke;
import java.awt.event.KeyEvent;
import java.awt.event.ActionEvent;
import javax.swing.ButtonGroup;
%==========================================================================
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jFrame = javaObjectEDT(get(handle(obj.fig),'JavaFrame'));
try
    % R2014b and later
    jMenuBar = jFrame.fHG2Client.getMenuBar;
catch
    % R2008a and later
    try
        jMenuBar = jFrame.fHG1Client.getMenuBar;
    catch
        % R2007b and earlier
        jMenuBar = jFrame.fFigureClient.getMenuBar;
    end
end

bmp=uimenu(obj.fig,'label','BrainMap');

drawnow

is_pc=ispc;
is_mac=ismac;

obj.JFileMenu=javaObjectEDT(JMenu('File'));
obj.JLoadMenu=javaObjectEDT(JMenu('Load'));
obj.JLoadVolumeMenu=javaObjectEDT(JMenuItem('Volume',ImageIcon([obj.brainmap_path,'/db/icon/volume.png'])));
set(handle(obj.JLoadVolumeMenu,'CallbackProperties'),'ActionPerformedCallback',@(h,e) LoadVolume(obj));
if is_pc
    obj.JLoadVolumeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_O,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JLoadVolumeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_O,ActionEvent.META_MASK)));
end

obj.JLoadSurfaceMenu=javaObjectEDT(JMenuItem('Surface',ImageIcon([obj.brainmap_path,'/db/icon/surface.png'])));
set(handle(obj.JLoadSurfaceMenu,'CallbackProperties'),'ActionPerformedCallback',@(h,e) LoadSurface(obj));
obj.JLoadElectrodeMenu=javaObjectEDT(JMenuItem('Electrode',ImageIcon([obj.brainmap_path,'/db/icon/ecog.png'])));
set(handle(obj.JLoadElectrodeMenu,'CallbackProperties'),'ActionPerformedCallback',@(h,e) LoadElectrode(obj));

obj.JSaveAsMenu=javaObjectEDT(JMenu('Save as'));
obj.JSaveAsFigureMenu=javaObjectEDT(JMenuItem('Figure'));
set(handle(obj.JSaveAsFigureMenu,'CallbackProperties'),'ActionPerformedCallback',@(h,e) SaveAsFigure(obj));
if is_pc
    obj.JSaveAsFigureMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_P,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JSaveAsFigureMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_P,ActionEvent.META_MASK)));
end

obj.JSettingsMenu=javaObjectEDT(JMenu('Settings'));
obj.JSettingsBackgroundColorMenu=javaObjectEDT(JMenuItem('Canvas Color'));
set(handle(obj.JSettingsBackgroundColorMenu,'CallbackProperties'),'ActionPerformedCallback',@(h,e) ChangeCanvasColor(obj));
if is_pc
    obj.JSettingsBackgroundColorMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_B,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JSettingsBackgroundColorMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_B,ActionEvent.META_MASK)));
end

obj.JElectrodeMenu=javaObjectEDT(JMenu('Electrode'));
obj.JElectrodeRotateMenu=javaObjectEDT(JMenu('Rotate'));
obj.JElectrodeRotateLeftMenu=javaObjectEDT(JMenuItem('Left'));
set(handle(obj.JElectrodeRotateLeftMenu,'CallbackProperties'),'MousePressedCallback',@(h,e) MoveElectrode(obj,1));
obj.JElectrodeRotateLeftMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,0)));
obj.JElectrodeRotateLeftMenu.setToolTipText('Press Shift for fine adjustment');


obj.JElectrodeRotateRightMenu=javaObjectEDT(JMenuItem('Right'));
set(handle(obj.JElectrodeRotateRightMenu,'CallbackProperties'),'MousePressedCallback',@(h,e) MoveElectrode(obj,2));
obj.JElectrodeRotateRightMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,0)));
obj.JElectrodeRotateRightMenu.setToolTipText('Press Shift for fine adjustment');

obj.JElectrodeRotateUpMenu=javaObjectEDT(JMenuItem('Up'));
set(handle(obj.JElectrodeRotateUpMenu,'CallbackProperties'),'MousePressedCallback',@(h,e) MoveElectrode(obj,3));
obj.JElectrodeRotateUpMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0)));
obj.JElectrodeRotateUpMenu.setToolTipText('Press Shift for fine adjustment');

obj.JElectrodeRotateDownMenu=javaObjectEDT(JMenuItem('Down'));
set(handle(obj.JElectrodeRotateDownMenu,'CallbackProperties'),'MousePressedCallback',@(h,e) MoveElectrode(obj,4));
obj.JElectrodeRotateDownMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0)));
obj.JElectrodeRotateDownMenu.setToolTipText('Press Shift for fine adjustment');

obj.JElectrodePushPullMenu=javaObjectEDT(JMenu('Push/Pull'));
obj.JElectrodePushInMenu=javaObjectEDT(JMenuItem('Inward',ImageIcon([obj.brainmap_path,'/db/icon/push.png'])));
set(handle(obj.JElectrodePushInMenu,'CallbackProperties'),'MousePressedCallback',@(h,e) MoveElectrode(obj,5));
if is_pc
    obj.JElectrodePushInMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JElectrodePushInMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,ActionEvent.META_MASK)));
end
obj.JElectrodePushInMenu.setToolTipText('Press Shift for fine adjustment');

obj.JElectrodePullOutMenu=javaObjectEDT(JMenuItem('Outward',ImageIcon([obj.brainmap_path,'/db/icon/pull.png'])));
set(handle(obj.JElectrodePullOutMenu,'CallbackProperties'),'MousePressedCallback',@(h,e) MoveElectrode(obj,6));
if is_pc
    obj.JElectrodePullOutMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_UP,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JElectrodePullOutMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_UP,ActionEvent.META_MASK)));
end
obj.JElectrodePullOutMenu.setToolTipText('Press Shift for fine adjustment');

obj.JElectrodeSpinMenu=javaObjectEDT(JMenu('Spin'));
obj.JElectrodeSpinClockwiseMenu=javaObjectEDT(JMenuItem('Clockwise',ImageIcon([obj.brainmap_path,'/db/icon/clockwise.png'])));
set(handle(obj.JElectrodeSpinClockwiseMenu,'CallbackProperties'),'MousePressedCallback',@(h,e) MoveElectrode(obj,7));
if is_pc
    obj.JElectrodeSpinClockwiseMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JElectrodeSpinClockwiseMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,ActionEvent.META_MASK)));
end
obj.JElectrodeSpinClockwiseMenu.setToolTipText('Press Shift for fine adjustment');

obj.JElectrodeSpinCounterClockwiseMenu=javaObjectEDT(JMenuItem('Counter Clockwise',ImageIcon([obj.brainmap_path,'/db/icon/counterclockwise.png'])));
set(handle(obj.JElectrodeSpinCounterClockwiseMenu,'CallbackProperties'),'MousePressedCallback',@(h,e) MoveElectrode(obj,8));
if is_pc
    obj.JElectrodeSpinCounterClockwiseMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JElectrodeSpinCounterClockwiseMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,ActionEvent.META_MASK)));
end
obj.JElectrodeSpinCounterClockwiseMenu.setToolTipText('Press Shift for fine adjustment');

obj.JViewMenu=javaObjectEDT(JMenu('View'));


obj.JViewLayoutMenu=javaObjectEDT(JMenu('Layout'));

obj.JViewLayoutOneMenu=javaObjectEDT(JCheckBoxMenuItem('1',ImageIcon([obj.brainmap_path,'/db/icon/1.png']),false));
set(handle(obj.JViewLayoutOneMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeLayout(obj,h));
if is_pc
    obj.JViewLayoutOneMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_1,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JViewLayoutOneMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_1,ActionEvent.META_MASK)));
end

obj.JViewLayoutTwoTwoMenu=javaObjectEDT(JCheckBoxMenuItem('<html> 2&times;2 </html>',ImageIcon([obj.brainmap_path,'/db/icon/2_2.png']),false));
set(handle(obj.JViewLayoutTwoTwoMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeLayout(obj,h));
if is_pc
    obj.JViewLayoutTwoTwoMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_2,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JViewLayoutTwoTwoMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_2,ActionEvent.META_MASK)));
end

obj.JViewLayoutOneThreeHorizontalMenu=javaObjectEDT(JCheckBoxMenuItem('<html> 1&times;3 Horizontal </html>',ImageIcon([obj.brainmap_path,'/db/icon/1_3_hor.png']),false));
set(handle(obj.JViewLayoutOneThreeHorizontalMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeLayout(obj,h));
if is_pc
    obj.JViewLayoutOneThreeHorizontalMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_3,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JViewLayoutOneThreeHorizontalMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_3,ActionEvent.META_MASK)));
end

obj.JViewLayoutOneThreeVerticalMenu=javaObjectEDT(JCheckBoxMenuItem('<html> 2&times;2 Vertical</html>',ImageIcon([obj.brainmap_path,'/db/icon/1_3_ver.png']),false));
set(handle(obj.JViewLayoutOneThreeVerticalMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeLayout(obj,h));
if is_pc
    obj.JViewLayoutOneThreeVerticalMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_4,ActionEvent.CTRL_MASK)));
elseif is_mac
    obj.JViewLayoutOneThreeVerticalMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_4,ActionEvent.META_MASK)));
end

obj.JViewLayoutSagittalMenu=javaObjectEDT(JCheckBoxMenuItem('Sagittal',ImageIcon([obj.brainmap_path,'/db/icon/sagittal.png']),false));
set(handle(obj.JViewLayoutSagittalMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeLayout(obj,h));
obj.JViewLayoutSagittalMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_1,ActionEvent.SHIFT_MASK)));

obj.JViewLayoutCoronalMenu=javaObjectEDT(JCheckBoxMenuItem('Coronal',ImageIcon([obj.brainmap_path,'/db/icon/coronal.png']),false));
set(handle(obj.JViewLayoutCoronalMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeLayout(obj,h));
obj.JViewLayoutCoronalMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_2,ActionEvent.SHIFT_MASK)));

obj.JViewLayoutAxialMenu=javaObjectEDT(JCheckBoxMenuItem('Axial',ImageIcon([obj.brainmap_path,'/db/icon/axial.png']),false));
set(handle(obj.JViewLayoutAxialMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeLayout(obj,h));
obj.JViewLayoutAxialMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_3,ActionEvent.SHIFT_MASK)));

obj.JViewLayout3DMenu=javaObjectEDT(JCheckBoxMenuItem('3D',ImageIcon([obj.brainmap_path,'/db/icon/3d.png']),false));
set(handle(obj.JViewLayout3DMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeLayout(obj,h));
obj.JViewLayout3DMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_4,ActionEvent.SHIFT_MASK)));

%%
obj.JViewInterfaceMenu=javaObjectEDT(JMenu('Interface'));
obj.JViewInterfaceVolumeMenu=javaObjectEDT(JCheckBoxMenuItem('Volume',ImageIcon([obj.brainmap_path,'/db/icon/volume.png']),false));
set(handle(obj.JViewInterfaceVolumeMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeInterface(obj,h));
obj.JViewInterfaceVolumeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_1,ActionEvent.ALT_MASK)));

obj.JViewInterfaceSurfaceMenu=javaObjectEDT(JCheckBoxMenuItem('Surface',ImageIcon([obj.brainmap_path,'/db/icon/surface.png']),false));
set(handle(obj.JViewInterfaceSurfaceMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeInterface(obj,h));
obj.JViewInterfaceSurfaceMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_2,ActionEvent.ALT_MASK)));

obj.JViewInterfaceElectrodeMenu=javaObjectEDT(JCheckBoxMenuItem('Electrode',ImageIcon([obj.brainmap_path,'/db/icon/ecog.png']),false));
set(handle(obj.JViewInterfaceElectrodeMenu,'CallbackProperties'),'ItemStateChangedCallback',@(h,e) ChangeInterface(obj,h));
obj.JViewInterfaceElectrodeMenu.setAccelerator(javaObjectEDT(KeyStroke.getKeyStroke(KeyEvent.VK_3,ActionEvent.ALT_MASK)));


obj.JViewCameraMenu=javaObjectEDT(JMenu('Camera'));

%%
jMenuBar.add(obj.JFileMenu);
obj.JLoadMenu.add(obj.JLoadVolumeMenu);
obj.JLoadMenu.add(obj.JLoadSurfaceMenu);
obj.JLoadMenu.add(obj.JLoadElectrodeMenu);
obj.JSaveAsMenu.add(obj.JSaveAsFigureMenu);

obj.JFileMenu.add(obj.JLoadMenu);
obj.JFileMenu.add(obj.JSaveAsMenu);

jMenuBar.add(obj.JSettingsMenu);
obj.JSettingsMenu.add(obj.JSettingsBackgroundColorMenu);

jMenuBar.add(obj.JElectrodeMenu);
obj.JElectrodeMenu.add(obj.JElectrodeRotateMenu);
obj.JElectrodeRotateMenu.add(obj.JElectrodeRotateLeftMenu);
obj.JElectrodeRotateMenu.add(obj.JElectrodeRotateRightMenu);
obj.JElectrodeRotateMenu.add(obj.JElectrodeRotateUpMenu);
obj.JElectrodeRotateMenu.add(obj.JElectrodeRotateDownMenu);

obj.JElectrodeMenu.add(obj.JElectrodePushPullMenu);
obj.JElectrodePushPullMenu.add(obj.JElectrodePushInMenu);
obj.JElectrodePushPullMenu.add(obj.JElectrodePullOutMenu);

obj.JElectrodeMenu.add(obj.JElectrodeSpinMenu);
obj.JElectrodeSpinMenu.add(obj.JElectrodeSpinClockwiseMenu);
obj.JElectrodeSpinMenu.add(obj.JElectrodeSpinCounterClockwiseMenu);

jMenuBar.add(obj.JViewMenu);
obj.JViewMenu.add(obj.JViewLayoutMenu);
obj.JViewLayoutMenu.add(obj.JViewLayoutOneMenu);
obj.JViewLayoutMenu.add(obj.JViewLayoutTwoTwoMenu);
obj.JViewLayoutMenu.add(obj.JViewLayoutOneThreeHorizontalMenu);
obj.JViewLayoutMenu.add(obj.JViewLayoutOneThreeVerticalMenu);

group1=javaObjectEDT(ButtonGroup());
group1.add(obj.JViewLayoutOneMenu);
group1.add(obj.JViewLayoutTwoTwoMenu);
group1.add(obj.JViewLayoutOneThreeHorizontalMenu);
group1.add(obj.JViewLayoutOneThreeVerticalMenu);

obj.JViewLayoutMenu.addSeparator();

obj.JViewLayoutMenu.add(obj.JViewLayoutSagittalMenu);
obj.JViewLayoutMenu.add(obj.JViewLayoutCoronalMenu);
obj.JViewLayoutMenu.add(obj.JViewLayoutAxialMenu);
obj.JViewLayoutMenu.add(obj.JViewLayout3DMenu);

group2=javaObjectEDT(ButtonGroup());
group2.add((obj.JViewLayoutSagittalMenu));
group2.add((obj.JViewLayoutCoronalMenu));
group2.add((obj.JViewLayoutAxialMenu));
group2.add((obj.JViewLayout3DMenu));

obj.JViewInterfaceMenu.add(obj.JViewInterfaceVolumeMenu);
obj.JViewInterfaceMenu.add(obj.JViewInterfaceSurfaceMenu);
obj.JViewInterfaceMenu.add(obj.JViewInterfaceElectrodeMenu);
obj.JViewMenu.add(obj.JViewInterfaceMenu);

group3=javaObjectEDT(ButtonGroup());
group3.add((obj.JViewInterfaceVolumeMenu));
group3.add((obj.JViewInterfaceSurfaceMenu));
group3.add((obj.JViewInterfaceElectrodeMenu));

obj.JViewMenu.add(obj.JViewCameraMenu);

delete(bmp)
end

