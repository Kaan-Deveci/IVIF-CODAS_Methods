function retval = aggregateR (altEval, weights)
  %Aggregate using IIFA in Eq. (30)
  NuMinus = sum(altEval(:,1).*weights)/sum(weights);
  NuPlus  = sum(altEval(:,2).*weights)/sum(weights);
  VMinus  = sum(altEval(:,3).*weights)/sum(weights);
  VPlus   = sum(altEval(:,4).*weights)/sum(weights);
  elements = [NuMinus NuPlus VMinus VPlus];
  retval = elements;
end
