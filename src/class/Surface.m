classdef Surface<handle
    %SURFACE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Dependent)
        category
    end
    properties
        
        vertices
        faces
        file
        ind
        checked
        handles
        
        downsample
    end
    
    methods
        function val=get.category(obj)
            val='Surface';
        end
        function obj=Surface()
            obj.downsample=1;
        end
    end
    
end

