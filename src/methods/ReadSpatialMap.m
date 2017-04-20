function sm = ReadSpatialMap( filename )
%READSPATIALMAP Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(filename);
C = textscan(fileID,'%s%f%d%f%f%f',...
    'Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','%');
fclose(fileID);

if length(C)<2
    sm=[];
    return
elseif length(C)==2
    sm.name=C{1};
    sm.val=C{2};
    sm.sig=zeros(length(C{1}),1);
elseif length(C)==3
    sm.name=C{1};
    sm.val=C{2};
    sm.sig=C{3};
elseif length(C)==6
    sm.name=C{1};
    sm.val=C{2};
    sm.sig=C{3};
    sm.pos=cat(2,C{4}(:),C{5}(:),C{6}(:));
end
end

