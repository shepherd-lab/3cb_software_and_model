function featureLibraryTest(imageObj, databaseObj)
fileID=fopen('testFeature.txt');
featureList=textscan(fileID,'%s');
fclose(fileID);
featureSequence=get_feature_sequence(databaseObj,featureList);
featureObs=calc_features(imageObj,maskObj,featureSequence);
savefeatures(imageObj,featureObs,featureList, databaseObj);
end
