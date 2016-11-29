classdef Volume<handle
    properties (Dependent)
        category
    end
    properties
        volume
        pixdim
        xrange
        yrange
        zrange
        file
        ind
        checked
        handles
        h_sagittal
        h_coronal
        h_axial
        campos
        camtarget
    end
    
    methods
        function val=get.category(obj)
            val='Volume';
        end
        
        function obj=Volume()
        end
        
        function save(obj)
            [FileName,FilePath,~]=uiputfile({'*.mat','Matlab Mat File (*.mat)'}...
                ,'save your volume',obj.file);
            
            if FileName~=0
                mapval.category='Volume';
                mapval.file=fullfile(FilePath,FileName);
                mapval.CameraLocation=obj.campos;
                mapval.CameraTarget=obj.camtarget;
                
                save(fullfile(FilePath,FileName),'-struct','mapval','-mat','-v7.3');
            end
            
        end
    end
end

