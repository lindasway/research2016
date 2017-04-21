function Nonharmonic ()
global alltop;
global allbot;
global startnote;
global bpm;
global scale;
global sr;
global temp;
global prevnotetop;
global prevnotebot;
global nownotetop;
global nownotebot;
global waveform;
global holdNoteRH;
global holdNoteLH;
global beatsHeldRH;
global beatsHeldLH;
global nmattop;
global nmatbot;

% this function is divided into two parts, where they are essentially copies of each other
% the first part include figuring out the nonharmonic tones of the RH and then the second part, the left.
% after the tones are figured out, they are converted to frequencies, converted to MIDI, and then converted to 
% waveforms

% one out of 19 chance of not having a nonharmonic tone
noNH = round(rand() * 18);
    % NT analysis
    sr = temp/2;
% holdNoteRH and holdNoteLH is used for notes that last for more than one beat
    if (~holdNoteRH)
    if (noNH ~= 0)
        % when there are 3 or 4 semitones, there is a passing tone. this is passing tone going up
        if (nownotetop - prevnotetop == 3||nownotetop - prevnotetop == 4)
            NTnotes(1) = prevnotetop;
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j + 1);
                    end
                end  
	    % converts interval to frequency
            NTnotes(1) = startnote * (2.^ (NTnotes(1) / 12));
            % nmats have to with the MIDI conversion
	    nmatrow = produceRowTop(4, NTnotes(1), bpm);
            nmattop = vertcat(nmattop, nmatrow);
            % converts into waveform
	    first = createNote(4, NTnotes(1), 44100, bpm, waveform);
            % does same for the second note
            NTnotes(2) = startnote * (2.^ (NTnotes(2) / 12));
            nmatrow = produceRowTop(4, NTnotes(2), bpm);
            nmattop = vertcat(nmattop, nmatrow);
            second = createNote(4, NTnotes(2), 44100, bpm, waveform);

            alltop = horzcat(alltop, first, second);
            holdNoteRH = false;
        % passing tone going down
        elseif (prevnotetop - nownotetop == 3||prevnotetop - nownotetop == 4)
            % downPT for top array
            NTnotes(1) = prevnotetop;
            for j = 1:length(scale)
                if (scale(j) == NTnotes(1))
                    NTnotes(2) = scale(j - 1);
                end
            end
            NTnotes(1) = startnote * (2.^ (NTnotes(1) / 12));
            nmatrow = produceRowTop(4, NTnotes(1), bpm);
            nmattop = vertcat(nmattop, nmatrow);
            first = createNote(4, NTnotes(1), 44100, bpm, waveform);
            NTnotes(2) = startnote * (2.^ (NTnotes(2) / 12));
            nmatrow = produceRowTop(4, NTnotes(2), bpm);
            nmattop = vertcat(nmattop, nmatrow);
            second = createNote(4, NTnotes(2), 44100, bpm, waveform);

            alltop = horzcat(alltop, first, second);

            holdNoteRH = false;
        % if it is the same note, it can either stay and be a half note, or become a up or down neighbor tone
        elseif (prevnotetop - nownotetop == 0)
            number = round(rand() * 1);
            if (number == 0)
                number = round(rand(1)*1) + 1;
                if (number == 1)
                    %downNT
                    NTnotes(1) = prevnotetop;
                    if (scale(1) == NTnotes(1))
                        NTnotes(2) = scale(2);
                    else
                        for j = 1:length(scale)
                            if(scale(j) == NTnotes(1))
                                NTnotes(2)= scale(j-1);
                            end
                        end
                    end
                elseif(number == 2)
                    %upNT
                    NTnotes(1) = prevnotetop;
                    if (scale(29) == NTnotes(1))
                        NTnotes(2) = scale(28);
                    else
                        for j = 1:length(scale)
                            if (scale(j) == NTnotes(1));
                                NTnotes(2) = scale(j+1);
                            end
                        end
                    end
                end
                NTnotes(1) = startnote * (2.^ (NTnotes(1) / 12));
                nmatrow = produceRowTop(4, NTnotes(1), bpm);
                nmattop = vertcat(nmattop, nmatrow);
                first = createNote(4, NTnotes(1), 44100, bpm, waveform);
                NTnotes(2) = startnote * (2.^ (NTnotes(2) / 12));
                nmatrow = produceRowTop(4, NTnotes(2), bpm);
                nmattop = vertcat(nmattop, nmatrow);
                second = createNote(4, NTnotes(2), 44100, bpm, waveform);

                alltop = horzcat(alltop, first, second);
                holdNoteRH = false;
            
            elseif (number == 1) % half notes or quarter notes
                % this is a 50%  chance to give the music produced more
                % diversity
                num = round(rand() * 1);
                if (num == 0)
                    prevnotetop = startnote * (2.^ (prevnotetop / 12));
                    nmatrow = produceRowTop(2, prevnotetop, bpm);
                    nmattop = vertcat(nmattop, nmatrow);
                    first = createNote(2, prevnotetop, 44100, bpm, waveform);
                    alltop = horzcat(alltop, first);
		    % if half note, then holdNoteRH is set to true.
		    % at the end of the function, it will evalute this and know to skip the next beat as it is a half note
                    holdNoteRH = true;
                else
                    prevnotetop = startnote * (2.^ (prevnotetop / 12));
                    nmatrow = produceRowTop(3, prevnotetop, bpm);
                    nmattop = vertcat(nmattop, nmatrow);
                    first = createNote(3, prevnotetop, 44100, bpm, waveform);
                    alltop = horzcat(alltop, first);
                    holdNoteRH = false;
                end            
            end

            % suspension is replicated here.
        elseif(prevnotetop - nownotetop == 1 || prevnotetop - nownotetop == 2)
            NTnotes(1) = prevnotetop;
            NTnotes(1) = startnote * (2.^ (NTnotes(1) / 12));
            nmatrow = produceRowTop(3, NTnotes(1), bpm);
            nmattop = vertcat(nmattop, nmatrow);
            nmatrow = produceRowTop(4, NTnotes(1), bpm);
            nmattop = vertcat(nmattop, nmatrow);
            first = createNote(3, NTnotes(1), 44100, bpm, waveform);
            second = createNote(4, NTnotes(1), 44100, bpm, waveform);
            NTnotes(2) = nownotetop;
            NTnotes(2) = startnote * (2.^ (NTnotes(2) / 12));
            nmatrow = produceRowTop(4, NTnotes(2), bpm);
            nmattop = vertcat(nmattop, nmatrow);
            third = createNote(4, NTnotes(2), 44100, bpm, waveform);
            alltop = horzcat(alltop, first, second, third);
            holdNoteRH = true;

        % sicteenth note run up and done with 7 semitones in between
        elseif (prevnotetop - nownotetop == 7)
            NTnotes(1) = prevnotetop;
            for j = 1:length(scale)
                if (scale(j) == NTnotes(1))
                    NTnotes(2) = scale(j - 1);
                    NTnotes(3) = scale(j - 2);
                    NTnotes(4) = scale(j - 3);
                end
            end
            for k = 1:4
                NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                nmatrow = produceRowTop(5, NTnotes(k), bpm);
                nmattop = vertcat(nmattop, nmatrow);
                first = createNote(5, NTnotes(k), 44100, bpm, waveform);

                alltop = horzcat(alltop, first);
            end
            holdNoteRH = false;

        elseif (nownotetop - prevnotetop == 7)
            NTnotes(1) = prevnotetop;
            for j = 1:length(scale)
                if (scale(j) == NTnotes(1))
                    NTnotes(2) = scale(j + 1);
                    NTnotes(3) = scale(j + 2);
                    NTnotes(4) = scale(j + 3);
                end
            end
            for k = 1:4
                NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                nmatrow = produceRowTop(5, NTnotes(k), bpm);
                nmattop = vertcat(nmattop, nmatrow);
                first = createNote(5, NTnotes(k), 44100, bpm, waveform);

                alltop = horzcat(alltop, first);
            end
            holdNoteRH = false;        

	% eighth and two sixteenths
        elseif (nownotetop - prevnotetop == 5 || nownotetop - prevnotetop == 6)
          NTnotes(1) = prevnotetop;
            number = round(rand(1)*1) + 1;
            if (number == 1)
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j + 1);
                        NTnotes(3) = scale(j + 2);
                    end
                end

                for k = 1:3
                    NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                    if (k == 2 || k == 3)
                        nmatrow = produceRowTop(5, NTnotes(k), bpm);
                        nmattop = vertcat(nmattop, nmatrow);
                        first = createNote(5, NTnotes(k), 44100, bpm, waveform);
                    else
                        nmatrow = produceRowTop(4, NTnotes(k), bpm);
                        nmattop = vertcat(nmattop, nmatrow);
                        first = createNote(4, NTnotes(k), 44100, bpm, waveform);
                    end
                    alltop = horzcat(alltop, first);
                end
            elseif (number == 2)
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j + 1);
                        NTnotes(3) = scale(j + 2);
                    end
                end

                for k = 1:3
                    NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                    if (k == 1 || k == 2)
                        nmatrow = produceRowTop(5, NTnotes(k), bpm);
                        nmattop = vertcat(nmattop, nmatrow);
                        first = createNote(5, NTnotes(k), 44100, bpm, waveform);
                    else
                        nmatrow = produceRowTop(4, NTnotes(k), bpm);
                        nmattop = vertcat(nmattop, nmatrow);
                        first = createNote(4, NTnotes(k), 44100, bpm, waveform);
                    end
                    alltop = horzcat(alltop, first);
                end   
            end
            holdNoteRH = false;

        elseif (prevnotetop - nownotetop == 5 || prevnotetop - nownotetop == 6)
            NTnotes(1) = prevnotetop;
            number = round(rand(1)*1) + 1;
            if (number == 1)
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j - 1);
                        NTnotes(3) = scale(j - 2);
                    end
                end

                for k = 1:3
                    NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                    if (k == 2 || k == 3)
                        nmatrow = produceRowTop(5, NTnotes(k), bpm);
                        nmattop = vertcat(nmattop, nmatrow);
                        first = createNote(5, NTnotes(k), 44100, bpm, waveform);
                    else
                        nmatrow = produceRowTop(4, NTnotes(k), bpm);
                        nmattop = vertcat(nmattop, nmatrow);
                        first = createNote(4, NTnotes(k), 44100, bpm, waveform);
                    end
                    alltop = horzcat(alltop, first);
                end
            elseif (number == 2)
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j - 1);
                        NTnotes(3) = scale(j - 2);
                    end
                end

                for k = 1:3
                    NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                    if (k == 1 || k == 2)
                        nmatrow = produceRowTop(5, NTnotes(k), bpm);
                        nmattop = vertcat(nmattop, nmatrow);
                        first = createNote(5, NTnotes(k), 44100, bpm, waveform);
                    else
                        nmatrow = produceRowTop(4, NTnotes(k), bpm);
                        nmattop = vertcat(nmattop, nmatrow);
                        first = createNote(4, NTnotes(k), 44100, bpm, waveform);
                    end
                    alltop = horzcat(alltop, first);
                end 
            end
            holdNoteRH = false; 
        % quarter note with no nonharmonic tone if none matches
        else
            prevnotetop = startnote * (2.^ (prevnotetop / 12));
            nmatrow = produceRowTop(3, prevnotetop, bpm);
            nmattop = vertcat(nmattop, nmatrow);
            first = createNote(3, prevnotetop, 44100, bpm, waveform);

            alltop = horzcat(alltop, first);    
            holdNoteRH = false;
        end
    % quarter note with no nonharmonic tones if 1 out of 19 chance with noNH
    else
        prevnotetop = startnote * (2.^ (prevnotetop / 12));
        nmatrow = produceRowTop(3, prevnotetop, bpm);
        nmattop = vertcat(nmattop, nmatrow);
        first = createNote(3, prevnotetop, 44100, bpm, waveform);

        alltop = horzcat(alltop, first);    
        holdNoteRH = false;
    end
    end
    

if (holdNoteRH)
    beatsHeldRH = beatsHeldRH + 1;
end
if (beatsHeldRH == 2)
    holdNoteRH = false;
    beatsHeldRH = 0;
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noNH = round(rand() * 18);

     if (~holdNoteLH)
     if (noNH ~= 0)
	% evaluates LH nonharmonic tones passing tone up
        if (nownotebot - prevnotebot == 3 || nownotebot - prevnotebot == 4)
            number = 2;
            NTnotes(1) = prevnotebot;
            for j = 1:length(scale)
                if (scale(j) == NTnotes(1))
                    NTnotes(2) = scale(j + 1);
                end
            end
            NTnotes(1) = startnote * (2.^ (NTnotes(1) / 12));
            nmatrow = produceRowBot(4, NTnotes(1), bpm);
            nmatbot = vertcat(nmatbot, nmatrow);
            first = createNote(4, NTnotes(1), 44100, bpm, waveform);
            NTnotes(2) = startnote * (2.^ (NTnotes(2) / 12));
            nmatrow = produceRowBot(4, NTnotes(2), bpm);
            nmatbot = vertcat(nmatbot, nmatrow);
            second = createNote(4, NTnotes(2), 44100, bpm, waveform);

            allbot = horzcat(allbot, first, second);
            holdNoteLH = false;

        elseif (prevnotebot - nownotebot == 3||prevnotebot - nownotebot == 4)
            number = 2;
            NTnotes(1) = prevnotebot;
            for j = 1:length(scale)
                if (scale(j) == NTnotes(1))
                    NTnotes(2) = scale(j - 1);
                end
            end
            NTnotes(1) = startnote * (2.^ (NTnotes(1) / 12));
            nmatrow = produceRowBot(4, NTnotes(1), bpm);
            nmatbot = vertcat(nmatbot, nmatrow);
            first = createNote(4, NTnotes(1), 44100, bpm, waveform);
            NTnotes(2) = startnote * (2.^ (NTnotes(2) / 12));
            nmatrow = produceRowBot(4, NTnotes(2), bpm);
            nmatbot = vertcat(nmatbot, nmatrow);
            second = createNote(4, NTnotes(2), 44100, bpm, waveform);

            allbot = horzcat(allbot, first, second);
            holdNoteLH = false;

        elseif (prevnotebot - nownotebot == 0)
            number = 0;
            if (number == 0)
                number = 2;
                number = round(rand(1)*1) + 1;
                if (number == 1)
                    %downNT
                    NTnotes(1) = prevnotebot;
                    if (scale(1) == NTnotes(1))
                        NTnotes(2) = scale(2);
                    else
                        for j = 1:length(scale)
                            if(scale(j) == NTnotes(1))
                                NTnotes(2)= scale(j-1);
                            end
                        end
                    end
                elseif(number == 2)
                    %upNT
                    NTnotes(1) = prevnotebot;
                    if (NTnotes(1) == scale(29))
                        NTnotes(2) = scale(28);
                    else
                        for j = 1:length(scale)
                            if (scale(j) == NTnotes(1));
                                NTnotes(2) = scale(j+1);
                            end
                        end
                    end
                end 
                NTnotes(1) = startnote * (2.^ (NTnotes(1) / 12));
                nmatrow = produceRowBot(4, NTnotes(1), bpm);
                nmatbot = vertcat(nmatbot, nmatrow);
                first = createNote(4, NTnotes(1), 44100, bpm, waveform);
                NTnotes(2) = startnote * (2.^ (NTnotes(2) / 12));
                nmatrow = produceRowBot(4, NTnotes(2), bpm);
                nmatbot = vertcat(nmatbot, nmatrow);
                second = createNote(4, NTnotes(2), 44100, bpm, waveform);

                allbot = horzcat(allbot, first, second);
                holdNoteLH = false;

            % either will be half note or quarter note, for variation
            elseif (number == 1)
                num = round(rand() * 1);
                if (num == 0)
                    prevnotebot = startnote * (2.^ (prevnotebot / 12));
                    nmatrow = produceRowBot(2, prevnotebot, bpm);
                    nmatbot = vertcat(nmatbot, nmatrow);
                    first = createNote(2, prevnotebot, 44100, bpm, waveform);
                    allbot = horzcat(allbot, first);
                    holdNoteLH = true;
                else
                    prevnotebot = startnote * (2.^ (prevnotebot / 12));
                    nmatrow = produceRowBot(3, prevnotebot, bpm);
                    nmatbot = vertcat(nmatbot, nmatrow);
                    first = createNote(3, prevnotebot, 44100, bpm, waveform);
                    allbot = horzcat(allbot, first);
                    holdNoteLH = false;
                end
            end

        elseif(prevnotebot - nownotebot == 1 || prevnotebot - nownotebot == 2)
            NTnotes(1) = prevnotebot;
            NTnotes(1) = startnote * (2.^ (NTnotes(1) / 12));
            nmatrow = produceRowBot(3, NTnotes(1), bpm);
            nmatbot = vertcat(nmatbot, nmatrow);
            nmatrow = produceRowBot(4, NTnotes(1), bpm);
            nmatbot = vertcat(nmatbot, nmatrow);
            first = createNote(3, NTnotes(1), 44100, bpm, waveform);
            second = createNote(4, NTnotes(1), 44100, bpm, waveform);
            NTnotes(2) = nownotebot;
            NTnotes(2) = startnote * (2.^ (NTnotes(2) / 12));
            nmatrow = produceRowBot(4, NTnotes(2), bpm);
            nmatbot = vertcat(nmatbot, nmatrow);
            third = createNote(4, NTnotes(2), 44100, bpm, waveform);

            allbot = horzcat(allbot, first, second, third);
            holdNoteLH = true;

        elseif (nownotebot - prevnotebot == 7)
            NTnotes(1) = prevnotebot;
            for j = 1:length(scale)
                if (scale(j) == NTnotes(1))
                    NTnotes(2) = scale(j + 1);
                    NTnotes(3) = scale(j + 2);
                    NTnotes(4) = scale(j + 3);
                end
            end
            for k = 1:4
                NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                nmatrow = produceRowBot(5, NTnotes(k), bpm);
                nmatbot = vertcat(nmatbot, nmatrow);
                first = createNote(5, NTnotes(k), 44100, bpm, waveform);

                allbot = horzcat(allbot, first);
            end
            holdNoteLH = false;

        elseif (prevnotebot - nownotebot == 7)
            NTnotes(1) = prevnotebot;
            for j = 1:length(scale)
                if (scale(j) == NTnotes(1))
                    NTnotes(2) = scale(j - 1);
                    NTnotes(3) = scale(j - 2);
                    NTnotes(4) = scale(j - 3);
                end
            end
            for k = 1:4
                NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                nmatrow = produceRowBot(5, NTnotes(k), bpm);
                nmatbot = vertcat(nmatbot, nmatrow);
                first = createNote(5, NTnotes(k), 44100, bpm, waveform);

                allbot = horzcat(allbot, first);
            end

        elseif (nownotebot - prevnotebot == 5 || nownotebot - prevnotebot == 6)
            NTnotes(1) = prevnotebot;
            number = round(rand(1)*1) + 1;
            if (number == 1)
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j + 1);
                        NTnotes(3) = scale(j + 2);
                    end
                end

                for k = 1:3
                    NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                    if (k == 2 || k == 3)
                        nmatrow = produceRowBot(5, NTnotes(k), bpm);
                        nmatbot = vertcat(nmatbot, nmatrow);
                        first = createNote(5, NTnotes(k), 44100, bpm, waveform);
                    else
                        nmatrow = produceRowBot(4, NTnotes(k), bpm);
                        nmatbot = vertcat(nmatbot, nmatrow);
                        first = createNote(4, NTnotes(k), 44100, bpm, waveform);
                    end
                    allbot = horzcat(allbot, first);
                end
            elseif (number == 2)
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j + 1);
                        NTnotes(3) = scale(j + 2);
                    end
                end

                for k = 1:3
                    NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                    if (k == 1 || k == 2)
                        nmatrow = produceRowBot(5, NTnotes(k), bpm);
                        nmatbot = vertcat(nmatbot, nmatrow);
                        first = createNote(5, NTnotes(k), 44100, bpm, waveform);
                    else
                        nmatrow = produceRowBot(4, NTnotes(k), bpm);
                        nmatbot = vertcat(nmatbot, nmatrow);
                        first = createNote(4, NTnotes(k), 44100, bpm, waveform);
                    end
                    allbot = horzcat(allbot, first);
                end   
            end
            holdNoteLH = false;

        elseif (prevnotebot - nownotebot == 5 || prevnotebot - nownotebot == 6)
            NTnotes(1) = prevnotebot;
            number = round(rand(1)*1) + 1;
            if (number == 1)
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j - 1);
                        NTnotes(3) = scale(j - 2);
                    end
                end

                for k = 1:3
                    NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                    if (k == 2 || k == 3)
                        nmatrow = produceRowBot(5, NTnotes(k), bpm);
                        nmatbot = vertcat(nmatbot, nmatrow);
                        first = createNote(5, NTnotes(k), 44100, bpm, waveform);
                    else
                        nmatrow = produceRowBot(4, NTnotes(k), bpm);
                        nmatbot = vertcat(nmatbot, nmatrow);
                        first = createNote(4, NTnotes(k), 44100, bpm, waveform);
                    end
                    allbot = horzcat(allbot, first);
                end
            elseif (number == 2)
                for j = 1:length(scale)
                    if (scale(j) == NTnotes(1))
                        NTnotes(2) = scale(j - 1);
                        NTnotes(3) = scale(j - 2);
                    end
                end

                for k = 1:3
                    NTnotes(k) = startnote * (2.^ (NTnotes(k) / 12));
                    if (k == 1 || k == 2)
                        nmatrow = produceRowBot(5, NTnotes(k), bpm);
                        nmatbot = vertcat(nmatbot, nmatrow);
                        first = createNote(5, NTnotes(k), 44100, bpm, waveform);
                    else
                        nmatrow = produceRowBot(4, NTnotes(k), bpm);
                        nmatbot = vertcat(nmatbot, nmatrow);
                        first = createNote(4, NTnotes(k), 44100, bpm, waveform);
                    end
                    allbot = horzcat(allbot, first);
                end
            end
            holdNoteLH = false;
       
        else
            prevnotebot = startnote * (2.^ (prevnotebot / 12));
            nmatrow = produceRowBot(3, prevnotebot, bpm);
            nmatbot = vertcat(nmatbot, nmatrow);
            first = createNote(3, prevnotebot, 44100, bpm, waveform);

            allbot = horzcat(allbot, first);    
            holdNoteLH = false;
        end
     else
        prevnotebot = startnote * (2.^ (prevnotebot / 12));
        nmatrow = produceRowBot(3, prevnotebot, bpm);
        nmatbot = vertcat(nmatbot, nmatrow);
        first = createNote(3, prevnotebot, 44100, bpm, waveform);

        allbot = horzcat(allbot, first);    
        holdNoteLH = false;
     end
     end

if (holdNoteLH)  
    beatsHeldLH = beatsHeldLH + 1;
end
if (beatsHeldLH == 2)
    holdNoteLH = false;
    beatsHeldLH = 0;
end

% changes nownotetop and bot into prevnotetop and bot.
% essentially prepares for next of new notes.
prevnotetop = nownotetop;
prevnotebot = nownotebot;
end