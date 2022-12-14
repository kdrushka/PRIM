%% This code concatenates per day Argo files in Matlab format
% generated by March Jacob, Rev4: 05/10/2022

function Concatenating_Argo_Rev4(yyyy,flag)

% yyyy = year of the data to process

if flag==0
    inDir = '/data4/OceanSalinity/RIM/ARGO/Data/GriddedData/'; %input folder
    outDir = '/data4/OceanSalinity/RIM/ARGO/Data/GriddedData/'; % output folder
elseif flag==1
    inDir = 'Z:\OceanSalinity\RIM\ARGO/Data/GriddedData/'; %input folder
    outDir = 'Z:\OceanSalinity\RIM\ARGO\Data\GriddedData/'; % output folder
end

files = dir([inDir,'Argo_RG_Salinity_',num2str(yyyy),'*']); %files to process


sal = nan(720,1440,12);
time = nan(12,3);

for k = 1:size(files,1)
    
    name = [inDir,files(k).name];
    disp(name)
    mm = str2num(files(k).name(22:23));
    
    load(name)
    sal(:,:,k) = salinity;
    time(k,:) = times;
    clear salinity times;
    
    disp(['Processed file - ',num2str(yyyy),num2str(mm,'%0.2d')])
                
end
    
% salinity = sal;
% times = time;
                
nameFile = ['Argo_RG_Salinity_', num2str(yyyy)];
save([outDir nameFile '.mat'], 'lat','lon','salinity','time')

disp(num2str(yyyy),'done')
    
end