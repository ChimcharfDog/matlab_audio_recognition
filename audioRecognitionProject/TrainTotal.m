
%% Almacenando Audio

%direccion de la Carpeta con los audios
%Los audios deben estar divididos en sus respectivas emociones
%En este caso las databases de Tess,Crema,Ravdess y Savee estan
%consolidadas en 6 emociones(Angry,Disgust,Fear,Happy,Sad,Neutral)
dir='D:\U\9\Aprendizaje Automatico\Proyecto 2\archive4\Total';
ads = audioDatastore(dir,IncludeSubfolders=true,LabelSource="foldernames");
labelTableV = countEachLabel(ads)
numClasses = height(labelTableV);
[adsTrain, adsValidation] = splitEachLabel(ads,0.8);
trainTable=countEachLabel(adsTrain)
validationTable=countEachLabel(adsValidation) 
%% Procesamiento Datos de Entrenamiento

trainFeaturesTotal = [];
trainLabelsTotal = [];
overlapPercentage = 75;
% Recomendado (#TotaldeAudios/300)=(9052/300)
numPartitions = round(length(adsTrain.Files)/300)
tic

%Creacion de los espectogramas
for ii = 1:numPartitions
    ii
    adsPartTrain = partition(adsTrain,numPartitions,ii);
    %Matrices Importantes
    trainFeatures = [];
    trainLabels = [];
    
    while hasdata(adsPartTrain)

        [audioIn,fileInfo] = read(adsPartTrain);
        features = vggishPreprocess(audioIn,fileInfo.SampleRate,OverlapPercentage=overlapPercentage);
        numSpectrograms = size(features,4);
        trainFeatures = cat(4,trainFeatures,features);
        trainLabels = cat(2,trainLabels,repelem(fileInfo.Label,numSpectrograms));
    end
    %Concatenaciones
    trainFeaturesTotal = cat(4,trainFeaturesTotal,trainFeatures);
    trainLabelsTotal = cat(2,trainLabelsTotal,trainLabels);
end 

disp("Train Process complete in " + round(toc/60,2) + " minutes.")

%% Procesamiento Datos de Validacion
tic
overlapPercentage = 75;
validationFeaturesTotal = [];
validationLabelsTotal = [];
segmentsPerFileTotal = [];
i=0;
% Recomendado (#TotaldeAudios/300)=(2266/300)
numPartitions=round(length(ads.Validation)/300);

for ii = 1:numPartitions
    ii
    adsPartValidation = partition(adsValidation,numPartitions,ii);
    validationFeatures = [];
    validationLabels = [];
    segmentsPerFile = zeros(numel(adsPartValidation.Files), 1);
    idx = 1;
    while hasdata(adsPartValidation)
        [audioIn,fileInfo] = read(adsPartValidation);
        features = vggishPreprocess(audioIn,fileInfo.SampleRate,OverlapPercentage=overlapPercentage);
        numSpectrograms = size(features,4);
        validationFeatures = cat(4,validationFeatures,features);
        validationLabels = cat(2,validationLabels,repelem(fileInfo.Label,numSpectrograms));

        segmentsPerFile(idx) = numSpectrograms;
        idx = idx + 1;
        i=i+1;
    end
    validationFeaturesTotal = cat(4,validationFeaturesTotal,validationFeatures);
    validationLabelsTotal = cat(2,validationLabelsTotal,validationLabels);
    segmentsPerFileTotal=cat(1,segmentsPerFileTotal,segmentsPerFile);
end
disp("Validation Process complete in " + round(toc/60,2) + " minutes.")
%% Entrenamiento Red Vggish
%Correr Solo Red Vggish o Solo Red YamNet
net = vggish;
lgraph = layerGraph(net.Layers);
lgraph = removeLayers(lgraph,"regressionoutput");
lgraph.Layers(end);
lgraph = addLayers(lgraph,[ ...
    fullyConnectedLayer(numClasses,Name="FCFinal",WeightLearnRateFactor=10,BiasLearnRateFactor=10)
    softmaxLayer(Name="softmax")
    classificationLayer(Name="classOut")]);
lgraph = connectLayers(lgraph,"EmbeddingBatch","FCFinal");
miniBatchSize = 128;
options = trainingOptions('adam', ...
    MaxEpochs=4, ...
    MiniBatchSize=miniBatchSize, ...
    Shuffle="every-epoch", ...
    ValidationData={validationFeaturesTotal,validationLabelsTotal}, ...
    ValidationFrequency=50, ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropFactor=0.5, ...
    LearnRateDropPeriod=2, ...
    Verbose=false, ...
    Plots="training-progress");

[trainedNet, netInfo] = trainNetwork(trainFeaturesTotal,trainLabelsTotal,lgraph,options);
validationPredictions = classify(trainedNet,validationFeaturesTotal);

Vggish1Net=trainedNet;
  %save("VariablesRedTotal3.mat",'segmentsPerFileTotal','trainFeaturesTotal','trainLabelsTotal','validationFeaturesTotal','validationLabelsTotal');

 
%% Entrenamiento Red YamNet
%uniqueLabels = unique(adsTrain.Labels);
uniqueLabels = unique(adsValidation.Labels);
numLabels = numel(uniqueLabels);

net = yamnet;

lgraph = layerGraph(net.Layers);

newDenseLayer = fullyConnectedLayer(numLabels,"Name","dense");
lgraph = replaceLayer(lgraph,"dense",newDenseLayer);

newClassificationLayer = classificationLayer("Name","Sounds","Classes",uniqueLabels);
lgraph = replaceLayer(lgraph,"Sound",newClassificationLayer);

miniBatchSize = 128;
validationFrequency = floor(numel(trainLabelsTotal)/miniBatchSize);
options = trainingOptions('adam', ...
    'InitialLearnRate',3e-4, ...
    'MaxEpochs',6, ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false, ...
    'ValidationData',{single(validationFeaturesTotal),validationLabelsTotal}, ...
    'ValidationFrequency',validationFrequency);
[trainedNet, netInfo] = trainNetwork(trainFeaturesTotal,trainLabelsTotal,lgraph,options);
validationPredictions = classify(trainedNet,validationFeaturesTotal);

YamNet1=trainedNet;
  save("YamNetTotalAug.mat","YamNet1") 
  %save("ValidationYamNet.mat" ,"segmentsPerFile","validationPredictions","adsValidation") 

%% Creacion Matriz de Confusion

%Crea la Matriz para observar el porcentaje de aciertos
idx = 1;
validationPredictionsPerFile = categorical;
for ii = 1:numel(adsValidation.Files)
    validationPredictionsPerFile(ii,1) = mode(validationPredictions(idx:idx+segmentsPerFileTotal(ii)-1));
    idx = idx + segmentsPerFileTotal(ii);
end
plotconfusion(adsValidation.Labels, validationPredictionsPerFile)

