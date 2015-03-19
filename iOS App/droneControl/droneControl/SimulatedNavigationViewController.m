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

@property (nonatomic, strong) MKPointAnnotation *point;
@property (nonatomic) int n_times_moved;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation SimulatedNavigationViewController

- (void) addAnnnotationWithOffset:(bool)isParkingSpot{
    CLLocationCoordinate2D fakeMapPoint;
    fakeMapPoint.longitude = _userLocation.coordinate.longitude + (0.0001 * (float) _n_times_moved);
    fakeMapPoint.latitude = _userLocation.coordinate.latitude + (0.0001 * (float) _n_times_moved);
    _point.coordinate = fakeMapPoint;
    [_mapView removeAnnotation:_point];
    [_mapView addAnnotation:_point];
    
    if (isParkingSpot){
        _point.title = @"Parking spot";
        [_mapView selectAnnotation:_point animated:YES];
    } else {
        _point.title = @"Drone";
        [[_mapView viewForAnnotation:_point] setTag:1];
        UIImage *image = [UIImage imageNamed:@"drone_small.png"];
        [[_mapView viewForAnnotation:_point] setImage:image];
    }
    
}

- (void) moveAnnotation{
    if (_n_times_moved > 10){
        [self addAnnnotationWithOffset:false];
        return;
    }
    [_mapView removeAnnotation:_point];
    
    CLLocationCoordinate2D fakeMapPoint;
    fakeMapPoint.longitude = _userLocation.coordinate.longitude + (0.0001 * (float) _n_times_moved);
    fakeMapPoint.latitude = _userLocation.coordinate.latitude + (0.0001 * (float) _n_times_moved);
    _point.coordinate = fakeMapPoint;
    _point.title = @"Drone";
    //_point.subtitle = @"Drone";
    
    [_mapView addAnnotation:_point];
    [_mapView selectAnnotation:_point animated:YES];
    
    [[_mapView viewForAnnotation:_point] setTag:1];
    UIImage *image = [UIImage imageNamed:@"drone_small.png"];
    [[_mapView viewForAnnotation:_point] setImage:image];
    
    
    _n_times_moved += 1;
}

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
    if (_n_times_moved == 0){
        CLLocation *crnLoc = [locations lastObject];
        _userLocation = crnLoc;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_userLocation.coordinate, 500, 500);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        // Add an annotation
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.95
                                                  target:self
                                                selector:@selector(moveAnnotation)
                                                userInfo:nil
                                                 repeats:YES];
        _point = [[MKPointAnnotation alloc] init];
        
        CLLocationCoordinate2D fakeMapPoint;
        fakeMapPoint.longitude = _userLocation.coordinate.longitude ;
        fakeMapPoint.latitude = _userLocation.coordinate.latitude;
        
        _point.coordinate = fakeMapPoint;
        _point.title = @"Drone";
        //_point.subtitle = @"Drone";
        [_mapView addAnnotation:_point];
        [_mapView selectAnnotation:_point animated:NO];
        _n_times_moved = 1;
    }
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
