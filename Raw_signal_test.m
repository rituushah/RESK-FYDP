close all;
clear all; 

%1 - Data from flexvolt collected with shirley (3 pulses, no MVC)
%2 - Data for eliza flat knee flex and MVC 
%3 - Cometa data 

file = 2; 

if file == 1 
    load('2017-10-26'); 
elseif file == 2
    load('2017-11-06')
    MVC = C1_Raw_MVC_Trial2; 
    fs = 2000; 
elseif file == 3
    load('Cometa')
    MVC = MVC_Quad_C1;
    C1_Raw = Squat_C1;
    fs = 4096; 
end 

%Makes the two vectors same legnth by deleting the end of Raw vector 
% length1 = length(C1_Raw);
% length2 = length(MVC);
% Difference = length1 - length2;
% number = length1 - Difference; 
% C1_Raw = C1_Raw(1:number,:);

%Make Time vector
LMVC = length(MVC);
x = 1/fs; 
length = x*LMVC; 
Time = (x:x:length); 
Time = Time.'; 

%Re-assign variable names 
C1_Raw_2 = C1_Raw; 
C1_Raw_MVC_2 = MVC; 

%Detrend the signal to get rid of DC offset 
% C1_Raw_2 = detrend(C1_Raw_2); 
% C1_Raw_MVC_2 = detrend(C1_Raw_MVC_2); 

%Gets rid of the random spikes in data 
C1_Raw_2 = medfilt1(C1_Raw_2,3); 
C1_Filtered = C1_Raw_2; 

%MVC random spike filtering 
C1_Raw_MVC_2 = medfilt1(C1_Raw_MVC_2,3); 
C1_Filtered_MVC_2 = C1_Raw_MVC_2; 

%Butterworth filter 
Wnhigh = 400; 
Wnlow = 20; 
[b,a] = butter(2, [Wnlow Wnhigh]/(fs/2), 'bandpass');
C1_Filtered = filtfilt(b,a, C1_Filtered); 
C1_Filtered_MVC_2 = filtfilt(b,a, C1_Filtered_MVC_2); 

% plot(Time, C1_Raw_2)
% hold
% plot(Time, C1_Filtered)
% legend('Raw','Filtered')
% xlabel('Time(S)')
% ylabel ('Signal')
% title ('Filtered Data')

%Rectification 
C1_Filtered = abs(C1_Filtered); 
C1_Filtered_MVC_2 = abs(C1_Filtered_MVC_2); 

%Plotting signals
figure;
plot(Time, C1_Filtered)
legend('Filtered')
xlabel('Time(S)')
ylabel ('Signal')
title ('Rectified Data')

%Liear envelope of EMG signal
C1_Envelope = C1_Filtered; 
[c,d] = butter(5, 3/(fs/2), 'low');
C1_Envelope = filtfilt(c,d,C1_Envelope); 

C1_MVC_Envelope = filtfilt(c,d,C1_Filtered_MVC_2); 





%Plots 
figure
plot(Time, C1_Envelope)
legend('Envelope')
xlabel('Time(S)')
ylabel ('Signal')
title ('Signal Envelope')

figure; 
plot(Time, C1_Envelope); 
hold
plot(Time, C1_MVC_Envelope); 
legend('Exercise Envelope','MVC Envelope')
xlabel('Time(S)')
ylabel ('Signal')
title ('Exercise vs. MVC')



