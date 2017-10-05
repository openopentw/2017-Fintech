function [minValue, minIndex] = minxy(matrix)
  [minValue, xs] = min(matrix);
  [minValue, y] = min(minValue);
  x = xs(y);
  minIndex = [x, y];
end
