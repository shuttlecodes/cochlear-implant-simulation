function envelope = extractEnvelope(bandOutput, fs, lowpassCutoff)
    rectifiedSignal = abs(bandOutput);
    Wn_lowpass = lowpassCutoff / (fs / 2);
    [b_lowpass, a_lowpass] = butter(2, Wn_lowpass, 'low');
    envelope = filter(b_lowpass, a_lowpass, rectifiedSignal);
end