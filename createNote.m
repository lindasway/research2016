
% The first function in the file must have the same name
% as the file name.  This is the function you call from
% the command line.
% For example, createNote(1, 440, 44100, 120, 1);

function note = createNote( noteType, freq, sr, bpm, timbre)
[sampspn, secspn] = initializeNoteTypes(4, sr, bpm);
%note = makeNote(noteType, freq, sr, bpm, bpn, sampspn, secspn);
if (timbre == 1)
    note = singlePitchWave(freq, 0.8, secspn(noteType), sr);
elseif (timbre == 2)
    note = sawtoothWave(freq, 100, 0.8, secspn(noteType), sr);
elseif (timbre == 3)
    note = squareWave(freq, 100, 0.8, secspn(noteType), sr);
elseif (timbre == 4)
    note = triangleWave(freq, 100, 0.8, secspn(noteType), sr);
elseif (timbre == 0)
    note = singlePitchWave(freq, 0.8, secspn(noteType), sr);
    pause(1);
    note = sawtoothWave(freq, 100, 0.8, secspn(noteType), sr);
    pause(1);
    note = squareWave(freq, 100, 0.8, secspn(noteType), sr);
    pause(1)
    note = triangleWave(freq, 100, 0.8, secspn(noteType), sr);
    end
end

function [sampspn, secspn] = initializeNoteTypes(beatsPerWholeNote, sr, bpm)
% sr is sampling rate
% bpm is beats per minute
% bpn is beats per note
% sampspn is samples per note
% secspn is seconds per note
bpn = zeros(1, 5);
sampspn = zeros(1, 5);
secspn = zeros(1, 5);
bpn(1) = beatsPerWholeNote;
% Set the number of beats for each type of
% note, from a full note down to sixteenth
% Each note has half the number of beats than
% the previous one
for i = 2:5
    bpn(i) = bpn(i-1)/2;
end

% Set the number of seconds for each type
% of note.  For example, if there are 120 beats
% per minute, then there 120/60 = 2 beats per second
% If there are 2 beats per second and
% each whole note has four beats, then
% each whole note is 4/2 = 2 seconds long
for i = 1:5
    secspn(i) = bpn(i) / (bpm/60);
end

% Set the number of samples for each
% type of note.  For example, if a
% whole note is 2 seconds long, then it
% consists of 44100 * 2 samples
for i = 1:5
    sampspn(i) = secspn(i) * sr;
end

end

function note = makeNote(noteType, freq, sr, bpm, bpn, sampspn, secspn)
% noteType is an index to a global array of
% note types.  1.whole 2. half 3.quarter 4. eighth 5.sixteenth

% sr is sampling rate
% bpm is beats per minute
% freq is the frequency of the note to be created
% the variable note given as output is the array of
% sample values for the note

%bpn, sampspn, and secspn are arrays that are
%initialized in initializeNoteTypes

% Create an array of input values for the
% sine function that will create the
% sound sample values
% the array goes from 0 seconds to the number
% of seconds for the note to be played,
% which is stored in secspn(i).  There
% are secspn*sr number of samples in the array
% For example, if a whole note is 2 seconds
% long and has 88200 samples, then you need
% an array that is evenly spread out between
% 0 and 2 seconds, having 88200 points in
% time over which the sine function will be
% evaluated
t = linspace(0, secspn(noteType), sampspn(noteType));
% Evaluate the sine function over the array
% t, producing an array of sound samples called note
note = 0.8 * sin(2*pi*freq*t);

end