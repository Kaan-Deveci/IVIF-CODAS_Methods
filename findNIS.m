function NIS = findNIS (matrix)
  %Calculate NIS using Eq. (37-38)
  [a b] = size(matrix);
  for alter = 1:b/4
    sol = matrix((alter-1)*4+1:(alter-1)*4+4);
    Dsol(alter)= (sol(1)+sol(2)+(1-sol(3))+(1-sol(4))+sol(1)*sol(2)-sqrt((1-sol(3))*(1-sol(4))))/4;
  end
  DsolMin = find(Dsol==min(Dsol));
  NIS = matrix((DsolMin-1)*4+1:(DsolMin-1)*4+4);
end
