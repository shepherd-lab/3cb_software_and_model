function save_slices()
global Info Analysis Image ROI
dir_stiffness = '\\researchstg\aaStudies\Breast Studies\Stiffness_mammo\Results\SXA\';
                    if ~isempty(strfind(Info.patient_id,'50199690'))
                     patient_stiff  =  'B1931';
                    elseif ~isempty(strfind(Info.patient_id,'10231612'))
                    patient_stiff  =  'B2014';
                     elseif ~isempty(strfind(Info.patient_id,'50845028'))
                    patient_stiff  =  'B2061';
                     elseif ~isempty(strfind(Info.patient_id,'49494335'))
                    patient_stiff  =  'B2065';
                     elseif ~isempty(strfind(Info.patient_id,'46115678'))
                    patient_stiff  =  'B2066';
                      elseif ~isempty(strfind(Info.patient_id,'44317907'))
                    patient_stiff  =  'B2076';
                    elseif ~isempty(strfind(Info.patient_id(1:5),'TT033'))
                        patient_stiff  =  'B2064';
                    elseif ~isempty(strfind(Info.patient_id(1:5),'TT034'))
                        patient_stiff  =  'B2056';    
                    else
                        patient_stiff  = Info.patient_id;
                    end                                       	

                    Analysis.FileNameDensity2 = [dir_stiffness,patient_stiff,Analysis.filename(1:end-8),'_densitySXA.png'];
                    Analysis.FileNameThickness2 = [dir_stiffness,patient_stiff,Analysis.filename(1:end-8),'_thicknessSXA.png'];
                    imwrite(uint16(Analysis.SXADensityImageCrop*100), Analysis.FileNameDensity2, 'png');
                    imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness2, 'png');
                    fNamemat = [dir_stiffness,patient_stiff, Analysis.filename(1:end-8),'_Mat_v',Info.Version(8:end) ,'.mat', ];
                    density_map = Analysis.SXADensityImageCrop;
                    thickness_map = Analysis.SXAthickness_mapproj;
                    attenuation_image = Image.OriginalImageInit;
                    flip_info = [Info.flipH Info.flipV];
                    version_name = Info.Version;
                    save(fNamemat, 'density_map','thickness_map','ROI','flip_info','attenuation_image','version_name');


end

