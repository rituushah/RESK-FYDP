close all;
clear all; 

%1 - Data from flexvolt collected with shirley (3 pulses, no MVC)
%2 - Data for eliza flat knee flex and MVC 
%3 - Cometa data 

%TESTING 

file = 3; 

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

%Make Time vector to the length of MVC
Time = Time_Vector(fs,MVC);

%Re-assign variable names 
C1_Raw_2 = C1_Raw; 
C1_Raw_MVC_2 = MVC; 

%If flexvolt data, cutting them to be same legnth and detrending 
if file == 2
    C1_Raw_2 = Length_Cut(C1_Raw, MVC); 
    C1_Raw_2 = detrend(C1_Raw_2); 
    C1_Raw_MVC_2 = detrend(C1_Raw_MVC_2); 
end 

%Gets rid of the random spikes in data 
C1_Raw_2 = medfilt1(C1_Raw_2,3); 
C1_Filtered = C1_Raw_2; 

%MVC random spike filtering 
C1_Raw_MVC_2 = medfilt1(C1_Raw_MVC_2,3); 
C1_Filtered_MVC = C1_Raw_MVC_2; 

%Butterworth filter 
Wnhigh = 400; 
Wnlow = 20; 
[b,a] = butter(5, [Wnlow Wnhigh]/(fs/2), 'bandpass');
C1_Filtered = filter(b,a, C1_Filtered);
C1_Filtered_MVC = filtfilt(b,a, C1_Filtered_MVC); 

%Rectification 
C1_Filtered = abs(C1_Filtered); 
C1_Filtered_MVC = abs(C1_Filtered_MVC); 

%Plotting Rectified + Filtered signal 
figure;
plot(Time, C1_Filtered)
legend('Filtered')
xlabel('Time(S)')
ylabel ('Signal')
title ('Filtered and Rectified Data')

%Liear envelope of EMG signal
C1_Envelope = C1_Filtered; 
[c,d] = butter(5, 1/(fs/2), 'low');
C1_Envelope = filter(c,d,C1_Envelope);
C1_MVC_Envelope = filtfilt(c,d,C1_Filtered_MVC); 

%Plot signal envelope
figure; 
plot(Time, C1_Envelope); 
hold
plot(Time, C1_MVC_Envelope); 
legend('Exercise Envelope','MVC Envelope')
xlabel('Time(S)')
ylabel ('Signal')
title ('Exercise vs. MVC')



