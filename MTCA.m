%% notes
%find a method to initialize MT properly. If they are next to each other
%they should be parallely alligned.

%%Inputs
l = 100; %Length of lattice
p = 0.1; %Probability of finding a MT (related to density)
c = 0.1; %Crosslinker concentration

%%Initialization
parlat = zeros(1,l); %zero lattice of length l
ini = uint16(l/4); %first site for MT
fin = uint16(3*l/4); %end site for MT
for i = ini:fin
    chk1 = rand(); %chk for random number to populate lattice
    if chk1 < p %chk if its a possible location for particle
        if parlat(i-1) ~= 1
            chk2 = rand(); %chk for deciding direction
            if chk2 <= 0.5
                parlat(i) = -1;
            else
                parlat(i) = 1;
            end
        elseif parlat(i-1) == 1;
            parlat(i) = 1;
        end
    end
end

%% Dyanmics
