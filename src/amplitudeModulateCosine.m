function modulatedSignals = amplitudeModulateCosine(filterBands, envelopes, fs)
    numBands = size(filterBands, 1);
    timeVector = (0:size(envelopes, 2) - 1) / fs;
    modulatedSignals = zeros(size(envelopes));

    for i = 1:numBands
        centralFrequency = mean(filterBands(i, :));
        cosineSignal = cos(2 * pi * centralFrequency * timeVector);
        modulatedSignals(i, :) = envelopes(i, :) .* cosineSignal;
    end
end