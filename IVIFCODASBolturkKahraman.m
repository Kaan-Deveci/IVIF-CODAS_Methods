%IVIF-CODAS Method suggested by Bolturk and Kahraman [1]
%[1] E. Bolturk, C. Kahraman, Interval-valued intuitionistic fuzzy CODAS method and its application to wave energy facility location selection problem, J. Intell. Fuzzy Syst. 35 (2018) 4865–4877. https://doi.org/10.3233/JIFS-18979.
%Alternative order in input list: 1Biomass 2Hydroelectric 3Geothermal 4Wind 5Solar
clear
%Input parameters
theta = 0.02;
numberOfAlternatives = 5;
numberOfDM = 3;
numberOfCriterion = 17; % There is no cost /benefit difference in this method

% Linguistic scale
CL=[0.1 0.25 0.65 0.75];
VL=[0.15 0.3 0.6 0.7];
L=[0.2 0.35 0.55 0.65];
BM=[0.25 0.4 0.5 0.6];
EE=[0.5 0.5 0.5 0.5];
AM=[0.5 0.6 0.25 0.4];
H=[0.55 0.65 0.2 0.35];
VH=[0.6 0.7 0.15 0.3];
CH=[0.65 0.75 0.1 0.25];

% DM Evaluations of alternatives
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

% Self evaluated DM weights
weights =  [0.9	0.8	0.9
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
        
% Criteria weights
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


%% Step 1: Aggregate DM evaluation of each alternative considering their self-evaluated weights
% For a fair comparison of each method, same aggregation operator is used
% with self evaluated DM weight matrix.
% This step was "step 2" in the proposed IVIF CODAS method.
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
      aggregatedScores(:,i,j) = aggregateR(altEval', weights(i,:)'); 
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
AIVIFDM = saveDummy; %Aggregated IVIF decision matrix

%% STEP 2 aggregate IVIF weights  
for s = 1:numberOfCriterion
  weight = weights(s,:);
  criteriaWeight = criteriaWeights(s,:);
  criteriaWeightR= reshape(criteriaWeight,4,numberOfDM);
  aggregatedWeights(s,:) = aggregateR(criteriaWeightR', weights(s,:)'); 
end

%% Step 3: Normalize the aggregated IVIF decision matrix according to Eq. (11-12)
for jj = 1:numberOfCriterion
  indexNU = [1:4:numberOfAlternatives*4 2:4:numberOfAlternatives*4];
  sortedNU= sort(indexNU);
  indexV  = [3:4:numberOfAlternatives*4 4:4:numberOfAlternatives*4];
  sortedV = sort(indexV); 
  maxNU(jj) = max(saveDummy(jj,sortedNU));
  maxV(jj)  = max(saveDummy(jj,sortedV));
end
for jjj = 1:numberOfCriterion
  NUmembers(jjj,:) = saveDummy(jjj,sortedNU)./maxNU(jjj);
  Vmembers(jjj,:)  = saveDummy(jjj,sortedV)./maxV(jjj);
end
VIVIFD =[];
for alts = 1:numberOfAlternatives
  VIVIFD = [VIVIFD NUmembers(:, 2*(alts-1)+1:2*(alts-1)+2) Vmembers(:,2*(alts-1)+1:2*(alts-1)+2)];
end
%VIVIFD: Normalized aggregated IVIF Decision matrix
for N = 1:numberOfCriterion
  for NN=1:numberOfAlternatives
    toplam = sum(VIVIFD(N,[(NN-1)*4+2 (NN-1)*4+4]));
    VIVIFD(N,(NN-1)*4+1:4*NN) = VIVIFD(N,[(NN-1)*4+1:4*NN])./toplam;
  end   
end 


%% Step 4: Calculate weighted normalized IVIF decision matrix using Eq.(14)
for c = 1:numberOfCriterion %bizim makalede step 4
  for a = 1:numberOfAlternatives
    weightedNormalizedIVIF(c,(a-1)*4+1:(a-1)*4+4) = IVIFCross(aggregatedWeights(c,:),VIVIFD(c,(a-1)*4+1:(a-1)*4+4));
  end
end


%% Step 5: Determine the fuzzy negative ideal solutions using Eq. (16-17)
for k = 1:numberOfCriterion  %step 5
  NIS(k,:) = findNIS(weightedNormalizedIVIF(k,:));
 end
 
 %% Step 6 Calculate Euclidean and Taxicab Distance using Eq. (21-22)
 for l = 1:numberOfAlternatives
   distance(l,:) = calculateDistanceBK(weightedNormalizedIVIF(:,(l-1)*4+1:(l-1)*4+4), NIS);
 end

 %% Step 7 and Step 8 Calculate relative assesment matrix and assesment scores.
 %Threshold parameter theta is defined at the begining of this code
 %Last step, relative assesment summation included
 for u = 1:numberOfAlternatives
   relativeAssesment = 0;
   for y = 1:numberOfAlternatives
     if y ~= u
        if abs(distance(u,1)-distance(y,1))<theta
            tho = 0;
        else
            tho = 1;
        end
        relativeAssesment = relativeAssesment + (distance(u,1)-distance(y,1)) + tho*(distance(u,1)-distance(y,1))*(distance(u,2)-distance(y,2));
        pikValues(u,y) = (distance(u,1)-distance(y,1)) + tho*(distance(u,1)-distance(y,1))*(distance(u,2)-distance(y,2)); %results of Eq. 26
     end
   end
   assesment(u) = relativeAssesment;
 end
assesment
fprintf("Ranking order of\nBiomass Hydroelectric Geothermal Wind Solar");

%% Step 9: rank the alternatives
[sd,r]=sort(assesment,'descend');
r