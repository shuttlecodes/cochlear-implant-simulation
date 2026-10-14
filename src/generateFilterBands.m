function filterBands = generateFilterBands(numBands, minFrequency, maxFrequency, overlapRatio, spacing)
    if nargin < 5, spacing = 'log'; end

    switch spacing
        case 'log'
            bandEdges = logspace(log10(minFrequency), log10(maxFrequency), numBands + 1);
        case 'linear'
            bandEdges = linspace(minFrequency, maxFrequency, numBands + 1);
    end

    filterBands = zeros(numBands, 2);
    for i = 1:numBands
        centerFrequency = mean([bandEdges(i), bandEdges(i + 1)]);
        bandWidth = (bandEdges(i + 1) - bandEdges(i)) * (1 + overlapRatio);

        filterBands(i, 1) = max(minFrequency, centerFrequency - bandWidth / 2);
        filterBands(i, 2) = min(maxFrequency - 1, centerFrequency + bandWidth / 2);
    end
end