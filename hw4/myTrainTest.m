function [trainRr, testRr]=myTrainTest(ds4train, ds4test, classifier)
    % addpath c:/users/openo/matlab/toolbox/machineLearning
    if strcmp(classifier, 'nbc')
        [cPrm, ~, recogRate1]=nbcTrain(ds4train);
        trainRr = recogRate1;
        [~, ~, recogRate2, ~]=nbcEval(ds4test, cPrm, 1);
        testRr = recogRate2;
    elseif strcmp(classifier, 'qc')
        [cPrm, ~, recogRate1]=qcTrain(ds4train);
        trainRr = recogRate1;
        [~, ~, recogRate2, ~]=qcEval(ds4test, cPrm, 1);
        testRr = recogRate2;
    end
end
