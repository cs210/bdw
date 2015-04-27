//
//  AerialViewController
//  droneControl
//
//  Created by Michael Weingert on 2015-03-16.
//  Copyright (c) 2015 bdw. All rights reserved.
//
// parkwhiz key: 62d882d8cfe5680004fa849286b6ce20
/*This is going to be a map interface
 NSMutableArray* lots = [ParkingLotFinder parkingLotsNearby:crnLoc.coordinate radius:500];
 for (ParkingLot *parkingLot in lots){
 MKPointAnnotation *lotAnnotation = [[MKPointAnnotation alloc] init];
 lotAnnotation.coordinate = parkingLot->coordinate;
 [_mapView addAnnotation:lotAnnotation];
 [_mapView selectAnnotation:lotAnnotation animated:YES];
 lotAnnotation.title = @"Parking spot";
 UIImage *image1 = [UIImage imageNamed:@"parking_spot_icon.png"];
 [[_mapView viewForAnnotation:lotAnnotation] setImage:image1];
 }
 
 */

#import "AerialViewController.h"
#import "ParkingLotFinder.h"
#import "SpotConfirmViewController.h"
#import <MapKit/MapKit.h>

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


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingLot"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
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
    
    _mapView.delegate = self;
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
  
  
    // Add the button in here that will segue to the parking view controller if clicked
  UIButton * parkingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  CGSize screenSize = [UIScreen mainScreen].bounds.size;
  parkingButton.frame = CGRectMake(screenSize.width - 100, screenSize.height - 100, 50, 50);
  [parkingButton setBackgroundImage:[UIImage imageNamed:@"parking-icon.png"] forState:UIControlStateNormal];
  [parkingButton addTarget:self action:@selector(findParkingClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:parkingButton];
}

-(void) findParkingClicked:(UIButton *) sender
{
  //Perform segue here manually to table view controller
  [self performSegueWithIdentifier:@"NearbyParkingSegue" sender:self];
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
        //[_drone lookForParking];
        _didStartLooking = true;
        
        NSMutableArray* lots = [ParkingLotFinder parkingLotsNearby:crnLoc.coordinate radius:500];
        for (ParkingLot *parkingLot in lots){
            MKPointAnnotation *lotAnnotation = [[MKPointAnnotation alloc] init];
            lotAnnotation.coordinate = parkingLot->coordinate;
            [_mapView addAnnotation:lotAnnotation];
            [_mapView selectAnnotation:lotAnnotation animated:YES]; // this is needed for the image to be set correctly.
            [_mapView deselectAnnotation:lotAnnotation animated:YES]; // this is needed for the image to be set correctly.
            
            lotAnnotation.title = parkingLot->name;
            UIImage *image1 = [UIImage imageNamed:@"parking_spot_icon.png"];
            
            // using parking_log.png causes an error: "Could not determine current country code: Error Domain=NSURLErrorDomain Code=-1005 "The network connection was lost."
            [[_mapView viewForAnnotation:lotAnnotation] setImage:image1];
            [_mapView viewForAnnotation:lotAnnotation].canShowCallout = YES;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button setTitle:parkingLot->name forState:UIControlStateNormal];
            [button addTarget:self action:@selector(lotButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_mapView viewForAnnotation:lotAnnotation].rightCalloutAccessoryView = button;
            
        }
        
    }
}

- (void) lotButtonPressed:(id) sender{ // how to get the name of the parking lot here?
    if ([sender isKindOfClass:[UIButton self]]) {
        // it's a button
        UIButton *button = (UIButton *)sender;
        NSString *title = [NSString stringWithFormat:@"look for parking in %@?", button.currentTitle];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Find a spot", nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Parking spot found!"]){
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
    } else {
        switch (buttonIndex){
            case 1:{
                [_drone lookForParking];
            }
            default: ; // they pressed cancel : do nothing
                
        }
        
    }
}

@end