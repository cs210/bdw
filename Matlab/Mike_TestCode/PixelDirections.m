%% PIXEL DIRECTIONS CLASS %%
classdef PixelDirections
   enumeration
      TopLeft, TopCenter, TopRight, ...
      Left, Right, ...
      BottomLeft, BottomCenter, BottomRight,  ...
      None %No pixel found
   end
   methods(Static)
       function newPixelDirection = findNeighbourPixelDirection(image, row, column)
           [rows, columns, ~] = size(image);
            if (row == 1)
                if (column == 1)
                    %Only check right, bottomright, bottomcenter
                    if (image(row+1, column) > 150)
                        newPixelDirection = PixelDirections.BottomCenter;
                    elseif (image(row+1, column+1) > 150)
                        newPixelDirection = PixelDirections.BottomRight;
                    elseif (image(row, column+1) > 150)
                        newPixelDirection = PixelDirections.Right;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                elseif (column == columns)
                    %Only check right, topright, topcenter
                    if (image(row, column-1) > 150)
                        newPixelDirection = PixelDirections.Left;
                    elseif (image(row+1, column-1) > 150)
                        newPixelDirection = PixelDirections.BottomLeft;
                    elseif (image(row+1, column) > 150)
                        newPixelDirection = PixelDirections.BottomCenter;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                else
                    %Only check right, bottomright, bottomcenter, topright, topcenter
                    if (image(row, column-1) > 150)
                        newPixelDirection = PixelDirections.Left;
                    elseif (image(row+1, column-1) > 150)
                        newPixelDirection = PixelDirections.BottomLeft;
                    elseif (image(row+1, column) > 150)
                        newPixelDirection = PixelDirections.BottomCenter;
                    elseif (image(row+1, column+1) > 150)
                        newPixelDirection = PixelDirections.BottomRight;
                    elseif (image(row, column+1) > 150)
                        newPixelDirection = PixelDirections.Right;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                end
            elseif (row == rows)
                if (column == 1)
                    %Only check left, bottomleft, bottomcenter
                    if (image(row-1, column) > 150)
                        newPixelDirection = PixelDirections.TopCenter;
                    elseif (image(row, column+1) > 150)
                        newPixelDirection = PixelDirections.Right;
                    elseif (image(row-1, column+1) > 150)
                        newPixelDirection = PixelDirections.TopRight;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                elseif (column == columns)
                    %Only check left, topleft, topcenter
                    if (image(row-1, column) > 150)
                        newPixelDirection = PixelDirections.TopCenter;
                    elseif (image(row-1, column-1) > 150)
                        newPixelDirection = PixelDirections.TopLeft;
                    elseif (image(row, column-1) > 150)
                        newPixelDirection = PixelDirections.Left;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                else
                    %Only check top
                    if (image(row-1, column) > 150)
                        newPixelDirection = PixelDirections.TopCenter;
                    elseif (image(row-1, column-1) > 150)
                        newPixelDirection = PixelDirections.TopLeft;
                    elseif (image(row, column-1) > 150)
                        newPixelDirection = PixelDirections.Left;
                    elseif (image(row, column+1) > 150)
                        newPixelDirection = PixelDirections.Right;
                    elseif (image(row-1, column+1) > 150)
                        newPixelDirection = PixelDirections.TopRight;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                end
            else
                if (column == 1)
                    %Only check everything to right
                    if (image(row-1, column) > 150)
                        newPixelDirection = PixelDirections.TopCenter;
                    elseif (image(row+1, column) > 150)
                        newPixelDirection = PixelDirections.BottomCenter;
                    elseif (image(row+1, column+1) > 150)
                        newPixelDirection = PixelDirections.BottomRight;
                    elseif (image(row, column+1) > 150)
                        newPixelDirection = PixelDirections.Right;
                    elseif (image(row-1, column+1) > 150)
                        newPixelDirection = PixelDirections.TopRight;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                elseif (column == columns)
                    %Only check everything to the left
                    if (image(row-1, column) > 150)
                        newPixelDirection = PixelDirections.TopCenter;
                    elseif (image(row-1, column-1) > 150)
                        newPixelDirection = PixelDirections.TopLeft;
                    elseif (image(row, column-1) > 150)
                        newPixelDirection = PixelDirections.Left;
                    elseif (image(row+1, column-1) > 150)
                        newPixelDirection = PixelDirections.BottomLeft;
                    elseif (image(row+1, column) > 150)
                        newPixelDirection = PixelDirections.BottomCenter;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                else
                    %Check everything
                    if (image(row-1, column) > 150)
                        newPixelDirection = PixelDirections.TopCenter;
                    elseif (image(row-1, column-1) > 150)
                        newPixelDirection = PixelDirections.TopLeft;
                    elseif (image(row, column-1) > 150)
                        newPixelDirection = PixelDirections.Left;
                    elseif (image(row+1, column-1) > 150)
                        newPixelDirection = PixelDirections.BottomLeft;
                    elseif (image(row+1, column) > 150)
                        newPixelDirection = PixelDirections.BottomCenter;
                    elseif (image(row+1, column+1) > 150)
                        newPixelDirection = PixelDirections.BottomRight;
                    elseif (image(row, column+1) > 150)
                        newPixelDirection = PixelDirections.Right;
                    elseif (image(row-1, column+1) > 150)
                        newPixelDirection = PixelDirections.TopRight;
                    else
                        newPixelDirection = PixelDirections.None;
                    end
                end
            end
       end
       
       function [isActive, nextRow, nextCol] = CheckActivePixel(image, row, column, direction)
            switch(direction)
                case PixelDirections.TopLeft
                    isActive = (image(row-1, column-1) > 150);
                    nextRow = row - 1;
                    nextCol = column - 1;
                case PixelDirections.TopCenter
                    isActive = (image(row-1, column) > 150);
                    nextRow = row-1;
                    nextCol = column;
                case PixelDirections.TopRight
                    isActive = (image(row-1, column+1) > 150);
                    nextRow = row - 1;
                    nextCol = column + 1;
                case PixelDirections.Left
                    isActive = (image(row, column-1) > 150);
                    nextRow = row;
                    nextCol = column-1;
                case PixelDirections.Right
                    isActive = (image(row, column+1) > 150);
                    nextRow = row;
                    nextCol = column+1;
                case PixelDirections.BottomLeft
                    isActive = (image(row+1, column-1) > 150);
                    nextRow = row + 1;
                    nextCol = column - 1;
                case PixelDirections.BottomCenter
                    isActive = (image(row, column+1) > 150);
                    nextRow = row;
                    nextCol = column + 1;
                case PixelDirections.BottomRight
                    isActive = (image(row+1, column) > 150);
                    nextRow = row + 1;
                    nextCol = column;
            end
       end
        
       function didFind = PixelChecker(image, row, column, direction, depth)
           %Base case
           hold on
           plot(column, row, 'r*')
           if (depth == 0)
               didFind = 1;
               return;
           end
           % Add error checking here
           switch(direction)
              case PixelDirections.TopLeft
                  %Check if the topleft, center, or left pixel are active
                   dummyObj = PixelDirections.TopLeft;
                   [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                   if (~(active))
                       dummyObj = PixelDirections.TopCenter;
                       [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       if (~(active))
                           dummyObj = PixelDirections.Left;
                           [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       end
                   end
                   didFind = active && PixelDirections.PixelChecker(image, nextRow, nextCol, direction, depth - 1);
               case PixelDirections.TopCenter   
                   %Check if the topleft, center, or topright pixel are active
                   dummyObj = PixelDirections.TopLeft;
                   [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                   if (~(active))
                       dummyObj = PixelDirections.TopCenter;
                       [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       if (~(active))
                           dummyObj = PixelDirections.TopRight;
                           [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       end
                   end
                   didFind = active && PixelDirections.PixelChecker(image, nextRow, nextCol, direction, depth - 1);
               case PixelDirections.TopRight 
                   %Check if the topcenter, topright, right pixel are active
                   dummyObj = PixelDirections.TopCenter;
                   [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                   if (~(active))
                       dummyObj = PixelDirections.TopRight;
                       [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       if (~(active))
                           dummyObj = PixelDirections.Right;
                           [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       end
                   end
                   didFind = active && PixelDirections.PixelChecker(image, nextRow, nextCol, direction, depth - 1);
               case PixelDirections.Right 
                   %Check if the Topright, right, bottomright pixel are active
                   dummyObj = PixelDirections.Right;
                   [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                   if (~(active))
                       dummyObj = PixelDirections.TopRight;
                       [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       if (~(active))
                           dummyObj = PixelDirections.BottomRight;
                           [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       end
                   end
                   didFind = active && PixelDirections.PixelChecker(image, nextRow, nextCol, direction, depth - 1);

                case PixelDirections.BottomRight 
                   %Check if the right, bottomright, bottomcenter pixel are active
                   dummyObj = PixelDirections.Right;
                   [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                   if (~(active))
                       dummyObj = PixelDirections.BottomCenter;
                       [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       if (~(active))
                           dummyObj = PixelDirections.BottomRight;
                           [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       end
                   end
                   didFind = active && PixelDirections.PixelChecker(image, nextRow, nextCol, direction, depth - 1);

               case PixelDirections.BottomCenter 
                   %Check if the bottomright, bottomcenter, bottomleft pixel are active
                   dummyObj = PixelDirections.BottomRight;
                   [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                   if (~(active))
                       dummyObj = PixelDirections.BottomCenter;
                       [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       if (~(active))
                           dummyObj = PixelDirections.BottomLeft;
                           [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       end
                   end
                   didFind = active && PixelDirections.PixelChecker(image, nextRow, nextCol, direction, depth - 1);

               case PixelDirections.BottomLeft 
                   %Check if the bottomcenter, bottomleft, left pixel are active
                   dummyObj = PixelDirections.BottomCenter;
                   [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                   if (~(active))
                       dummyObj = PixelDirections.BottomLeft;
                       [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       if (~(active))
                           dummyObj = PixelDirections.Left;
                           [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       end
                   end
                   didFind = active && PixelDirections.PixelChecker(image, nextRow, nextCol, direction, depth - 1);

               case PixelDirections.Left 
                   %Check if the bottomleft, left, topleft pixel are active
                   dummyObj = PixelDirections.BottomLeft;
                   [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                   if (~(active))
                       dummyObj = PixelDirections.Left;
                       [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       if (~(active))
                           dummyObj = PixelDirections.TopLeft;
                           [active, nextRow, nextCol] = PixelDirections.CheckActivePixel(image, row, column, dummyObj);
                       end
                   end
                   didFind = active && PixelDirections.PixelChecker(image, nextRow, nextCol, direction, depth - 1);
           end
       end
   end
end