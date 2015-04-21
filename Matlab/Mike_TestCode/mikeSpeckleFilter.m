%% MIKE'S SPECKLE REMOVAL FILTER %%

function [newImage] = mikeSpeckleFilter(image, depth)
    [rows, columns, numberOfChannels] = size(image);
    newImage = image;
    for row = 1 : rows
        for column = 1 : columns
            if (newImage(row, column) > 200) %White pixel
                %nextDirection = PixelDirections.findNeighbourPixelDirection(image, row, column);
                %switch(nextDirection)
                %    case PixelDirections.None
                %        newImage(row, column) = 0;
                %        break;
                %end
                
                %Ok Look for a line with 5 pixels. If we get one, just
                %break.
                nextDirection = PixelDirections.findNeighbourPixelDirection(image, row, column);
                PixelDirections.PixelChecker(image, row, column, nextDirection, 5)
            end
            
            fprintf('Current pixel: %i, %i\n', row, column);
        end
    end
end

