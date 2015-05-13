#include "SpaceHighlighter.h"
#include "Utils.h"
#include <iostream>

pair<int, int> findEdge(const Mat& img, int row, int col,
                        int delta_r, int delta_c) {
  int r = row;
  int c = col;
  while (r >= 0 && r < img.rows && c >= 0 && c < img.cols
      && (int)img.at<uchar>(r, c) == 0){
    r += delta_r;
    c += delta_c;
    //cout << (int)img.at<uchar>(r, c) << endl;
  }
  return make_pair(r - delta_r, c - delta_c);
}

vector<Point> findSpace(const Mat& img, int row, int col) {
  int deltas[][2] = {
      {1, 0}, {2, 1}, {1, 1}, {1, 2},
      {0, 1}, {-1, 2}, {-1, 1}, {-2, 1},
      {-1, 0}, {-2, -1}, {-1, -1}, {-1, -2},
      {0 -1}, {1, -2}, {1, -1}, {2, -1}};

  Point start(col, row);

  // Finds all edge points around the start.
  vector<Point> edge_points;
  vector<double> dists;
  for (size_t i = 0; i < arraysize(deltas); i++) {
    pair<int, int> edge_pixel = findEdge(img, row, col, -deltas[i][1],
        deltas[i][0]);
    Point edge_point(edge_pixel.second, edge_pixel.first);
    dists.push_back(dist(start, edge_point));
    edge_points.push_back(edge_point);
  }

  // Sorts the indices of the edge points based on increasing distance.
  vector<size_t> indices(dists.size());
  for (size_t i = 0; i < indices.size(); i++) indices[i] = i;
  sort(indices.begin(), indices.end(),
       [&dists](size_t i1, size_t i2) {return dists[i1] < dists[i2];});

  // Filters out points that are too far from the start point (these
  // likely will not actually be edges of a parking space).
  size_t middle = indices.size() / 2 + 1;
  size_t num_to_include = middle;
  for (size_t i = middle + 1; i < indices.size(); i++) {
    if (dists[i] > 2 * dists[middle]) {
      break;
    }
    ++num_to_include;
  }
  sort(indices.begin(), indices.begin() + num_to_include);
  vector<Point> space_vertices;
  for(int i = 0; i < num_to_include; i++) {
    space_vertices.push_back(edge_points[indices[i]]);
  }
  space_vertices.push_back(edge_points[indices[0]]);

  return space_vertices;
}

void highlightSpace(Mat& img, int row, int col) {
  vector<Point> space_vertices = findSpace(img, row, col);
  for (Point& p : space_vertices) {
    cout << p.x - 450 << " " << p.y - 325 << endl;
    circle(img, p, 5, Scalar(255));
  }
  const Point *points[1] = { &space_vertices[0] };
  int num_points = (int)space_vertices.size();
  fillPoly(img, points, &num_points, 1, Scalar(255));
}