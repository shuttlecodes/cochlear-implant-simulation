% Renders Designs #1-#5 and the final design from the report
root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root, 'src'));
inFile = fullfile(root, 'examples', 'input', 'two-males.wav');
outDir = fullfile(root, 'examples', 'output', 'designs');
if ~exist(outDir, 'dir'), mkdir(outDir); end

designs = {
    'design1_baseline',   {'numBands', 17, 'overlapRatio', 0}
    'design2_overlap',    {'numBands', 17, 'overlapRatio', 0.5}
    'design3_chebyshev',  {'numBands', 17, 'overlapRatio', 0, 'filterType', 'cheby1'}
    'design4_elliptic',   {'numBands', 17, 'overlapRatio', 0, 'filterType', 'ellip'}
    'design5_linear',     {'numBands', 17, 'overlapRatio', 0, 'spacing', 'linear'}
    'final_32ch_overlap', {'numBands', 32, 'overlapRatio', 0.5}
};

for k = 1:size(designs, 1)
    outPath = fullfile(outDir, ['two-males_' designs{k,1} '.wav']);
    cochlear_vocoder(inFile, outPath, designs{k,2}{:});
    fprintf('Wrote %s\n', outPath);
end