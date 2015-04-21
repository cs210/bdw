function [ B ] = gray2Binary( I, threshold )

B = single(255 * (I > threshold));

end

