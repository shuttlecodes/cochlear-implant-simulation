# Cochlear Implant Sound Processor Simulation

A MATLAB simulation of cochlear implant signal processing using a channel vocoder.
Built for SYDE 252: Linear Systems and Signals group project.

This repository presents the project's code and reports. It is a coursework
showcase rather than a packaged tool.

## Overview

A cochlear implant replaces the ear's frequency analysis with a bank of bandpass
filters, each driving one electrode. This project simulates the result in three
phases:

| Phase | Focus | Report |
|---|---|---|
| 1 | Audio basics (mono conversion, resampling, playback) and defining evaluation criteria | |
| 2 | 17-band log-spaced Butterworth filter bank and envelope extraction | [report](docs/phase-2.pdf) |
| 3 | Full vocoder, five design iterations, listener evaluation, channel-count optimization | [report](docs/phase-3.pdf) |

## How the processing works

1. Convert the input to mono and resample to 16 kHz
2. Split the signal into N bandpass channels spanning 100 Hz to 8 kHz
3. Rectify each channel and apply a 400 Hz lowpass filter to extract its envelope
4. Modulate a cosine at each band's center frequency with that envelope
5. Sum all channels and normalize

## Design comparison (Phase 3)

The baseline (Design #1) is a 17-band, 2nd-order Butterworth filter bank with
logarithmic spacing. Each later design changes one parameter so its effect can
be isolated. Four listeners scored 16 sounds (speech, man-made, environmental) on a
0-100 scale using weighted metrics: clarity, intelligibility, multi-speaker
performance, naturalness, similarity to input, and noise reduction.

| Design | Change from baseline | Speech | Man-made | Environmental | Overall |
|---|---|---|---|---|---|
| 1 | Baseline | 26.41 | 35.98 | 43.13 | 32.09 |
| 2 | 50% subband overlap | 35.22 | 33.40 | 53.44 | 36.81 |
| 3 | Chebyshev filters | 21.43 | 22.48 | 36.25 | 23.68 |
| 4 | Elliptic filters | 20.07 | 25.33 | 38.75 | 24.38 |
| 5 | Linear band spacing | 40.52 | 44.79 | 45.31 | 42.72 |

### Final design: #2 with 32 channels

Design #5 had the highest weighted score, but listeners described its output as
monotonic and robotic, and adding channels made this worse and made individual
speakers harder to tell apart. Linear spacing also doesn't match the ear's roughly
logarithmic frequency perception. Design #2 was the best-performing design that kept
log spacing, and overlapping bands improved speech clarity and intelligibility by
avoiding gaps and sharp transitions at band edges. The final design raises it to 32
channels to improve multi-speaker performance and noise reduction, while staying
within a hardware-feasible upper bound (commercial implants typically use 12 to 22
channels). Chebyshev and elliptic filters introduced passband ripple that distorted
speech.

## Repository contents

```
phases/   original coursework code for each phase (this produced the report results)
docs/     project reports (PDF)
images/   figures from the reports
src/      refactored Phase 3 code (see note below)
```

### Refactored version (`src/`)

After the course, I split the Phase 3 code into separate functions with options
(`numBands`, `overlapRatio`, `spacing`, `filterType`) so one function could
reproduce every design.

If you run the code: it needs MATLAB (R2020a or newer) and the Signal Processing
Toolbox.

## Limitations and future work

- A cosine carrier at each band's center is a simplification. Real implants use
  pulsatile electrical stimulation.
- Evaluation was subjective, with only four listeners. The Phase 3 report proposes
  an objective pitch-contour fidelity metric (using MATLAB's `pitch` and
  `harmonicRatio`) that was not implemented.
- Scores come from a small sample set and are not clinical results.
