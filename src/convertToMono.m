function monoData = convertToMono(inputSignal)
    if size(inputSignal, 2) > 1
        monoData = mean(inputSignal, 2);
    else
        monoData = inputSignal;
    end
end