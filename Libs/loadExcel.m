function [excelWriteFunc, excelReadFunc] = loadExcel( )
%PREPAREXSLWRITE Summary of this function goes here
%   Detailed explanation goes here
    
    if nargout < 1
        error('You must get the handler on the excel write function')
    end

    if isunix || ismac
        fullPathAndPath = fileparts(which('loadExcel.m'));
        addpath([fullPathAndPath '/xlwrite']);
        javaaddpath([fullPathAndPath '/xlwrite/poi_library/poi-3.8-20120326.jar']);
        javaaddpath([fullPathAndPath '/xlwrite/poi_library/poi-ooxml-3.8-20120326.jar']);
        javaaddpath([fullPathAndPath '/xlwrite/poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
        javaaddpath([fullPathAndPath '/xlwrite/poi_library/xmlbeans-2.3.0.jar']);
        javaaddpath([fullPathAndPath '/xlwrite/poi_library/dom4j-1.6.1.jar']);
        javaaddpath([fullPathAndPath '/xlwrite/poi_library/stax-api-1.0.1.jar']);
        excelWriteFunc = @xlwrite;
    elseif ispc
        excelWriteFunc = @xlswrite;
    else
        errordlg('Platform not supported')
        error('Platform not supported')
    end
    excelReadFunc = @xlsread;
end

