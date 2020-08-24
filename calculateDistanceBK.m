function retval = calculateDistanceBK (Alternative, NIS)
%Find the performance measure of alternatives wrt NIS as in Eq. (19-22)
  sumED = 0;
  sumHD = 0;
  [a b] = size(NIS);
  for j = 1:a
      sumED = sumED + (Alternative(j,1)-NIS(j,1))^2 + (Alternative(j,2)-NIS(j,2))^2 + (Alternative(j,3)-NIS(j,3))^2 + (Alternative(j,4)-NIS(j,4))^2;
      sumHD = sumHD + abs(Alternative(j,1)-NIS(j,1)) + abs(Alternative(j,2)-NIS(j,2)) + abs(Alternative(j,3)-NIS(j,3)) + abs(Alternative(j,4)-NIS(j,4));
  end
  ED = sqrt(1/2*sumED);
  HD = 1/4*(sumHD);
  retval = [ED HD];
end
