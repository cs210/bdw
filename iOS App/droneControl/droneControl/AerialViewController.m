//
//  AerialViewController
//  droneControl
//
//  Created by Michael Weingert on 2015-03-16.
//  Copyright (c) 2015 bdw. All rights reserved.
//

/*This is going to be a map interface*/
#import "AerialViewController.h"
#import <MapKit/MapKit.h>

@interface AerialViewController () < CLLocationManagerDelegate>


@end

@implementation AerialViewController
- (void) receiveImage:(UIImage *)image
{
    
}

- (void) updateDroneLocation: (CLLocationCoordinate2D *)location{
    [self addAnnnotationWithOffset:false location:*location];
}


- (void) addAnnnotationWithOffset:(bool)isParkingSpot location:(CLLocationCoordinate2D)location{
    _droneAnnotation.coordinate = location;
    //[_mapView removeAnnotation:_point];
    [_mapView addAnnotation:_droneAnnotation];
    [_mapView selectAnnotation:_droneAnnotation animated:YES];
    if (isParkingSpot){
        _droneAnnotation.title = @"Parking spot";
        UIImage *image = [UIImage imageNamed:@"parking_spot_icon.png"];
        [[_mapView viewForAnnotation:_droneAnnotation] setImage:image];
        [_mapView selectAnnotation:_droneAnnotation animated:YES];
        
    } else {
        _droneAnnotation.title = @"Drone";
        [[_mapView viewForAnnotation:_droneAnnotation] setTag:1];
        UIImage *image = [UIImage imageNamed:@"drone_small.png"];
        [[_mapView viewForAnnotation:_droneAnnotation] setImage:image];
        [_mapView deselectAnnotation:_droneAnnotation animated:YES];
        
    }
    
}

- (void) goToNavigation: (CLLocationCoordinate2D)destination {
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destination
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Stanford"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
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
    if (!_didStartLooking){
        CLLocation *crnLoc = [locations lastObject];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(crnLoc.coordinate, 500, 500);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
        _droneAnnotation = [[MKPointAnnotation alloc] init];
        _drone = [[DroneController alloc]init];
        _drone.delegate = self;
        _drone.userLocation = crnLoc;
        [_drone lookForParking];
        _didStartLooking = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

