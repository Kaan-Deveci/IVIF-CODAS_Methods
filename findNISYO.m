function NIS = findNISYO (matrix)
%Calculate NIS  using Eq. (18)
  [a b] = size(matrix);
  for alter = 1:b/4
    sol(alter,:) = matrix((alter-1)*4+1:(alter-1)*4+4);
  end
  NIS = [min(sol(:,1)) min(sol(:,2)) max(sol(:,3)) max(sol(:,4))];
end
