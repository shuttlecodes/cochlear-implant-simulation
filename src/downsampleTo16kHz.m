function [outSignal, targetFs] = downsampleTo16kHz(inSignal, fs)
    targetFs = 16000;
    if fs ~= targetFs
        outSignal = resample(inSignal, targetFs, fs);
    else
        outSignal = inSignal;
    end
end