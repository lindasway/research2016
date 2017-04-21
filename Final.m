function [nmattop, nmatbot, nmat, alltop, allbot] = Final(beatspermin, measure, isminor, cadence, timbre, key, samplingRate)

% examples input:
% Final(100, 35, false, 'resolve', 1, 'C', 44100);

% Final is where the program should run from

global alltop;
global allbot;
global startnote;
global NTtop;
global NTbot;
global sr;
global numChords;
global sampsPerBeat;
global bpm;
global waveform;
global holdNoteRH;
global holdNoteLH;
global beatsHeldRH;
global beatsHeldLH;
global onsetInBeatstop;
global onsetInBeatsbot;
global prevtimetop;
global prevtimebot;
global nmattop;
global nmatbot;

% a lot of variables are set to their initial values here for 
% their varying purposes. Some variables may seem a little 
% redundant but may be done for syntactial errors. 
% e.g. to set the variable to global.
nmat = zeros(1,7);
nmattop = zeros(1, 7);
nmatbot = zeros(1, 7);
prevtimetop = 0;
prevtimebot = 0;
onsetInBeatstop = 1;
onsetInBeatsbot = 1;
beatsHeldRH = 0;
beatsHeldLH = 0;
holdNoteRH = false;
holdNoteLH = false;
waveform = timbre;
numChords = measure;
s = 4;
sr = samplingRate;
bpm = beatspermin;
sampsPerMinute = 60 * sr;
sampsPerBeat = sampsPerMinute/bpm;

NTtop = zeros(1,numChords*2);
NTbot = zeros(1,numChords*2);
alltop = zeros(1, sr*s);
allbot = zeros(1, sr*s);
startnote = 220*(2^((4)/12));

% keyMod will produce a list of scale degrees depending pn
% whether the user wants it to be major/minor and in what key
keyMod(isminor, key);

% contrapuntal contains and builds the overall structure nad 
% rules that surround the style of music
Contrapuntal();

% produces the cadences that the user had entered
Cadences(cadence);

% simply uses the 'sound' function to play the sounds.
Play();

% vertically concatenates the two matrices 'nmattop' and 
% 'nmatbot' this is so the two lines will play together 
% when playing the MIDI file. Since nmattop contains only
% the top line of note's MIDI and nmatbot the bottom.
nmat = vertcat(nmattop, nmatbot, nmat);

% writes the MIDI notes stored in nmat matrice into a file
writemidi(nmattop, 'topmidifile.mid');
writemidi(nmatbot, 'botmidifile.mid');
%writemidi(nmat, 'midifile.mid');

end