function retval = aggregate (altEval, weights)
  [numberOfDM temp] = size(weights); %number of rows equals to number of DM
  NuMinus = 0;
  NuPlus = 0;
  VMinus = 0;
  VPlus = 0;
  for i = 1:numberOfDM
  	NuMinus = NuMinus + altEval(i,1)*weights(i,1);
    NuPlus  = NuPlus  + altEval(i,2)*weights(i,2);
    VMinus  = VMinus + (1-altEval(i,3)-weights(i,3)+altEval(i,3)*weights(i,3));
    VPlus   = VPlus  + (1-altEval(i,4)-weights(i,4)+altEval(i,4)*weights(i,4));
  end
  NuMinus = NuMinus/sum(weights(:,1));
  NuPlus  = NuPlus/sum(weights(:,2));
  VMinus  = 1-(VMinus/(numberOfDM-sum(weights(:,3))));
  VPlus   = 1-(VPlus/(numberOfDM-sum(weights(:,4))));
  elements = [NuMinus NuPlus VMinus VPlus];
  retval = elements;
end
