function [ B ] = gray2Binary( I, threshold )

B = single(I > threshold);

end

