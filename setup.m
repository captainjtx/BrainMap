function setup()
%recompile the java class to local platform, usually do not need
java_version=version('-java');

if ~strcmp(java_version(6:8),'1.7')
    disp('Auto recompile java classes ...');
    try
    !javac src/java/LabelListBoxRenderer.java 
    !javac src/java/PushButton.java
    !javac src/java/TogButton.java
    !javac src/java/checkboxtree/FileLoadTree.java
    catch
        disp('Auto recompile failed !');
        return
    end
end

%save java class path into static file
spath = javaclasspath('-static');
pref_dir=prefdir;
if ~any(strcmp(spath,pwd))
    javaaddpath(pwd);
    
    fid = fopen(fullfile(pref_dir,'javaclasspath.txt'),'a');
    fprintf(fid,'%s\n',pwd);
    fclose(fid);
    warndlg('Add java class path, restart Matlab to ensure function !');
end


%clean matlab filepath
while 1
    olddir=which('brainmap');
    
    olddir=fileparts(olddir);
    if isempty(olddir)
        break
    end
    p=path;
    p=[p,pathsep];
    [starti,endi]=regexpi(p,[olddir,'.*?',pathsep]);
    
    if isempty(starti)
        break
    end
    
    for i=1:length(starti)
        rmpath(p(starti(i):endi(i)-1));
    end
end

addpath(pwd,'-frozen');
addpath(genpath([pwd filesep 'src']),'-frozen');
addpath(genpath([pwd filesep 'db']),'-frozen');
addpath(genpath([pwd filesep 'lib']),'-frozen');
addpath(genpath([pwd filesep 'script']),'-frozen');

try
    savepath;
catch
    warndlg('Can not save to Matlab Path !');
end

disp('BrainMap setup completed !');
% a=opengl('data');
% 
% if a.Software
%     opengl software;
%     opengl('save','software');
% else
%     opengl hardware;
%     opengl('save','hardware');
% end

end

