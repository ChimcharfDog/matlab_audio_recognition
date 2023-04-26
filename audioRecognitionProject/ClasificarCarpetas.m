%% Crema
clear all
ads = audioDatastore('D:\U\9\Aprendizaje Automatico\Proyecto 2\archive4\Total\',IncludeSubfolders=true,LabelSource="foldernames");
labelTableV = countEachLabel(ads)
numClasses = height(labelTableV);
[adsTrain, adsValidation] = splitEachLabel(ads,0.8);
countEachLabel(adsTrain)
countEachLabel(adsValidation) 

%%
 for i=1:1:length(filepaths)
filename=cell2mat(filepaths(i,1))
  if emotionChar(i)=='A'
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Crema\Angry\';
    movefile(filename,figuresdir);
 elseif emotionChar(i)=='D'
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Crema\Disgust\';
    movefile(filename,figuresdir);
 elseif emotionChar(i)=='F'
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Crema\Fear\';
    movefile(filename,figuresdir);
 elseif emotionChar(i)=='H'
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Crema\Happy\';
    movefile(filename,figuresdir);
 elseif emotionChar(i)=='N'
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Crema\Neutral\';
    movefile(filename,figuresdir);
 elseif emotionChar(i)=='S'
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Crema\Sad';
    movefile(filename,figuresdir);
 end
 end


%% Tess 
clear all
ads = audioDatastore('D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Tess - Copia\',IncludeSubfolders=true,LabelSource="foldernames");
filepaths = ads.Files;
ifiles=length(filepaths);
emotionCodes = ads.Labels;
summary(ads.Labels)
labelTable=table(ads.Labels)
emotionChar=string(ads.Labels)

%%
 for i=1:1:length(filepaths)
filename=cell2mat(filepaths(i,1))
  if contains(emotionChar(i),"Neutral")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Tess\Neutral';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i),"Happy")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Tess\Happy';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i,:),"Sad")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Tess\Sad';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i),"Angry")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Tess\Angry';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i),"Fear")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Tess\Fear';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i),"Disgust")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Tess\Disgust';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i,:),"Surprise")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Tess\Surprised';
    movefile(filename,figuresdir);
 end
 end
 
%% Savee
clear all
ads = audioDatastore('D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Savee - Copia\',IncludeSubfolders=true,LabelSource="foldernames");
filepaths = ads.Files;
ifiles=length(filepaths);
emotionCodes = cellfun(@(x)x(end-6),filepaths,UniformOutput=false);
emotionChar=cell2mat(emotionCodes);

%%
 for i=1:1:length(filepaths)
filename=cell2mat(filepaths(i,1))
  if contains(emotionChar(i),"n")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Savee\Neutral';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i),"h")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Savee\Happy';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i,:),"sa")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Savee\Sad';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i),"a")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Savee\Angry';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i),"f")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Savee\Fear';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i),"d")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Savee\Disgust';
    movefile(filename,figuresdir);
 elseif contains(emotionChar(i,:),"su")
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Savee\Surprised';
    movefile(filename,figuresdir);
 end
 end

%% Ravdess

clear all
ads = audioDatastore('D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess - copia\audio_speech_actors_01-24',IncludeSubfolders=true,LabelSource="foldernames");
filepaths = ads.Files;
ifiles=length(filepaths);
emotionCodes = cellfun(@(x)x(end-17:end-16),filepaths,UniformOutput=false);
emotionChar=cell2mat(emotionCodes);
emotionNum=str2num(emotionChar);

%%
 for i=1:1:length(filepaths)
filename=cell2mat(filepaths(i,1))
  if emotionNum(i)==1
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess\Neutral\';
    movefile(filename,figuresdir);
 elseif emotionNum(i)==2
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess\Calm\';
    movefile(filename,figuresdir);
 elseif emotionNum(i)==3
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess\Happy\';
    movefile(filename,figuresdir);
 elseif emotionNum(i)==4
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess\Sad\';
    movefile(filename,figuresdir);
 elseif emotionNum(i)==5
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess\Angry\';
    movefile(filename,figuresdir);
 elseif emotionNum(i)==6
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess\Fear';
    movefile(filename,figuresdir);
 elseif emotionNum(i)==7
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess\Disgust';
    movefile(filename,figuresdir);
 elseif emotionNum(i)==8
    figuresdir = 'D:\U\9\Aprendizaje Automatico\Proyecto 2\archive3\Ravdess\Surprised';
    movefile(filename,figuresdir);
 end
 end
