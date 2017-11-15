close all;
clear all; 

%1 - Data from flexvolt collected with shirley (3 pulses, no MVC)
%2 - Data for eliza flat knee flex and MVC 
%3 - Cometa data 

%TESTING 

file = 2; 

if file == 1 
    load('2017-10-26'); 
elseif file == 2
    load('2017-11-06')
    MVC = C1_Raw_MVC_Trial2; 
    fs = 2000; 
elseif file == 3
    load('Cometa')
    C1_Raw_MVC_2 = MVC_Quad_C1;
    C1_Raw_2 = Squat_C1;
    fs = 4096; 
end 

%If flexvolt data, cutting them to be same legnth and detrending 
if file == 2
    C1_Raw_2 = Length_Cut(C1_Raw, MVC); 
    C1_Raw_2 = detrend(C1_Raw_2); 
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
Wnhigh = 400; 
Wnlow = 20; 
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
[c,d] = butter(5, 1/(fs/2), 'low');
C1_Envelope = filter(c,d,C1_Envelope);
C1_MVC_Envelope = filter(c,d,C1_Filtered_MVC); 

%Plot signal envelope
figure; 
plot(Time_Exercise, C1_Envelope); 
hold
plot(Time_MVC, C1_MVC_Envelope); 
legend('Exercise Envelope','MVC Envelope')
xlabel('Time(S)')
ylabel ('Signal')
title ('Exercise vs. MVC')

%Find Max
Max = Find_MVC(C1_MVC_Envelope) 

MVC_flag = 8; 
Timer = false; 
T1 = false; 
T2 = false; 
Tlow = 0;
Thigh = 0; 
TlastHigh = nan;
i = 1; 
l1 = length(C1_Envelope); 

while (i <= l1 & Timer == false)
    value = C1_Envelope(i); 
    
    if (value >= MVC_flag & T1 == false)
        Tlow = Time_Exercise(i);
        T1 = true;
    end 
    
    if (value < MVC_flag & T1 == true && T2 == false) 
        % if less than MVC
        %if TlastHigh is null that means we are not in the middle of a
        %dip, so we set the current time to tlasthigh.
        if(isnan(TlastHigh))
            TlastHigh = Time_Exercise(i-1);
        end
        %If lower than MVC for over 1.5 seconds, it counts as a fail
        if(Time_Exercise(i) - TlastHigh >= 5)
            Thigh = TlastHigh;
            T2 = true; 
            TlastHigh = nan;
        end
%         Thigh = Time_Exercise(i);
%         T2 = true;
    end 
    
    difference = Thigh - Tlow;
    
    if (difference > 10)
       disp('test') 
       Timer = true; 
    end 
    
    i = i+1; 
end 





























