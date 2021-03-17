function xml_structure()
% % xDoc = xmlread(fullfile(matlabroot,'toolbox',...
% %                'matlab','general','info.xml'));
% % 
% %            
% % xRoot = xDoc.getDocumentElement;
% % schema = char(xRoot.getAttribute('xsi:noNamespaceSchemaLocation'))
% This code returns:
% 
% schema =
% http://www.mathworks.com/namespace/info/v1/info.xsd

% Create functions that parse data from an XML file into a MATLAB® structure array with fields Name, Attributes, Data, and Children:

% filename = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\8\1.2.840.113681.2216077323.729.3606574098.9_results.xml'; %case 1
% filename = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\6\1.2.840.113681.2216077323.733.3593867142.24_results.xml';
filename = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\7\1.2.840.113681.2216077323.735.3599322607.53_results.xml';
filename = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\5\1.2.840.113681.2216077323.736.3590665913.385_results.xml'; %5
filename = '\\researchstg\aaData\Breast Studies\iCAD\case_ver1\17\1.2.840.113681.2216077323.736.3590665913.387_results.xml';
% filename = '\\researchstg\aaData\Breast Studies\iCAD\case_ver1\17\1.2.840.113681.2216077323.736.3590665913.391_mammo.xml';
filename = '\\researchstg\aaData\Breast Studies\iCAD\case_ver1\19\1.2.840.113681.2216077323.735.3599322607.55_results.xml';
filename = '\\researchstg\aaData\Breast Studies\iCAD\case_ver1\22\1.2.840.113681.2225183346.01.896.53239.8964448.15_results.xml';
filename = '\\researchstg\aaData\Breast Studies\iCAD\case_ver1\22\1.2.840.113681.2225183346.01.161.53220.1614715.5_results.xml';
filename = '\\researchstg\aaData\Breast Studies\iCAD\case_ver2\29\1.2.840.113681.2225183346.01.161.53220.1614715.5_results.xml';
filename = '\\researchstg\aaData\Breast Studies\iCAD\case_ver6\57\1.2.840.113681.2225183346.01.161.53220.1614715.5_results.xml';
filename = '\\researchstg\aaData\Breast Studies\R2CAD\277_DEIDENTIFIED\1.2.840.113681.2216077323.745.3618585783.4.xml';
filename = '\\researchstg\aaData\Breast Studies\R2CAD\277_DEIDENTIFIED\1.2.840.113681.2216077323.745.3618585783.4_img.xml';
%  filename = '\\researchstg\aaData\Breast Studies\iCAD\case_ver1\17\1.2.840.113681.2216077323.736.3590665913.387_results.xml';
theStruct = parseXML(filename);
a = 1;

icad_struct = extract_icad(theStruct);
% densities = theStruct.Children(2).Children(14).Children(1).Children(6).Children.Data
a = 1;

function theStruct = parseXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.
try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.',filename);
end


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

% ----- Local function MAKESTRUCTFROMNODE -----
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

% ----- Local function PARSEATTRIBUTES -----
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