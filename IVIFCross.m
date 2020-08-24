function retval = IVIFCross (weight, value)
% Perform IVIF cross product using Eq. (3)
  production(:,1) = weight(:,1).*value(:,1);
  production(:,2) = weight(:,2).*value(:,2);
  production(:,3) = weight(:,3)+value(:,3)-weight(:,3).*value(:,3);
  production(:,4) = weight(:,4)+value(:,4)-weight(:,4).*value(:,4);
  retval = production;
end