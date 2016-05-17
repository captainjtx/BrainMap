function ChangeLayout(obj,src)
if src.isSelected()
    return
end
src.setSelected(true);

p=OrderedView(obj);

if obj.JViewLayoutOneMenu.isSelected()
    opt=1;
elseif obj.JViewLayoutTwoTwoMenu.isSelected()
    opt=2;
elseif obj.JViewLayoutOneThreeHorizontalMenu.isSelected()
    opt=3;
elseif obj.JViewLayoutOneThreeVerticalMenu.isSelected()
    opt=4;
end

switch opt
    case 1
        set(p(1),'position',[0,0,1,1],'visible','on');
        set(p(2),'visible','off');
        set(p(3),'visible','off');
        set(p(4),'visible','off');
    case 2
        set(p(1),'position',[0,0.5,0.5,0.5],'visible','on');
        set(p(2),'position',[0.5,0.5,0.5,0.5],'visible','on');
        set(p(3),'position',[0,0,0.5,0.5],'visible','on');
        set(p(4),'position',[0.5,0,0.5,0.5],'visible','on');
        
    case 3
        set(p(1),'position',[0,0,0.7,1],'visible','on');
        set(p(2),'position',[0.7,0.6666,0.3,0.3333],'visible','on');
        set(p(3),'position',[0.7,0.3333,0.3,0.3333],'visible','on');
        set(p(4),'position',[0.7,0.0000,0.3,0.3333],'visible','on');
    case 4
        set(p(1),'position',[0,0.3,1,0.7],'visible','on');
        set(p(2),'position',[0,0,0.3333,0.3],'visible','on');
        set(p(3),'position',[0.3333,0,0.3333,0.3],'visible','on');
        set(p(4),'position',[0.6666,0.,0.3333,0.3],'visible','on');
end
end

function [p,opt]=OrderedView(obj)
p=[obj.ViewSagittalPanel,obj.ViewCoronalPanel,obj.ViewAxialPanel,obj.View3DPanel];
if obj.JViewLayoutSagittalMenu.isSelected()
    opt=1;
    return
elseif obj.JViewLayoutCoronalMenu.isSelected()
    opt=2;
    p=p([2,1,3,4]);
elseif obj.JViewLayoutAxialMenu.isSelected()
    opt=3;
    p=p([3,1,2,4]);
elseif obj.JViewLayout3DMenu.isSelected()
    opt=4;
    p=p([4,1,2,3]);
end 
end

