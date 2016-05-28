function MouseMove(obj)
position = getpixelposition(obj.ViewPanel);
cursor=get(obj.fig,'CurrentPoint');
in_view=obj.isIn(cursor,position);
set(obj.fig,'Pointer','arrow');
if in_view
    try
        if obj.JTogNewElectrode.isSelected()
            set(obj.fig,'Pointer','crosshair');
        end
    catch
    end
    p=get(obj.axis_3d,'CurrentPoint');
    
    info={['X: ',num2str(p(1,1),'%5.1f')],['Y: ',num2str(p(1,2),'%5.1f')],['Z: ',num2str(p(1,3),'%5.1f')]};
    set(obj.TextInfo1,'String',info,'FontSize',0.2,'Foregroundcolor','k','HorizontalAlignment','left');
end
%within the view panel
f=obj.panon();
if ~f
    if in_view&&~obj.inView
        set(obj.fig,'WindowButtonDownFcn',@(src,evt)MouseDown_View(obj));
        set(obj.fig,'WindowScrollWheelFcn',@(src,evt)Scroll_View(obj,src,evt));
        
    elseif ~in_view&&obj.inView
        set(obj.fig,'WindowButtonDownFcn',[]);
        set(obj.fig,'WindowScrollWheelFcn',[]);
    end
end

obj.inView=in_view;
end