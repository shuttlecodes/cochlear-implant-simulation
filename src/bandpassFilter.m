function bandOutput = bandpassFilter(inputSignal, fs, band, filterType)
    if nargin < 4, filterType = 'butter'; end
    Wn = band / (fs / 2);

    switch filterType
        case 'butter'
            [b, a] = butter(2, Wn, 'bandpass');
        case 'cheby1'
            [b, a] = cheby1(2, 1, Wn, 'bandpass');       % 1 dB passband ripple (see note below)
        case 'ellip'
            [b, a] = ellip(2, 1, 40, Wn, 'bandpass');    % 1 dB ripple, 40 dB stopband (see note below)
    end

    bandOutput = filter(b, a, inputSignal);
end