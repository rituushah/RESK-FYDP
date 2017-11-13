function [C1_Raw] = Length_Cut(C1_Raw, MVC)
%Cuts Raw Vector if not same legnth      
    length1 = length(C1_Raw);
    length2 = length(MVC);
    Difference = length1 - length2;
    number = length1 - Difference; 
    C1_Raw = C1_Raw(1:number,:);
end

