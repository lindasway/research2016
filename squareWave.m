function y = squareWave( baseF, numComponents, amp, numSecs, sampRate )
%This function produces a square wave, which is composed of the integer
%multiples of the wave's fundamental frequency.
%Arguments:
    %squareWave(Base Frequency, # of Components, Amplitude, # of Seconds,
    %Sampling Rate);
%Sample function call from command line:
    %y =  squareWave(440, 20, 0.9, 2, 44100);
    
numSamps = numSecs * sampRate;
t = linspace(0, numSecs, numSamps);
y = zeros(1, numSamps);
for i = 1:numComponents
    y = y + amp * sin(2*pi*baseF*(2*i-1)*t)/(2*i-1);
end
y = amp * y;

%The for loop could be replace by a nested for
%loop as follows.  However, evaluating the sine function with one
%array operation is more efficient
% for i = 1:numComponents
%     for j = 1:numSamps
%         y(j) = y(j) + amp* sin(2*pi*baseF*(2*i-1)*t(j))/(2*i-1);
%     end
% end

%comment or uncomment the statements below depending on whether
%you want to see a graph of the sound wave
%figure;
%plot(t, y);
%axis([0 0.1, -1.5 1.5]);

%comment or uncomment the statements below depending on whether
%you want to hear the sound
sound(y, sampRate);
