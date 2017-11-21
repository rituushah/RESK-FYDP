
close all;
clear all; 

%1 - Shirley data from Nov. 20th 
%2 - Data for eliza flat knee flex and MVC 
%3 - Cometa data 
%4 - Kassy Data

%TESTING 

file = 1; 

if file == 1 
    load('Shirley_2017-11-20'); 
    MVC = C3_MVC; 
    C1_Raw = C3_Low; 
    fs = 2000; 
elseif file == 2
    load('2017-11-06')
    MVC = C1_Raw_MVC_Trial2; 
    C1_Raw = C1_Raw_2; 
    fs = 2000; 
elseif file == 3
    load('Cometa')
    C1_Raw_MVC_2 = MVC_Quad_C1;
    C1_Raw_2 = Squat_C1;
    fs = 4096; 
elseif file == 4
    load ('Kassy_2017-11-16')
    C1_Raw_MVC_2 = C1_K_MVC;
    C1_Raw_2 = C1_K_Trial; 
    fs = 2000; 
end 

%If flexvolt data then detrend  
if (file == 2 | file == 1) 
    C1_Raw_2 = detrend(C1_Raw); 
    C1_Raw_MVC_2 = detrend(MVC); 
end 

%Make Time vector to the length of MVC
Time_MVC = Time_Vector(fs,C1_Raw_MVC_2);
Time_Exercise = Time_Vector(fs,C1_Raw_2); 

%Gets rid of the random spikes in data 
C1_Raw_2 = medfilt1(C1_Raw_2,3); 
C1_Filtered = C1_Raw_2; 

%MVC random spike filtering 
C1_Raw_MVC_2 = medfilt1(C1_Raw_MVC_2,3); 
C1_Filtered_MVC = C1_Raw_MVC_2; 

%Butterworth filter 
Wnhigh = 500; 
Wnlow = 10; 
[b,a] = butter(5, [Wnlow Wnhigh]/(fs/2), 'bandpass');
C1_Filtered = filter(b,a, C1_Filtered);
C1_Filtered_MVC = filter(b,a, C1_Filtered_MVC); 

%Rectification 
C1_Filtered = abs(C1_Filtered); 
C1_Filtered_MVC = abs(C1_Filtered_MVC); 

%Plotting Rectified + Filtered signal 
figure;
plot(Time_Exercise, C1_Filtered)
legend('Filtered')
xlabel('Time(S)')
ylabel ('Signal')
title ('Filtered and Rectified Data')

%Liear envelope of EMG signal
C1_Envelope = C1_Filtered; 
[c,d] = butter(5, 0.7/(fs/2), 'low');
C1_Envelope = filter(c,d,C1_Envelope);
C1_MVC_Envelope = filter(c,d,C1_Filtered_MVC); 

%Plot signal 
% figure; 
% plot(Time_Exercise, C1_Envelope); 
% hold
% plot(Time_MVC, C1_MVC_Envelope); 
% legend('Exercise Envelope','MVC Envelope')
% xlabel('Time(S)')
% ylabel ('Signal')
% title ('Exercise vs. MVC')

%Find Max
Max = Find_MVC(C1_MVC_Envelope); 
C1_Mean = movingmean(C1_Envelope, 2000, 1, 1); 

%Plot the moving channel average versus the MVC envelope  
figure;
plot(Time_Exercise, C1_Mean); 
hold;
plot(Time_MVC, C1_MVC_Envelope); 
title ('Mean and MVC'); 
legend('Mean', 'MVC'); 
xlabel ('Time(S)'); 
ylabel ('Signal'); 

counter = 0; 
MVC_flag = 0.68*Max; 
Timer = false; 
T1 = false; 
T2 = false; 
Tlow = 0;
Thigh = 0; 
i = 1; 
l1 = length(C1_Mean); 
time_set = 10;  
correct = false;

while (i <= l1 & Timer == false)
    value = C1_Mean(i); 
    
    if (value >= MVC_flag & T1 == false)
        Tlow = Time_Exercise(i);
        T1 = true;
    end 
    
    if (value < MVC_flag & T1 == true && T2 == false)
        Thigh = Time_Exercise(i-1);
        T2 = true;
    end 
    
    difference = Thigh - Tlow;
    
    if (difference > time_set)
       disp('You r successful') 
       Timer = true;
       correct = true;
    elseif (T1 == true & T2 == true)
       counter = counter + 1; 
       Timer = true; 
       T1 = false;
       T2 = false; 
       disp('You failed') 
    end 
    
    i = i+1; 
end 
disp(correct) 



















