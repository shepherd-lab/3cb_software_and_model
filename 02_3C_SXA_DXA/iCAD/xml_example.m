function xml_example()

% Element nodes — Corresponds to tag names. In the sample info.xml file, these tags correspond to element nodes:
% productinfo
% list
% listitem
% label
% callback
% icon
% In this case, the list element is the parent of listitem element child nodes. The productinfo element is the root element node.
% Text nodes — Contains values associated with element nodes. Every text node is the child of an element node. For example, the Import Wizard text node is the child of the first label element node.
% Attribute nodes — Contains name and value pairs associated with an element node. For example, xmlns:xsi is the name of an attribute and http://www.w3.org/2001/XMLSchema-instance is its value. Attribute nodes are not parents or children of any nodes.
% Comment nodes — Includes additional text in the file, in the form <!--Sample comment-->.
% Document nodes — Corresponds to the entire file. Use methods on the document node to create new element, text, attribute, or comment nodes.
filename = '\\win\bbdg\aaData\Breast Studies\iCAD\RESULTS\8\1.2.840.113681.2216077323.729.3606574098.9_results.xml';

findLabel = 'Plot Tools';
findCbk = '';


xDoc = xmlread(fullfile(matlabroot, ...
               'toolbox','matlab','general','info.xml'));

end

allListitems = xDoc.getElementsByTagName('listitem');

for k = 0:allListitems.getLength-1
   thisListitem = allListitems.item(k);
   
   % Get the label element. In this file, each
   % listitem contains only one label.
   thisList = thisListitem.getElementsByTagName('label');
   thisElement = thisList.item(0);

   % Check whether this is the label you want.
   % The text is in the first child node.
   if strcmp(thisElement.getFirstChild.getData, findLabel)
       thisList = thisListitem.getElementsByTagName('callback');
       thisElement = thisList.item(0);
       findCbk = char(thisElement.getFirstChild.getData);
       break;
   end
   
end

if ~isempty(findCbk)
    msg = sprintf('Item "%s" has a callback of "%s."',...
                  findLabel, findCbk);
else
    msg = sprintf('Did not find the "%s" item.', findLabel);
end
disp(msg);



