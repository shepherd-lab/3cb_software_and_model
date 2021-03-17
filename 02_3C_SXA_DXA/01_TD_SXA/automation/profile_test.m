function profile_test()
    mthread = getNumberOfComputationalThreads;
    setNumberOfComputationalThreads(1);
    
    profile on
    %PhantomDetection;
    %Periphery_calculation;
    %SkinDetection('FROMGUI');
    %ComputeDensity;
    RequestedAction = 'RETRIEVEACQUISITION';
    answer=QAreport(RequestedAction);
    
    profile viewer
    p = profile('info');
    profsave(p,'profile_results');
    %a = 1;