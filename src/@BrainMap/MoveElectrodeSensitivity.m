function MoveElectrodeSensitivity( obj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

prompt={'Sensitivity'};

def={num2str(obj.move_sensitivity)};

title='Electrode movement';

answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

sen=str2double(answer{:});

if ~isempty(sen)&&~isnan(sen)&&sen>0
    obj.move_sensitivity=sen;
end

end

