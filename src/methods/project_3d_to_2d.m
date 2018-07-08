function [x, y] = project_3d_to_2d(pos, proj_cam_tgt)
% return delaunay triangulation

if proj_cam_tgt
    % get the normal direction campos->camtarget out of pos 
    normal = campos-camtarget;
    normal = normal/norm(normal);
    pos_project = pos-pos*normal(:)*normal;
else
    pos_project = pos;
end

% use PCA to project 3d points into 2d plane
[V, D, ~] = eig(pos_project'*pos_project);
[~, ind] = sort(diag(D));
V = V(:, ind);

x = pos_project*V(:, 2);
y = pos_project*V(:, 3);
end

