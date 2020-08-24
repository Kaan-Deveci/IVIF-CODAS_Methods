function retval = calculateDistanced_IVIF(Alternative, NIS)
  %Find the performance measure of alternatives wrt NIS as in Eq. (32)
  [a b] = size(NIS);
  metric = zeros(1,a);
  for j = 1:a
    metric(j) = ((NIS(j,3)-Alternative(j,3)) + (NIS(j,4)-Alternative(j,4)))+((Alternative(j,1)-NIS(j,1)) + (Alternative(j,2)-NIS(j,2)))*(1+((Alternative(j,1)+Alternative(j,2)/2)/sqrt(((Alternative(j,1)+Alternative(j,2)/2))^2+((Alternative(j,3)+Alternative(j,4)/2))^2)));
  end
  retval = [sum(metric) metric];
end
