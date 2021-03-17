function maskStruct=get_mask(databaseObj, maskName)
maskObs=databaseObj.getObs(maskName,'maskTable','mask_name');
maskStruct.name=maskName;
maskStruct.coordFcn=get_process_step(maskObs{end}.coord_fcn);
maskStruct.maskFcn=get_process_step(maskObs{end}.mask_fcn);
maskStruct.mask_id=maskObs{end}.mask_id;
end
    

