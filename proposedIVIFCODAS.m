%Proposed IVIF-CODAS Method
%Alternative order in input list: 1Biomass 2Hydroelectric 3Geothermal 4Wind 5Solar
clear
numberOfAlternatives = 5; %define number of alternatives 
numberOfDM = 3;           %define number of decision-makers
numberOfCriterion = 17;   %define number of criterion
costCriteria = [2 4 5 8 9 10 15]; %define the cost criteria for normalization purposes

%% Linguistic labels
CL=[0.1 0.25 0.65 0.75];
VL=[0.15 0.3 0.6 0.7];
L=[0.2 0.35 0.55 0.65];
BM=[0.25 0.4 0.5 0.6];
EE=[0.5 0.5 0.5 0.5];
AM=[0.5 0.6 0.25 0.4];
H=[0.55 0.65 0.2 0.35];
VH=[0.6 0.7 0.15 0.3];
CH=[0.65 0.75 0.1 0.25];

%% DM evaluations of alternatives (criteria x (DM x Alternatives))
matrix =   [EE	H	H	H	H	H	H	H	CH	CH	VL	CH	EE	H	AM
            L	BM	CL	L	L	VL	L	L	BM	VL	VL	VH	VL	L	VL
            CH	CH	CH	CH	CH	H	VH	VH	H	VH	EE	VH	EE	VL	L
            CL	BM	VL	BM	BM	BM	BM	BM	VL	VL	L	H	BM	CH	CH
            CL	H	EE	CL	CL	BM	EE	EE	CL	CL	EE	VH	EE	VL	BM
            H	EE	CH	L	EE	VH	H	VH	H	VH	EE	VH	AM	L	VL
            H	H	EE	EE	EE	AM	VH	H	VH	VH	AM	CH	H	AM	L
            VH	EE	CL	CL	CL	L	L	L	CL	CL	VH	BM	AM	VL	VL
            L	AM	EE	VH	AM	H	CH	H	AM	H	BM	CH	H	BM	VH
            VH	CL	CH	CL	CL	L	VL	L	CL	CL	CH	H	EE	VL	VL
            VH	VH	VH	VH	VH	H	H	H	CH	CH	VL	VH	VL	VH	AM
            EE	VH	VH	VH	VH	H	H	H	CH	CH	VL	VH	L	VH	VH
            VH	VH	VH	H	VH	H	AM	H	H	VH	VH	BM	H	VH	CH
            EE	AM	AM	VL	VL	AM	H	AM	AM	AM	VH	CH	H	VL	VL
            VL	CH	CH	VH	H	AM	AM	AM	H	VH	L	VH	H	AM	VH
            L	L	L	L	L	AM	AM	AM	H	H	H	CL	VL	H	CH
            VH	H	H	VH	VH	H	CH	H	CH	VH	VH	VH	H	AM	BM];

%% Self evaluated DM weights
selfEvaluatedWeights =     [0.9	0.8	0.9
                            0.9	0.8	0.9
                            0.9	0.8	0.9
                            0.9	0.8	0.9
                            0.9	0.8	0.9
                            0.9	0.8	0.9
                            0.9	0.8	0.9
                            0.8	0.8	0.7
                            0.8	0.8	0.7
                            0.8	0.8	0.7
                            0.6	0.6	0.6
                            0.6	0.6	0.6
                            0.6	0.6	0.6
                            0.6	0.6	0.6
                            0.9	0.8	0.4
                            0.9	0.8	0.4
                            0.9	0.8	0.4];

%% Criteria weights
criteriaWeights =  [CH	CH	H
                    CH	VH	H
                    CH	CH	CH
                    VH	H	H
                    VH	H	H
                    H	VH	CH
                    L	H	AM
                    CH	VH	VH
                    VH	CH	CH
                    VH	H	H
                    VL	VH	VH
                    VL	H	CH
                    L	CH	CH
                    L	VH	H
                    CH	H	VH
                    H	H	VH
                    CH	CH	CH];

%% STEP 2: Calculate aggregated IVIF decision matrix
for i = 1:numberOfCriterion
  for j = 1:numberOfAlternatives
    vector = j:numberOfAlternatives:numberOfDM*numberOfAlternatives;
    revisedVector = [];
    for kk = 1:length(vector)
      temp = (vector(kk)-1)*4+1:(vector(kk)*4);
      revisedVector = [revisedVector temp];
      clear temp
    end
      revVector = matrix(i,[revisedVector]);
      altEval = reshape(revVector,4,numberOfDM);
      aggregatedScores(:,i,j) = aggregateR(altEval', selfEvaluatedWeights(i,:)'); 
      clear revisedVector 
  end
end
dummy = [];
for z = 1:numberOfCriterion
  for k = 1:numberOfAlternatives
    dummy = [dummy aggregatedScores(:,z,k)'];
  end
  saveDummy(z,:) = dummy;
  dummy = [];
end
%saveDummy: Aggregated IVIF decision matrix.
AIVIFDM = saveDummy;
save 2aggregatedScores.txt saveDummy -ascii

%% STEP 3 Calculate aggregated weight matrix
for s = 1:numberOfCriterion
  weight = selfEvaluatedWeights(s,:);
  criteriaWeight = criteriaWeights(s,:);
  %weightR = reshape(weight,4,numberOfDM);
  criteriaWeightR= reshape(criteriaWeight,4,numberOfDM);
  aggregatedWeights(s,:) = aggregateR(criteriaWeightR', selfEvaluatedWeights(s,:)'); 
end
save 3aggregatedWeights.txt aggregatedWeights -ascii

%% Step 4: Normalize aggregated IVIF decision matrix
for cc = 1:length(costCriteria)
    for rr = 1:numberOfAlternatives
        saveDummy(costCriteria(cc),(rr-1)*4+1:rr*4) = [saveDummy(costCriteria(cc),(rr-1)*4+3) saveDummy(costCriteria(cc),(rr-1)*4+4) saveDummy(costCriteria(cc),(rr-1)*4+1) saveDummy(costCriteria(cc),(rr-1)*4+2)];
    end
end
NAIVIFDM=saveDummy;
save 4NAIVIFDM.txt NAIVIFDM -ascii

%% Step 5: Weighted Normalized IVIF DM
for c = 1:numberOfCriterion
  for a = 1:numberOfAlternatives
    weightedNormalizedIVIF(c,(a-1)*4+1:(a-1)*4+4) = IVIFCross(aggregatedWeights(c,:),NAIVIFDM(c,(a-1)*4+1:(a-1)*4+4));
  end
end
save 5WNIVIFDM.txt weightedNormalizedIVIF -ascii

%% Step 6: Determination of NISs.
for k = 1:numberOfCriterion
  NIS(k,:) = findNIS (weightedNormalizedIVIF(k,:));
 end
 save 6NIS.txt NIS -ascii
%% Step 7: Calculate performanse measure(d_IVIF)and RA: 
 for l = 1:numberOfAlternatives
   distance(l,:) = calculateDistanced_IVIF(weightedNormalizedIVIF(:,(l-1)*4+1:(l-1)*4+4), NIS);
 end

%% Step 8: Rank the alternatives
assesment = distance(:,1)';
[sd,r]=sort(assesment,'descend');
fprintf("Ranking order of\nBiomass Hydroelectric Geothermal Wind Solar");
r
