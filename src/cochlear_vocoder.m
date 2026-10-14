function [outputSignal, fs] = cochlear_vocoder(inputPath, outputPath, options)
% COCHLEAR_VOCODER  Simulate cochlear implant processing with a channel vocoder.
%
%   y = cochlear_vocoder('in.wav')                 % final design, no file saved
%   cochlear_vocoder('in.wav', 'out.wav')          % also writes out.wav
%   cochlear_vocoder('in.wav', 'out.wav', 'numBands', 17, 'overlapRatio', 0)
%
%   Name-value options:
%     numBands       (32)    number of channels
%     minFrequency   (100)   Hz
%     maxFrequency   (8000)  Hz
%     overlapRatio   (0.5)   0 = no overlap, 0.5 = 50% (Design #2)
%     spacing        ('log') 'log' or 'linear'  (linear = Design #5)
%     filterType     ('butter') 'butter' | 'cheby1' | 'ellip'  (Designs #1, #3, #4)
%     envelopeCutoff (400)   Hz, lowpass cutoff for envelope extraction
%     play           (false) play the result through the speakers

    arguments
        inputPath (1,:) char
        outputPath (1,:) char = ''
        options.numBands (1,1) double {mustBePositive} = 32
        options.minFrequency (1,1) double {mustBePositive} = 100
        options.maxFrequency (1,1) double {mustBePositive} = 8000
        options.overlapRatio (1,1) double {mustBeNonnegative} = 0.5
        options.spacing (1,:) char {mustBeMember(options.spacing, {'log','linear'})} = 'log'
        options.filterType (1,:) char {mustBeMember(options.filterType, {'butter','cheby1','ellip'})} = 'butter'
        options.envelopeCutoff (1,1) double {mustBePositive} = 400
        options.play (1,1) logical = false
    end

    [x, fs] = audioread(inputPath);
    x = convertToMono(x);
    [x, fs] = downsampleTo16kHz(x, fs);

    n = options.numBands;
    bands = generateFilterBands(n, options.minFrequency, options.maxFrequency, ...
                                options.overlapRatio, options.spacing);

    envelopes = zeros(n, length(x));
    for i = 1:n
        bandOut = bandpassFilter(x, fs, bands(i, :), options.filterType);
        envelopes(i, :) = extractEnvelope(bandOut, fs, options.envelopeCutoff);
    end

    modulated = amplitudeModulateCosine(bands, envelopes, fs);

    outputSignal = sum(modulated, 1).';            % column vector (samples x 1)
    outputSignal = outputSignal / max(abs(outputSignal));

    if options.play
        sound(outputSignal, fs);
    end
    if ~isempty(outputPath)
        audiowrite(outputPath, outputSignal, fs);
    end
end