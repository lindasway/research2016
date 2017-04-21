function nmatrow = produceRowBot(noteType, freq, bpm)

global sr;
global prevtimebot;
global onsetInBeatsbot;

load produceMIDI.mat;

beatsInWholeNote = 4;
nmatrow = zeros(1, 7);

[secspn, bpn] = initializeNoteTypes(beatsInWholeNote, sr, bpm);

% determines the number of beats
if (noteType == 1)
    numBeats = 4;
elseif (noteType == 2)
    numBeats = 2;
elseif (noteType == 3)
    numBeats = 1;
elseif (noteType == 4)
    numBeats = 1/2;
elseif (noteType == 5)
    numBeats = 1/4;
end
midiPitch = 0;
% finds midi pitch in terms of calculated frequency
for j = 1:length(produceMIDI)
    %if (produceMIDI(j, 2) == round(freq))
    if (abs(produceMIDI(j, 2) - round(freq) < 15))
        midiPitch = produceMIDI(j, 1);
    else
    end
end

nmatrow(1, 1) = onsetInBeatsbot;
nmatrow(1, 2) = numBeats;
nmatrow(1, 3) = 1;
nmatrow(1, 4) = midiPitch;
nmatrow(1, 5) = 127;
nmatrow(1, 6) = prevtimebot;
nmatrow(1, 7) = secspn(noteType);
prevtimebot = prevtimebot + secspn(noteType);
onsetInBeatsbot = onsetInBeatsbot + numBeats;
end


function note = createNote( noteType, freq, sr, timbre, numSecs, numSamps)
if (timbre == 1)
    note = singlePitchWave(freq, 0.8, sr, numSecs, numSamps);
elseif (timbre == 2)
    note = sawtoothWave(freq, 100, 0.8, sr, numSecs, numSamps);
elseif (timbre == 3)
    note = squareWave(freq, 100, 0.8, sr, numSecs, numSamps);
elseif (timbre == 4)
    note = triangleWave(freq, 100, 0.8, sr, numSecs, numSamps);
end
end

function [secspn, bpn] = initializeNoteTypes(beatsPerWholeNote, sr, bpm)
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
end

function y = singlePitchWave(freq, amp, sampRate, numSecs, numSamps)
%This function creates a sound wave of a single pitch
%Arguments:
%singlePitchWave(Frenquency, Amplitude, Sampling Rate, # Seconds, # Samples)
%Sample function call:
%y =  singlePitchWave(440, .9, 44100, 2, 88200);
t = linspace(0, numSecs, numSamps);
y = amp * sin(2*pi*freq*t);
sound(y, sampRate);
end

function y = squareWave( baseF, numComponents, amp, sampRate, numSecs, numSamps )
%This function produces a square wave, which is composed of the integer
%multiples of the wave's fundamental frequency.
%Arguments:
%squareWave(Base Frequency, # of Components, Amplitude, Sampling Rate, # Seconds,
%# Samples);
%Sample function call from command line:
%y =  squareWave(440, 20, 0.9, 44100, 2, 88200);
t = linspace(0, numSecs, numSamps);
y = zeros(1, numSamps);
for i = 1:numComponents
    y = y + amp * sin(2*pi*baseF*(2*i-1)*t)/(2*i-1);
end
y = amp * y;
sound(y, sampRate);
pause(0.5);
end

function y = triangleWave( baseF, numComponents, amp, sampRate, numSecs, numSamps )
%This function produces a triangle wave, which is composed of the odd integer
%multiples of the wave's fundamental frequency, with alternating signs.
%Arguments:
%triangleWave(Base Frequency, # of Components, Amplitude, Sampling Rate, # of Seconds,
%S# Sanmples);
%Sample function call:
%y =  triangleWave(440, 20, 2, 44100, 2, 88200);
t = linspace(0, numSecs, numSamps);
y = zeros(1, numSamps);
for i = 0:numComponents
    y = y + (8/(pi^2)) * (sin(2*pi*baseF*(4*i+1)*t)/(4*i+1)^2 - sin(2*pi*baseF*(4*i+3)*t)/(4*i+3)^2);
end
y = amp * y;
sound(y, sampRate);
end

function y = sawtoothWave( baseF, numComponents, amp, sampRate, numSecs, numSamps)
%This function produces a square wave, which is composed of the integer
%multiples of the wave's fundamental frequency.
%Arguments:
%sawtoothWave(Base Frequency, # of Components, Amplitude, Sampling Rate, # of Seconds,
%Number of Samples);
%Sample function call from command line:
%y =  sawtoothWave(440, 20, 2, 44100, 2, 88200);
t = linspace(0, numSecs, numSamps);
y = zeros(1, numSamps);
for i = 1:numComponents
    y = y + (2/pi) * sin(2*pi*baseF*i*t)/i;
end
y = y * amp;
sound(y, sampRate);
end

