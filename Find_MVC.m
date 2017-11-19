function [Max] = Find_MVC(C1_MVC_Envelope)
    MVC_mean = movingmean(C1_MVC_Envelope, 3000, 1, 1);
    Max = max(MVC_mean);  
end

