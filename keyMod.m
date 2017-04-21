function keyMod(isminor, key)

% modulates key and changes to either minor or major.

global scale;

% contains the intervals for minor and major scale of 4 octaves
if (isminor == 0)
    scale = [-12 -10 -8 -7 -5 -3 -1 0 2 4 5 7 9 11 12 14 16 17 19 21 23 24 26 28 29 31 33 35 36];    
   %scale = [1   2   3  4  5  6  7  8 9 1011121314 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29];
else
    scale = [-12 -10 -9 -7 -5 -4 -1 0 2 3 5 7 8 11 12 14 15 17 19 20 23 24 26 27 29 31 32 35 36]; 
   %scale = [1   2   3  4  5  6  7  8 9 1011121314 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29];
end

if (key == 'D')
    scale = scale + 2;
elseif (key == 'E' )
    scale = scale + 4;
elseif (key == 'F')
    scale = scale + 5;
%{
elseif (STRCMP(key, 'F#') == 1 || STRCMP(key, 'Gb') == 1)
    randNum = round(rand() * 1);
    if (randNum == 0)
    	scale = scale + 6;
    elseif (randNum == 1)
        scale = scale - 6;
    end
    %}
elseif (key == 'G')
    scale = scale - 5;
elseif (key == 'A')
    scale = scale - 3;
elseif (key == 'B')
    scale = scale - 1;
end