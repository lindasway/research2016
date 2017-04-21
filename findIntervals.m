function findIntervals()

% this function looks for the most proper choice of the next 
% two notes based on the analysis of the previous top and bottom

global chordArray;
global nownotetop;
global nownotebot;
global prevnotetop;
global prevnotebot;
global containsSeventhRH;
global containsSeventhLH;

noFifths = zeros(1, 2);
noFourths = zeros(1, 2);
noOctaves = zeros(1, 2);
state = true;
o = 0;

% the variable o is used to give the program a higher possibility
% of having contrary motion
if (o < 3)
    % looks for and puts into an array of notes that do not
    % have fifth but are still in the chord.
    % this is used to avoid parallel fifths (if the last interval
    % was a fifth.
    if (prevnotetop - prevnotebot == 7)
        if (o == 0)
            for k = 1:length(chordArray)
                for l = 1:length(chordArray)
                    if (chordArray(k) - chordArray(l) ~= 7)
                        A = [chordArray(k) chordArray(l);];
                        noFifths = vertcat(A, noFifths);
                    elseif (chordArray(l) - chordArray(k) ~= 7)
                        B = [chordArray(l) chordArray(k);];
                        noFifths = vertcat(B, noFifths);
                    end
                end
            end
        end
        noFifths = noFifths(randperm(length(noFifths)),:);
        topNum = noFifths(1, 1);
        botNum = noFifths(1, 2);
        % switches notes and orients them to the top and bottom
        % hands.
        if (botNum > topNum)
            t = topNum;
            topNum = botNum;
            botNum = t;
        end
        topSub = abs(topNum - prevnotetop);
        botSub = abs(botNum - prevnotebot);
        sumNums = botSub + topSub;
        nownotetop = topNum;
        nownotebot = botNum;
        smallestNum = sumNums;
        % looks for the closest note to the previous
	   % while maintaining some variety, as I did 
        % by cutting the array it is looking thorugh 
        % by a half.
        for i = 2:length(noFifths) / 2
            topNum = noFifths(i, 1);
            botNum = noFifths(i, 2);
            if (botNum > topNum)
                t = topNum;
                topNum = botNum;
                botNum = t;
            end
            topSub = abs(topNum - prevnotetop);
            botSub = abs(botNum - prevnotebot);
            sumNums = botSub + topSub;
            if (sumNums < smallestNum)
                smallestNum = sumNums;
                nownotetop = topNum;
                nownotebot = botNum;
            end
        end
    elseif (prevnotetop - prevnotebot == 5)
        % does the same as what it did for the parallel 5th\
        % this one is to avoid parallel fourths
        if (o == 0)
            for k = 1:length(chordArray)
                for l = 1:length(chordArray)
                    if (chordArray(k) - chordArray(l) ~= 5)
                        A = [chordArray(k) chordArray(l);];
                        noFourths = vertcat(A, noFourths);
                    elseif (chordArray(l) - chordArray(k) ~= 5)
                        B = [chordArray(l) chordArray(k);];
                        noFourths = vertcat(B, noFourths);
                    end
                end
            end
        end
        noFourths = noFourths(randperm(length(noFourths)),:);
        topNum = noFourths(1, 1);
        botNum = noFourths(1, 2);
        if (botNum > topNum)
            t = topNum;
            topNum = botNum;
            botNum = t;
        end
        topSub = abs(topNum - prevnotetop);
        botSub = abs(botNum - prevnotebot);
        sumNums = botSub + topSub;
        nownotetop = topNum;
        nownotebot = botNum;
        smallestNum = sumNums;
        for i = 2:length(noFourths) / 2
            topNum = noFourths(i, 1);
            botNum = noFourths(i, 2);
            if (botNum > topNum)
                t = topNum;
                topNum = botNum;
                botNum = t;
            end
            topSub = abs(topNum - prevnotetop);
            botSub = abs(botNum - prevnotebot);
            sumNums = botSub + topSub;
            if (sumNums < smallestNum)
                smallestNum = sumNums;
                nownotetop = topNum;
                nownotebot = botNum;
            end
        end
    elseif (prevnotetop - prevnotebot == 12)
	  % written to avoid parallel octaves
        if (o == 0)
            for k = 1:length(chordArray)
                for l = 1:length(chordArray)
                    if (abs(chordArray(k) - chordArray(l)) ~= 12)
                        A = [chordArray(k) chordArray(l);];
                        noOctaves = vertcat(A, noOctaves);
                    end
                end
            end
        end
        noOctaves = noOctaves(randperm(length(noOctaves)),:);
        topNum = noOctaves(1, 1);
        botNum = noOctaves(1, 2);
        if (botNum > topNum)
            t = topNum;
            topNum = botNum;
            botNum = t;
        end
        topSub = abs(topNum - prevnotetop);
        botSub = abs(botNum - prevnotebot);
        sumNums = botSub + topSub;
        nownotetop = topNum;
        nownotebot = botNum;
        smallestNum = sumNums;
        for i = 2:length(noOctaves) / 2
            topNum = noOctaves(i, 1);
            botNum = noOctaves(i, 2);
            if (botNum > topNum)
                t = topNum;
                topNum = botNum;
                botNum = t;
            end
            topSub = abs(topNum - prevnotetop);
            botSub = abs(botNum - prevnotebot);
            sumNums = botSub + topSub;
            if (sumNums < smallestNum)
                smallestNum = sumNums;
                nownotetop = topNum;
                nownotebot = botNum;
            end
        end      
    elseif (prevnotetop - prevnotebot == 0)
        % written to avoid both hands playing the same note.
        if (o == 0)
            for k = 1:length(chordArray)
                for l = 1:length(chordArray)
                    if (chordArray(k) - chordArray(l) ~= 0)
                        A = [chordArray(k) chordArray(l);];
                        noFourths = vertcat(A, noFourths);
                    elseif (chordArray(l) - chordArray(k) ~= 0)
                        B = [chordArray(l) chordArray(k);];
                        noFourths = vertcat(B, noFourths);
                    end
                end
            end
        end
        noFourths = noFourths(randperm(length(noFourths)),:);
        topNum = noFourths(1, 1);
        botNum = noFourths(1, 2);
        if (botNum > topNum)
            t = topNum;
            topNum = botNum;
            botNum = t;
        end
        topSub = abs(topNum - prevnotetop);
        botSub = abs(botNum - prevnotebot);
        sumNums = botSub + topSub;
        nownotetop = topNum;
        nownotebot = botNum;
        smallestNum = sumNums;
        for i = 2:length(noFourths) / 2
            topNum = noFourths(i, 1);
            botNum = noFourths(i, 2);
            if (botNum > topNum)
                t = topNum;
                topNum = botNum;
                botNum = t;
            end
            topSub = abs(topNum - prevnotetop);
            botSub = abs(botNum - prevnotebot);
            sumNums = botSub + topSub;
            if (sumNums < smallestNum)
                smallestNum = sumNums;
                nownotetop = topNum;
                nownotebot = botNum;
            end
        end   
    else
	  % if none of the taboo situations exist, then it 
        % will go here and look for a relatively close note 
        % to choose for the next pair.
        topNum = chordArray(1);
        botNum = chordArray(1);
        if (botNum > topNum)
            t = topNum;
            topNum = botNum;
            botNum = t;
        end
        topSub = abs(topNum - prevnotetop);
        botSub = abs(botNum - prevnotebot);
        sumNums = botSub + topSub;
        nownotetop = topNum;
        nownotebot = botNum;
        smallestNum = sumNums;
        for i = 2:length(chordArray) / 1.5
            topNum = chordArray(i);
            for p = 2:length(chordArray) / 1.5
                botNum = chordArray(p);
                if (botNum > topNum)
                    t = topNum;
                    topNum = botNum;
                    botNum = t;
                end
                topSub = abs(topNum - prevnotetop);
                botSub = abs(botNum - prevnotebot);
                sumNums = botSub + topSub;
                if (sumNums < smallestNum)
                    smallestNum = sumNums;
                    nownotetop = topNum;
                    nownotebot = botNum;
                end
            end
        end
    end
        
    if ((nownotebot - prevnotebot < 0) && (nownotetop - prevnotetop < 0)) % both notes are going in a downward motion
        o = o + 1;
    elseif ((nownotebot - prevnotebot > 0) && (nownotetop - prevnotetop > 0)) % both notes are going in a upward motion
        o = o + 1;
    else                                                            % both notes are going in opposite directions (contrary motion)
        o = 3;
    end
end
% this section is only for when there is a 7th in the notes 
% aka leading tone that has to  resolve up half a step
% into the root key. It essentially looks through both
% the left and right hands for the notes and intervals
% that it would best go to.
if (containsSeventhRH)
    smallest = chordArray(1);
    for i = 0:3
    compare = abs(prevnotetop - chordArray(1 + 3*i));
        if (compare < smallest)
            smallest = compare;
            nownotetop = chordArray(1+3*i);
        end
        end
    smallest = chordArray(3);
    for i = 0:3
        compare = abs(prevnotebot - chordArray(3 + 3*i));
        if (compare < smallest)
            smallest = compare;
            nownotebot = chordArray(3 + 3*i);
        end
    end
end
if (containsSeventhLH)
    smallest = chordArray(1);
    for i = 0:3
        compare = abs(prevnotebot - chordArray(1 + 3*i));
        if (compare < smallest)
            smallest = compare;
            nownotebot = chordArray(1+3*i);
        end
    end
    smallest = chordArray(3);
    for i = 0:3
        compare = abs(prevnotetop - chordArray(3 + 3*i));
        if (compare < smallest)
            smallest = compare;
            nownotetop = chordArray(3 + 3*i);
        end
    end
end
end
