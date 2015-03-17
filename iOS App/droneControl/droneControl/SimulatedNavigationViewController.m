//
//  SimulatedNavigationViewController.m
//  droneControl
//
//  Created by Michael Weingert on 2015-03-16.
//  Copyright (c) 2015 bdw. All rights reserved.
//

/*This is going to be a map interface*/
#import "SimulatedNavigationViewController.h"
#import <MapKit/MapKit.h>

@interface SimulatedNavigationViewController () < CLLocationManagerDelegate>
{
  MKMapView * _mapView;
  CLLocationManager *_locationManager;
  
  CLLocation * _userLocation;
}

@end

@implementation SimulatedNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:_mapView];
  _mapView.showsUserLocation = YES;
  
  //Get the users current location
  _locationManager = [[CLLocationManager alloc] init];
  _locationManager.delegate = self;
  _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
  [_locationManager requestAlwaysAuthorization];
  [_locationManager startUpdatingLocation];
  
  CLLocationCoordinate2D noLocation;
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
  [_mapView setRegion:adjustedRegion animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  CLLocation *crnLoc = [locations lastObject];
  _userLocation = crnLoc;

  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_userLocation.coordinate, 500, 500);
  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
  [_mapView setRegion:adjustedRegion animated:YES];
  
  // Add an annotation
  MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
  
  CLLocationCoordinate2D fakeMapPoint;
  fakeMapPoint.longitude = _userLocation.coordinate.longitude + 0.001;
  fakeMapPoint.latitude = _userLocation.coordinate.latitude + 0.001;
  
  point.coordinate = fakeMapPoint;
  point.title = @"Spot";
  point.subtitle = @"Spot";
  
  [_mapView addAnnotation:point];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
