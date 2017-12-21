function [distMin, queryTransformedBest]=linScaling4chart(query, dbVec, sfMin, sfMax, sfCount, alphaMin)
% linScaling: Linear scaling for chart detection
%
%	Usage:
%		[distMin, queryTransformedBest, distAll]=linScaling4chart(query, dbVec, sfMin, sfMax, sfCount, alphaMin)

sf=linspace(sfMin, sfMax, sfCount);	% scaling factors
queryLen=length(query);
distAll=inf*ones(1, sfCount);
queryTransformedAll=cell(1, sfCount);
alphaAll=zeros(1, sfCount);
for i=1:sfCount
	queryScaledLen=round(queryLen*sf(i));	% Length of the length-scaled query
	if queryScaledLen>length(dbVec), break; end	% Break if the length is too long
	%queryScaled=...					% Length-scaled query (compressed or expanded)
    queryScaled=interp1(query, linspace(1, queryLen, queryScaledLen));
	seg=dbVec(1:queryScaledLen);		% A segmeng of dbVec for comparison
	queryMean=mean(queryScaled);	% Mean of query
	segMean=mean(seg);				% Mean of seg
	queryJustified=queryScaled(:)-queryMean;	% Zero-justified query
	segJustified=seg(:)-segMean;					% Zero-justified seg
	%alpha=...									% Find alpha such that ||queryJustified*alpha-segJustified|| is minimized
    alpha = dot(queryJustified, segJustified) / sum(queryJustified .^ 2);
	diff=queryJustified*alpha-segJustified;		% Difference between queryJustified*alpha-segJustified 
	%rmse=...									% root mean squared error
    rmse = sqrt(mean(diff.^2));
	distAll(i)=rmse/abs(alpha);		% Normalized RMSE
	if alpha<alphaMin, distAll(i)=inf; end	% Set the distance to infinite if alpha is too small
	% queryTransformedAll{i}=...					% Record the transformed query
    queryTransformedAll{i}=queryJustified*alpha + segMean;
	alphaAll(i)=alpha;		% Record alpha
end
[distMin, minIndex]=min(distAll);	% Find the min distance
queryTransformedBest=queryTransformedAll{minIndex};		% Find the best transformed query
alphaBest=alphaAll(minIndex);	% Find the best alpha