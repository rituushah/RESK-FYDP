function [Time] = Time_Vector(fs,MVC)
    LMVC = length(MVC);
    x = 1/fs; 
    length2 = x*LMVC; 
    Time = (x:x:length2); 
    Time = Time.'; 

end

