//
//  AerialViewController
//  droneControl
//
//  Created by Michael Weingert on 2015-03-16.
//  Copyright (c) 2015 bdw. All rights reserved.
//
// parkwhiz key: 62d882d8cfe5680004fa849286b6ce20
/*This is going to be a map interface*/
#import "AerialViewController.h"
#import "ParkingLotFinder.h"
#import "SpotConfirmViewController.h"
#import <MapKit/MapKit.h>

@interface AerialViewController () < CLLocationManagerDelegate>


@end

@implementation AerialViewController
- (void) receiveImage:(UIImage *)image 
{
    // check for a parking space using computer vision
    // if there is a parking space:
    // tell the drone to go to the parking space
    // trigger navigation (SpotConfirmViewController)
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
        _parkingSpace = destination;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parking spot found!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Navigate to spot",@"View spot", nil];
        [alert show];

        // Create an MKMapItem to pass to the Maps app
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

        NSMutableArray* lots = [ParkingLotFinder parkingLotsNearby:crnLoc.coordinate radius:500];

        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex){
        case 1:{ // braces needed because objc is stupid
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:_parkingSpace
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:@"Stanford"];
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                           launchOptions:launchOptions];
        }
        case 2:
            [self.navigationController pushViewController:[[SpotConfirmViewController alloc] init] animated:NO];
            // view spot: not implemented yet
        default: ;
            // "cancel" or other: do nothing / go back to homepage?
    }
}

@end

