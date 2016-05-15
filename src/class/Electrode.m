classdef Electrode
    %Include properties for map and electrode
    properties
        category% must be electrode all the time, will eliminate in future
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
    end
    
    methods
        function obj=Electrode()
            obj.category='Electrode';
        end
    end
    
end

