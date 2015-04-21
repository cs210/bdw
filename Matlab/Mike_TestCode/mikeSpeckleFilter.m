%% MIKE'S SPECKLE REMOVAL FILTER %%

function [newImage] = mikeSpeckleFilter(image, depth)
    [rows, columns, numberOfChannels] = size(image);
    newImage = image;
    for row = 1 : rows
        for column = 1 : columns
            if (newImage(row, column) > 200) %White pixel
                nextDirection = findNeighbourPixelDirection(image, row, column)
                switch(nextDirection)
                    case PixelDirections.None
                        image(row, column) = 0;
                        break;
                end
            end
        end
    end
end

