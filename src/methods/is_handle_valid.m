function t = is_handle_valid(h)
if isempty(h)
    t=false;
else
    try
        t=ishandle(h);
    catch
        t=false;
    end
end
end

