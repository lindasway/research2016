function Contrapuntal()
global sr;
global numChords;
global temp;
global prevnotetop;
global prevnotebot;
global nownotetop;
global nownotebot;
global scale;
global chordArray;
global containsSeventhRH;
global containsSeventhLH;

prevnotetop = 0;
prevnotebot = 0;
nownotetop = 0;
nownotebot = 0;

prevnotetop = scale(17);
prevnotebot = scale(14);

chord = (round(rand(1) * 5)) + 2;
f = 1;

for j = 2:numChords
    f = f + 1;
    sr = temp;
    if (chord == 1)
        chordArray = [scale(1) scale(3) scale(5) scale(8) scale(10) scale(12) scale(15) scale(17) scale(19) scale(22) scale(24) scale(26) scale(29)];
        chordArray = chordArray(randperm(length(chordArray)));
        findIntervals();
        chord = (round(rand(1) * 5)) + 2;
        disp('enter 1');

    elseif (chord == 2)
        chordArray = [scale(2) scale(4) scale(6) scale(9) scale(11) scale(13) scale(16) scale(18) scale(20) scale(23) scale(25) scale(27)];
        chordArray = chordArray(randperm(length(chordArray)));
        findIntervals();
        nextchord = (round(rand(1)*3)+1);
        if (nextchord == 1)
            chord = 1;
        elseif (nextchord == 2)
            chord = 4;
        elseif(nextchord == 3)
            chord = 5;
        elseif (nextchord == 4)
            chord = 7;
        end
        disp('enter 2');
    
    elseif (chord == 3)
        chordArray = [scale(3) scale(5) scale(7) scale(10) scale(12) scale(14) scale(17) scale(19) scale(21) scale(24) scale(26) scale(28)];
        chordArray = chordArray(randperm(length(chordArray)));
        findIntervals();
        if (nownotetop == scale(7) || nownotetop == scale(14) || nownotetop == scale(21) || nownotetop == scale(28))
            chord = 6;
            containsSeventhRH = true;
        end
        if (nownotebot == scale(7) || nownotebot == scale(14) || nownotebot == scale(21) || nownotebot == scale(28))
            chord = 6;
            containsSeventhLH = true;
        end
        nextchord = round(rand(1)*1) +1;
        if (nextchord == 1)
            chord = 6;
        elseif (nextchord == 2)
            chord = 2;
        end
        disp('enter 3');
        
    elseif (chord == 4)
        chordArray = [scale(1) scale(4) scale(6) scale(8) scale(11) scale(13) scale(15) scale(18) scale(20) scale(22) scale(25) scale(27) scale(29)];
        chordArray = chordArray(randperm(length(chordArray)));
        findIntervals();
        nextchord = round(rand(1)*2) +1;
        if (nextchord == 1)
            chord = 2;
        elseif(nextchord == 2)
            chord = 5;
        elseif(nextchord == 3)
            chord = 7;
        end
        disp('enter 4');
        
    elseif(chord == 5)
        chordArray = [scale(2) scale(5) scale(7) scale(9) scale(12) scale(14) scale(16) scale(19) scale(21) scale(23) scale(26) scale(28)];
        chordArray = chordArray(randperm(length(chordArray)));
        findIntervals();
        nextchord = round(rand(1)*1) +1;
        if (nextchord == 1)
            chord = 2;
        elseif(nextchord == 2)
            chord = 4;
        end
        disp('enter 5');
        
    elseif (chord == 6)
        chordArray = [scale(1) scale(3) scale(6) scale(8) scale(10) scale(13) scale(15) scale(17) scale(20) scale(22) scale(24) scale(27)];
        chordArray = chordArray(randperm(length(chordArray)));
        findIntervals();
        
        nextchord = round(rand() *2) + 1;
        if (nextchord == 1)
            chord = 4;
        else
            chord = nextchord;
        end
        disp('enter 6');
        
    elseif(chord == 7)
        chordArray = [scale(2) scale(4) scale(7) scale(9) scale(11) scale(14) scale(16) scale(18) scale(21) scale(23) scale(25) scale(28)];
        chordArray = chordArray(randperm(length(chordArray)));
        findIntervals();
        nextchord = round(rand(1)*1) +1;
        if(nextchord == 1)
            chord = 1;
        elseif(nextchord == 2)
            chord = 6;
        end
        disp('enter 7');
    end
    j = j + 1; 
    
    Nonharmonic();

end
disp('F:');
disp(f);
end