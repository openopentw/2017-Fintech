function [index, distance]=knnSearch(x, X, k)
  X = X - x;
  squareDistance = X(1,:).^2 + X(2,:).^2;
  [squareDistance, index] = sort(squareDistance);
  distance = sqrt(squareDistance(1:5));
  index = index(1:5);
end
