function MoveElectrode( obj,opt )
switch opt
    case 1
        evt.Modifier={};
        evt.Key='leftarrow';
    case 2
        evt.Modifier={};
        evt.Key='rightarrow';
    case 3
        evt.Modifier={};
        evt.Key='uparrow';
    case 4
        evt.Modifier={};
        evt.Key='downarrow';
    case 5
        if ismac
            evt.Modifier={'command'};
        elseif ispc
            evt.Modifier={'control'};
        end
        evt.Key='downarrow';
    case 6
        if ismac
            evt.Modifier={'command'};
        elseif ispc
            evt.Modifier={'control'};
        end
        evt.Key='uparrow';
    case 7
        if ismac
            evt.Modifier={'command'};
        elseif ispc
            evt.Modifier={'control'};
        end
        evt.Key='rightarrow';
    case 8
        if ismac
            evt.Modifier={'command'};
        elseif ispc
            evt.Modifier={'control'};
        end
        evt.Key='leftarrow';
    case 9
        if ismac
            evt.Modifier={'command'};
        elseif ispc
            evt.Modifier={'control'};
        end
        evt.Key='j';
    case 10
        if ismac
            evt.Modifier={'command'};
        elseif ispc
            evt.Modifier={'control'};
        end
        evt.Key='k';
end
% disp(opt)

KeyPress(obj,[],evt);

end

