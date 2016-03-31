function loadBtk(Path)
    
    
    if isunix || ismac
        if nargin > 0
            folder = dir(Path);
        else
            folder = dir('/usr/local/share/btk*');
            Path = ['/usr/local/share/' folder.name '/Wrapping/Matlab/btk'];
            folder = dir(Path);
        end
        if isempty(folder)
            errordlg('Please make sure btk is properly installed or specify the path')
            error('Please make sure btk is properly installed or specify the path')
        end
        
    elseif ispc
        if nargin > 0
            folder = dir(Path);
        else
            folder = dir('C:/Program Files/BTK/btk*');
            Path = ['C:/Program Files/BTK/' folder.name '/btk'];
            folder = dir(Path);
        end
        if isempty(folder)
            errordlg('Please make sure btk is properly installed or specify the path')
            errord('Please make sure btk is properly installed or specify the path')
        end
        
    else
        errordlg('Platform not supported')
        error('Platform not supported')
    end

    addpath(Path);

end
