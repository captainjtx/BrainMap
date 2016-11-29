classdef Electrode<handle
    %Include properties for map and electrode
    properties (Dependent)
        category
    end
    properties
        file% full filename of the source
        ind% the unique monotonically increased identifier index
        coor% [N*3] coordinates of the electrodes
        radius% [N*1] radius of the electrodes
        thickness% [N*1] thickness of the electrodes
        color% [N*3] [R,G,B] tuples of the face color
        norm% [N*3] normal vecotrs of the top face of the electrode
        checked% true/false for display (checkbox in fileloadtree)
        selected% true/false for selection (selection in fileloadtree)
        channame% {N*1} channel names
        map% [N*1] map values 
        map_h% patch handle of the map
        coor_interp% >=0 iterative triangulation times 
        map_alpha% 0-1 map alpha value
        map_colormap% string, colormap
        F% scatteredInterpolant function
        radius_ratio% simultaneously enlarge/shrink radius
        thickness_ratio% simultaneously enlarge/shrink thickness 
        handles% [N*1] handles of electrode patch objects
        map_sig
        
        count% unique monotonically increasing id for new electrode
    end
    
    methods
        function val=get.category(obj)
            val='Electrode';
        end
        function obj=Electrode()
            obj.coor_interp=10;
            obj.map_alpha=0.8;
            obj.map_colormap='jet';
            obj.count=0;
        end
        
        function save(obj)
            [FileName,FilePath,~]=uiputfile({'*.mat','Matlab Mat File (*.mat)'}...
                ,'save your electrode',obj.file);
            
            if FileName~=0
                mapval.category='Electrode';
                mapval.file=fullfile(FilePath,FileName);
                mapval.coor=obj.coor;
                mapval.radius=obj.radius;
                mapval.thickness=obj.thickness;
                mapval.color=obj.color;
                mapval.norm=obj.norm;
                mapval.channame=obj.channame;
                mapval.map=obj.map;
                mapval.map_sig=obj.map_sig;
                mapval.count=obj.count;
                
                save(fullfile(FilePath,FileName),'-struct','mapval','-mat','-v7.3');
            end
            
        end
        
        function remove(obj,ind)
            obj.coor(ind,:)=[];
            obj.radius(ind)=[];
            obj.thickness(ind)=[];
            obj.color(ind,:)=[];
            if ~isempty(obj.channame)
                obj.channame(ind)=[];
            end
            if ~isempty(obj.norm)
                obj.norm(ind,:)=[];
            end
            if ~isempty(obj.selected)
                obj.selected(ind)=[];
            end
            if ~isempty(obj.map)
                obj.map(ind)=[];
            end
            if ~isempty(obj.map_sig)
                obj.map_sig(ind)=[];
            end
            
            if ~isempty(obj.radius_ratio)
                obj.radius_ratio(ind)=[];
            end
            if ~isempty(obj.thickness_ratio)
                obj.thickness_ratio(ind)=[];
            end
            if ~isempty(obj.handles)
                try
                delete(obj.handles(ind));
                catch
                end
                obj.handles(ind)=[];
            end
        end
    end
    
end

