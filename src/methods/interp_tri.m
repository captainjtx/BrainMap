function newpos=interp_tri(pos, k, proj_cam_tgt)
% if proj_camtgt is true, first get rig of campos->camtarget component
if k==0
    newpos=pos;
    return
else
    [x, y] = project_3d_to_2d( pos, proj_cam_tgt );
    tri=delaunay(x, y);
    
    edge_pair=[];
    newpos=[];
    for i=1:size(tri,1)
        if ~ismember([tri(i,1),tri(i,2)],edge_pair)
            newpos=cat(1,newpos,(pos(tri(i,1),:)+pos(tri(i,2),:))/2);
            edge_pair=cat(1,edge_pair,[tri(i,1),tri(i,2)]);
        end
        
        if ~ismember([tri(i,1),tri(i,3)],edge_pair)
            newpos=cat(1,newpos,(pos(tri(i,1),:)+pos(tri(i,3),:))/2);
            edge_pair=cat(1,edge_pair,[tri(i,1),tri(i,3)]);
        end
        
        if ~ismember([tri(i,3),tri(i,2)],edge_pair)
            newpos=cat(1,newpos,(pos(tri(i,3),:)+pos(tri(i,2),:))/2);
            edge_pair=cat(1,edge_pair,[tri(i,3),tri(i,2)]);
        end
    end
    
    newpos=cat(1,pos,newpos);
    
    newpos=unique(newpos,'rows');
    
    newpos=interp_tri(newpos,k-1,proj_cam_tgt);
end

end
