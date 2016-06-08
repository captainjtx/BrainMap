classdef Volume<handle
    properties
        volume
        pixdim
        xrange
        yrange
        zrange
        category
        file
        ind
        checked
        handles
        h_sagittal
        h_coronal
        h_axial
    end
    
    methods
        function obj=Volume()
            obj.category='Volume';
        end
        
        function save(obj)
            [FileName,FilePath,~]=uiputfile({'*.mat','Matlab Mat File (*.mat)'}...
                ,'save your volume',obj.file);
            
            if FileName~=0
                mapval.category='Volume';
                mapval.file=fullfile(FilePath,FileName);
                
                save(fullfile(FilePath,FileName),'-struct','mapval','-mat','-v7.3');
            end
            
        end
    end
end

