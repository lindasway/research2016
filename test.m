function nmat = test(sr, beatsInWholeNote, bpm)
[sampspn, secspn, bpn] = initializeNoteTypes(beatsInWholeNote, sr, bpm);
nmat = zeros(10,7);
prevTime = 0;
waitTime = 0.5;
onsetInBeats = 0;
for i=1:6
    n = round(rand()*12) + 1;
    midiNum = 60+n
    freq = 261.63 * 2^((n)/12);
    timbre = int8((rand()*3)) + 1;
    noteType = int8(round(rand()*4)) + 1
    note = createNote( noteType, freq, sr, timbre, secspn(noteType), sampspn(noteType));
    nmat(i,1) = onsetInBeats;               %onsetInBeats
    nmat(i,2) = beatsInWholeNote/noteType;  %durationInBeats
    nmat(i,3)= 1;                           %MIDI channel;
    nmat(i,4) = 60 + n;                     %MIDI pitch
    nmat(i,5) = 127;                        %velocity
    nmat(i,6) = prevTime;                   %onset
    nmat(i,7) = secspn(noteType);           %duration
    prevTime = prevTime + secspn(noteType);
    onsetInBeats = onsetInBeats + bpn(noteType);
    pause(secspn(noteType) + waitTime);
end
writemidi(nmat, 'test.mid');
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

function [sampspn, secspn, bpn] = initializeNoteTypes(beatsPerWholeNote, sr, bpm)
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
    sampspn(i) = int16((secspn(i) * sr));
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

