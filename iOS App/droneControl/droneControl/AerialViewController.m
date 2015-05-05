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
#import "DJICameraViewController.h"
#import "NearbyParkingTableViewController.h"
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
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //MKPointAnnotation *annot = (MKPointAnnotation *)annotation;

    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingLot"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIImage *image = [UIImage imageNamed:@"parking-icon.png"];
    [annotationView setImage:image];
    return annotationView;
}

- (void) addAnnnotationWithOffset:(bool)isParkingSpot location:(CLLocationCoordinate2D)location{
    if (isParkingSpot){
        MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        annot.title = @"Parking Lot";
        [_mapView selectAnnotation:annot animated:YES];
        
    } else {
        _droneAnnotation.coordinate = location;
        //[_mapView removeAnnotation:_point];
        [_mapView addAnnotation:_droneAnnotation];
        [_mapView selectAnnotation:_droneAnnotation animated:YES];
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
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
      _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    // BELOW LINE DOES NOT WORK ON IOS7 - must comment out to run on Jay's ipad
    //[_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
  
  
    // Add the button in here that will segue to the parking view controller if clicked
  /*UIButton * parkingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  CGSize screenSize = [UIScreen mainScreen].bounds.size;
  parkingButton.frame = CGRectMake(screenSize.width - 100, screenSize.height - 100, 50, 50);
  [parkingButton setBackgroundImage:[UIImage imageNamed:@"parking-icon.png"] forState:UIControlStateNormal];
  [parkingButton addTarget:self action:@selector(findParkingClicked:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:parkingButton];*/
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
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(crnLoc.coordinate, 2000, 2000);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
        _droneAnnotation = [[MKPointAnnotation alloc] init];
        _drone = [[DroneController alloc]init];
        _drone.delegate = self;
        _drone.userLocation = crnLoc;
        //[_drone lookForParking];
        _didStartLooking = true;
        
      [[ParkingLotFinder sharedManager ] setLocation:crnLoc.coordinate radius:500];
      
      NSMutableArray* lots =  [[ParkingLotFinder sharedManager] getLots];
        for (ParkingLot *parkingLot in lots){
            MKPointAnnotation *lotAnnotation = [[MKPointAnnotation alloc] init];
            lotAnnotation.coordinate = parkingLot->coordinate;
            [_mapView addAnnotation:lotAnnotation];
            [_mapView selectAnnotation:lotAnnotation animated:YES]; // this is needed for the image to be set correctly.
            [_mapView deselectAnnotation:lotAnnotation animated:YES]; // this is needed for the image to be set correctly.
            
            lotAnnotation.title = parkingLot->name;
            [_mapView viewForAnnotation:lotAnnotation].canShowCallout = YES;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button setTitle:parkingLot->name forState:UIControlStateNormal];
            [button addTarget:self action:@selector(lotButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_mapView viewForAnnotation:lotAnnotation].rightCalloutAccessoryView = button;
            
        }
    }
  // Update the spots to sort around location
  [[ParkingLotFinder sharedManager] updateLotsWithLocation: [locations lastObject]];
}

- (void) lotButtonPressed:(id) sender{ // how to get the name of the parking lot here?
    if ([sender isKindOfClass:[UIButton self]]) {
        // it's a button
        UIButton *button = (UIButton *)sender;
        NSString *title = [NSString stringWithFormat:@"look for parking in %@?", button.currentTitle];
      [self showParkingLotConfirmationWithTitle:title];
    }
    
}

-(void) showParkingLotConfirmationWithTitle:(NSString *)title
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Find a spot", nil];
  [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
  if ([overlay isKindOfClass:[MKPolyline class]]) {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    [renderer setStrokeColor:[UIColor blueColor]];
    [renderer setLineWidth:5.0];
    return renderer;
  }
  return nil;
}

// BUG: alerts keep showing up many times
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
               // [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                //               launchOptions:launchOptions];
              
              MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
              [request setSource:[MKMapItem mapItemForCurrentLocation]];
              [request setDestination:mapItem];
              [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
              [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
              MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
              [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                if (!error) {
                  for (MKRoute *route in [response routes]) {
                    [_mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
                    // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
                  }
                }
              }];
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
                //    [self onGimbalAttitudeScrollDown];
                [_drone lookForParking];
                UINavigationController *masterVC = [self.splitViewController.viewControllers firstObject];
                NSArray *viewControllers = masterVC.viewControllers;
                NearbyParkingTableViewController *tableVC = [viewControllers objectAtIndex:0];
                DJICameraViewController* cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
                [self.navigationController pushViewController:cameraFeed animated:NO];
              
                CLLocationCoordinate2D noLocation = _drone.userLocation.coordinate;
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 1000, 1000);
                MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
                [_mapView setRegion:adjustedRegion animated:YES];
                
                [tableVC.navigationController pushViewController:self animated:NO];
                //[tableVC showDroneVideo];
            }
            default: ; // they pressed cancel : do nothing
                
        }
        
    }
}

-(CLLocation *) getUserLocation
{
  return _locationManager.location;
}

@end