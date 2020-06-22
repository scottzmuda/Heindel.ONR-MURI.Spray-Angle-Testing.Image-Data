%startpath= designate startpath
%folderpath= select normalization folder
%n=number of frames per normaliztion
%threshold= value below which indicated that pixel is part of nozzle
%filename= change file number
%filepath= create filepath
%image= read-in image
startpath = '\\heindelfs1.me.iastate.edu\heindel\ONR MURI\Spray Angle Testing\Image Data\'; %designate startpath
folderpath = uigetdir(startpath); %select normalization folder
n=500; %number of frames per normaliztion
threshold=5200; %value below which indicated that pixel is part of
nozzle
badimages=string.empty;
badimagecount=0;
prompt = {'Nozzle distance from top of image (30 pixels on average)'};
nozzleheight = inputdlg(prompt);
for k=0:n-1
filename = sprintf('\\Frame %d.tif',k); %change file number
filepath = fullfile(folderpath,filename); %create filepath
image = imread(filepath); %read-in image
nozzle_spray_column = imcrop(image,[500
str2double(nozzleheight{1}) 0 569]);
if min(nozzle_spray_column) < threshold
badimagecount=badimagecount+1;
badimages(1,badimagecount) = filename;
end
end
badimages;
Error using dir
Invalid path. The path must not contain a null character.
Error in imread>get_full_filename (line 558)
if ~isempty(dir(filename))
Error in imread (line 374)
fullname = get_full_filename(filename);
Error in DripDetection2 (line 21)
image = imread(filepath); %read-in image
%conditionsFile= fits line
%User input variables
conditionsFile = 'D:\RemoteUserDocuments\Desktop\1 Line Fits - BAD\Data-Norm Pairs, Ql=0.099, Prior Norm.txt'; %Note: MatLab likes
single quotes better
dataFolder = 'D:\RemoteUserDocuments\Desktop\1 Line Fits - BAD';
outputFile = 'D:\RemoteUserDocuments\Desktop\TestOutputFile.txt';
sps = 0:0.05:1;
repeats = 5;
Pairs=fopen("Y:\ONR MURI\Spray Angle Testing\Data-Norm Pairs, Ql=0.099, Prior Norm.txt");
Extraction=extractBetween(Pairs,44,81);
Data=strcat(Extraction, ', Data.txt');
filepath="Y:\ONR MURI\Spray Angle Testing\1 Line Fits - BAD\";
%Open the conditions file and pull out the condition names
fid = fopen(conditionsFile);
conditionNames = cell(0, 1);
lineIdx = 1;
while ~feof(fid)
line = fgetl(fid);
pair = strsplit(line, '\t');
nameParts = strsplit(pair{1}, '\\');
conditionNames(lineIdx) = nameParts(length(nameParts));
lineIdx = lineIdx + 1;
end
fclose(fid);
%Sort out the conditions by flow condition
flowConditions = zeros(0, 2);
flowConCt = 0;
for i=1:length(conditionNames)
tempName = conditionNames{i};
Ql = str2double(tempName(4:8));
Qtot = str2double(tempName(16:20));
found = false;
for j = 1:flowConCt
if flowConditions(j,1) == Ql && flowConditions(j,2) == Qtot
found = true;
end
end
if ~found
flowConCt = flowConCt + 1;
flowConditions(flowConCt, 1) = Ql;
flowConditions(flowConCt, 2) = Qtot;
end
end
outFid = fopen(outputFile, 'w');
for i=1:size(flowConditions, 1)
file=fullfile(filepath,Data(i));
xlswrite('Y:\ONR MURI\Spray Angle Testing\Zmuda_APSDFD_Analysis\APSDFDPresentationData.xlsx')
%Tim wanted me to use csvwrite, but matlab highly suggests not to,
%so for now I left it the same.
%write out the section headers
fprintf(outFid, 'Ql=%0.3f, Qtot=%0.1f\r\n', flowConditions(i, 1),
flowConditions(i, 2));
2
fprintf(outFid, 'SP');
for test=1:repeats
fprintf(outFid, ', Test %d', test);
end
fprintf(outFid, '\r\n');
for sp=sps
fprintf(outFid, '%0.3f', sp);
for test=1:repeats
try
fileName = sprintf('%s\\Ql=%0.3f, Qtot=%0.1f, SP=%0.3f, Test %d, Data.txt', dataFolder, flowConditions(i, 1),
flowConditions(i, 2), sp, test);
dataFid = fopen(fileName);
fgetl(dataFid);
line = fgetl(dataFid);
splits = strsplit(line, ':');
aveAngle = strtrim(splits{2});
fprintf(outFid, ', %s', aveAngle);
fclose(dataFid);
catch
fprintf(outFid, ', NA');
end
end
fprintf(outFid, '\r\n');
end
fprintf(outFid, '\r\n');
end
fclose(outFid);
