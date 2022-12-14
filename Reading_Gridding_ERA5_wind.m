% This code reads the ERA5 files, grids and saves in Matlab format
% generated by March Jacob, Rev1: 10/02/2020
% The function takes as input the year to process
% and the start month (mm1) and end month (mm2)
% 09/18/2021 update: added comments to code
% update - 02/08/2022
% change resolution to 10 km

function Reading_Gridding_ERA5_Rev2(yyyy,mm1,mm2)

clc

dir1 = '/disk4/ERA5'; %input folder
dir2 = '/disk4/OceanSalinity/RIM/ERA5/Data/GriddedData'; % output folder
% dir2 = 'Z:\OceanSalinity\RIM\ERA5\Data\GriddedData/10km'; % output folder
% dir1 = 'Z:\ERA5'; %input folder

res = 0.25; %desired resolution

r = round(180/res); %rows in gridding matrix
c = round(360/res); %columns in gridding matrix

    for mm= mm1:mm2
        dirin = [dir1 '/' ,num2str(yyyy),num2str(mm,'%10.2d'),'/']; % input folder
        files = dir([dirin,'ERA5_*_surf*']); %files to process
        for i = 1:size(files,1) %read files one at a time
            name = [dirin,files(i).name]; %name of the file that is being processed
            disp(name)
            
            %ncdisp(name)           
            
            lati = double(ncread(name,'/latitude')); %latitude vector
            loni = double(ncread(name,'/longitude')); %longitude vector
            u = double(ncread(name,'/u10')); % u wind (m/s)
            v = double(ncread(name,'/v10')); % v wind (m/s)
            
            lati = repmat(lati,1,1280); %copy lat column for all lon
            loni = loni'; %convert long column to row
            loni = repmat(loni,641,1); %copy long row to all lat
            u = permute(u,[2 1 3]); %permute lat with long
            v = permute(v,[2 1 3]); %permute lat with long
            
            lat = imresize(lati,[r c],'bicubic'); %resizing to matrix that is rows x cols
            lon = imresize(loni,[r c],'bicubic');
            uwind = imresize(u,[r c],'bicubic');
            vwind = imresize(v,[r c],'bicubic');
            
            wind = sqrt(uwind.^2 + vwind.^2); %calculating wind magnitude from components
            
            name_file = name(20:32); %setting name of file
            outputfile = [dir2,'/' name_file ,'.mat']; %setting path for saving
            save(outputfile,'lat','lon','wind'); %saving output file
            disp(['file',name(20:32)])
        end
        disp('done')
    end    
end



