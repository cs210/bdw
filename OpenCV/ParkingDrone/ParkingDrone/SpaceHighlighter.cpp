#include "SpaceHighlighter.h"
#include "Utils.h"
#include <iostream>
#include <cmath>
#include <cstdlib>

#define PI 3.14159265

/**
 * For the given image img, starts at the given row and col and keeps
 * adding delta_r to the row and delta_c to the col until it reaches a
 * white pixel or the edge of the image. Returns the row and col of the
 * last black pixel found.
 */
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

/**
 * Given the image img and a given pixel's row and col, finds the
 * parking space containing the pixel. It returns the vertices of a
 * polygon covering most of the space as a vector of points.
 *
 * Note: The returned points have xy-coordinates, not row-col.
 */
vector<Point> findSpace(const Mat& img, int row, int col) {
  int deltas[][2] = {
      {1, 0}, {2, 1}, {1, 1}, {1, 2},
      {0, 1}, {-1, 2}, {-1, 1}, {-2, 1},
      {-1, 0}, {-2, -1}, {-1, -1}, {-1, -2},
      {0, -1}, {1, -2}, {1, -1}, {2, -1}};

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

  /*
  for (int i = 0; i < indices.size(); i++) {
    cout << indices[i] << endl;
  }
  */

  // Filters out points that are too far from the start point (these
  // likely will not actually be edges of a parking space).
  size_t middle = indices.size() / 2;
  size_t num_to_include = middle + 1;
  for (size_t i = middle + 1; i < indices.size(); i++) {
    if (dists[i] > 5 * dists[middle]) {
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

/**
 * Returns the direction (angle) of a vector in degrees (0 <= theta < 360),
 * where the vector is passed in as a Point object.
 */
double angle(const Point& p) {
  // Avoids divide-by-zero error
  if (p.x == 0) {
    if (p.y > 0) return 90;
    return 270;
  }
  double angle = atan(1.0 * p.y / p.x);
  if (p.x < 0) angle += PI;
  if (angle < 0) angle += 2 * PI;
  return angle * 180 / PI;
}

/**
 * Performs some initial checks of whether the chosen point is
 * inside a parking space.
 */
bool initialCheck(const Mat& img, int row, int col) {
  int thresh = 10;
  for (int i = -thresh; i <= thresh; i++) {
    for (int j = -thresh; j <= thresh; j++) {
      int r = row + i;
      int c = col + j;
      if (r < 0 || r >= img.rows || c < 0 || c >= img.cols) continue;
      if ((int)img.at<uchar>(r, c) != 0) return false;
    }
  }
  return true;
}

/**
 * Does some angular checks to see if the chosen point is inside a
 * parking space. It takes in a vector of points representing the
 * vertices of the shape and returns true if the check is passed.
 */
bool checkAngles(const vector<Point>& space_vertices) {
  int size = (int)space_vertices.size();
  if (size < 3) return false;
  for (int i = 0; i < size - 1; i++) {
    int prev = (i - 1) < 0 ? size - 2 : (i - 1);
    int cur = i;
    int next = i + 1;
    const Point& prevPoint = space_vertices[prev];
    const Point& curPoint = space_vertices[cur];
    const Point& nextPoint = space_vertices[next];
    
    // Gets the angles of the two vectors pointing out of the middle
    Point v1(prevPoint.x - curPoint.x, -(prevPoint.y - curPoint.y));
    Point v2(nextPoint.x - curPoint.x, -(nextPoint.y - curPoint.y));
    double angle1 = angle(v1);
    double angle2 = angle(v2);

    // Checks if these points form a concave angle.
    if (angle2 < angle1) angle2 += 360;
    if (angle1 + 135 > angle2) { // includes 45 degrees of leeway
      return false;
    }
  }
  return true;
}

bool highlightSpace(Mat& img, int row, int col) {
  Mat binary = preprocess(img);

  if (!initialCheck(binary, row, col)) return false;

  vector<Point> space_vertices = findSpace(binary, row, col);

  if (!checkAngles(space_vertices)) return false;

  Scalar yellow(0, 255, 255);
  const Point *points[1] = { &space_vertices[0] };
  int num_points = (int)space_vertices.size();
  fillPoly(img, points, &num_points, 1, yellow);
  return true;
}