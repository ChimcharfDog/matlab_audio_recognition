clear all; close all
%%
location='D:\U\9\Aprendizaje Automatico\Proyecto 2\archive4\TotalAug\*';
filesDir = dir(location);
%% Almacenando Audio

for i=1:length(filesDir)-2
dir=strcat(filesDir(i+2).folder,'\',filesDir(i+2).name)
ads = audioDatastore(dir,IncludeSubfolders=true,LabelSource="foldernames");
[audio,fs] = audioread(cell2mat(ads.Files(1)));
sound(audio,fs)
labelTableV = countEachLabel(ads)
numClasses = height(labelTableV);
folder=table2cell(labelTableV(1,1));
folder=string(folder);


numAugmentations = 1;
augmenter = audioDataAugmenter(NumAugmentations=numAugmentations, ...
    TimeStretchProbability=0, ...
    VolumeControlProbability=0, ...
    ...
    PitchShiftProbability=0, ...
    ...
    TimeShiftProbability=1, ...
     TimeShiftRange=[-0.3,0.3],...
    AddNoiseProbability=0, ...
    SNRRange=[-5,5]);


currentDir = pwd;
writeDirectory = fullfile(dir,folder);
mkdir(writeDirectory)
N = numel(ads.Files)*numAugmentations;
reset(ads)
numPartitions = 1;
tic

parfor ii = 1:numPartitions
    adsPart = partition(ads,numPartitions,ii);
    while hasdata(adsPart)
        [x,adsInfo] = read(adsPart);
        data = augment(augmenter,x,adsInfo.SampleRate);

        [~,fn] = fileparts(adsInfo.FileName);
        for i = 1:size(data,1)
            augmentedAudio = data.Audio{i};
            augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],"all");
            augNum = num2str(i);
            if numel(augNum)==1
                iString = ['0',augNum];
            else
                iString = augNum;
            end
            audiowrite(fullfile(writeDirectory,sprintf('%s_aug%s.wav',fn,iString)),augmentedAudio,adsInfo.SampleRate);
        end
    end
end
end
disp("Augmentation complete in " + round(toc/60,2) + " minutes.")