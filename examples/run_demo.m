% Vocodes every .wav in examples/input with the final design.
root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root, 'src'));
inDir  = fullfile(root, 'examples', 'input');
outDir = fullfile(root, 'examples', 'output');
if ~exist(outDir, 'dir'), mkdir(outDir); end

files = dir(fullfile(inDir, '*.wav'));
for k = 1:numel(files)
    [~, name] = fileparts(files(k).name);
    outPath = fullfile(outDir, [name '_vocoded.wav']);
    cochlear_vocoder(fullfile(inDir, files(k).name), outPath);
    fprintf('Wrote %s\n', outPath);
end