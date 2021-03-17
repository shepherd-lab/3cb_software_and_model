function icad_analysis()

dirname_toread = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\Results_05192017\cases';
%  dcm_fname = [];
clear dcm_fname calc masses breast ;

dir_names = dir(dirname_toread); %returns the list of files in the specified directory
sza = size(dir_names);
count = 0;
lend = sza(1);
warning off;
count = 0;
icad_struct = [];

for k = 3:lend
    count = count + 1
    dirname_read = dir_names(k).name;
    xmldirname_read = [dir_names(k).folder,'\', dir_names(k).name,'\*results.xml'];
    xmlfile_names = dir(xmldirname_read);
    len_xml = length(xmlfile_names);
    clear dcm_fname calc masses breast;
    for i=1:len_xml %number of xml images in directory
        xmlfilename_read = [xmlfile_names(i).folder,'\', xmlfile_names(i).name];
        %             file_names = dir(fullfilename_read);
        %                count = count + 1;
        %                xml_fname(count) = file_names(i).name;
        theStruct = [];
        theStruct = parseXML(xmlfilename_read);
%         icad_struct = extract_icad(theStruct)
%         icad_struct{i} = extract_icad(theStruct);
        
        pat{count}.icad_struct{i} = extract_icad(theStruct);
        
%         if icad_struct{i}.num_clusters ~= 0
%             for ii = 1: icad_struct{i}.num_clusters
% %                 pat(count).icad_struct{i}.calc{ii} = icad_struct.calc{ii};
% %                 pat(count).icad_struct{i}.num_clusters = icad_struct.num_clusters;
%                   pat(count).icad_struct{i}.calc{ii} = icad_struct.calc{ii};
%             end
%         else
%             pat(count).icad_struct{i}.num_clusters(i) = 0;
%         end
%         
%         if icad_struct(i).num_masses ~= 0
%             for ii = 1: icad_struct(i).num_masses
%             pat(count).icad_struct(i).masses(ii) = icad_struct(i).masses(i);
%             pat(count).icad_struct(i).num_masses = icad_struct(i).num_masses;
%             end
%         else
%             pat(count).num_masses(i) = 0;
%         end
        
%         for fn = fieldnames(icad_struct.breast)'
%             pat(count).icad_struct(i).breast.(fn{1}) = icad_struct.breast.(fn{1});
%         end
%         
%         for fn = fieldnames(icad_struct.masses)'
%             pat(count).icad_struct(i).breast.(fn{1}) = icad_struct.breast.(fn{1});
%         end
        
%         for fn = fieldnames(icad_struct.breast)'
%             pat(count).icad_struct(i).breast.(fn{1}) = icad_struct.breast.(fn{1});
%         end
%                 
        %                 breast(i,:) = icad_struct.breast;
        [pathstr,name,ext] = fileparts(xmlfilename_read);
        pat{count}.icad_struct{i}.dcm_fname{i,:} = [pathstr,'\',name(1:end-8),'.dcm'];
        %                 pat(count).dcmfname_str = string([pathstr,'\',name(1:end-8),'.dcm']);
    end
    %           pat(count).masses = masses;
    %           pat(count).calc = calc;
    %           pat(count).breast = breast;
    %           pat(count).dcmfname_str = dcmfname_str;
    
end
save('\\researchstg\aaData\Breast Studies\iCAD\RESULTS\icad_051917.mat','pat');
%    dcmfname_str = string([pathstr,'\',name(1:end-8),'.dcm']);
if len_xml ~= 0
    for i= 1:len_xml
        ;
    end
end
a = 1;

end

%%
function theStruct = parseXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.
try
    tree = xmlread(filename);
catch
    error('Failed to read XML file %s.',filename);
end
%%
% Recurse over child nodes. This could run into problems
% with very deeply nested trees.
try
    theStruct = parseChildNodes(tree);
catch
    error('Unable to parse XML file %s.',filename);
end
end

%%
% ----- Local function PARSECHILDNODES -----
function children = parseChildNodes(theNode)
% Recurse over node children.
children = [];
if theNode.hasChildNodes
    childNodes = theNode.getChildNodes;
    numChildNodes = childNodes.getLength;
    allocCell = cell(1, numChildNodes);
    
    children = struct(             ...
        'Name', allocCell, 'Attributes', allocCell,    ...
        'Data', allocCell, 'Children', allocCell);
    
    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        children(count) = makeStructFromNode(theChild);
    end
end
end

%% ----- Local function MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
    'Name', char(theNode.getNodeName),       ...
    'Attributes', parseAttributes(theNode),  ...
    'Data', '',                              ...
    'Children', parseChildNodes(theNode));

if any(strcmp(methods(theNode), 'getData'))
    nodeStruct.Data = char(theNode.getData);
else
    nodeStruct.Data = '';
end
end
%% ----- Local function PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

attributes = [];
if theNode.hasAttributes
    theAttributes = theNode.getAttributes;
    numAttributes = theAttributes.getLength;
    allocCell = cell(1, numAttributes);
    attributes = struct('Name', allocCell, 'Value', ...
        allocCell);
    
    for count = 1:numAttributes
        attrib = theAttributes.item(count-1);
        attributes(count).Name = char(attrib.getName);
        attributes(count).Value = char(attrib.getValue);
    end
end
end
