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
#import "TransparentTouchView.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
@implementation AerialViewController
{
    UIView * _dummyTouchView;
  DJICameraViewController* _cameraFeed;
}

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


- (BOOL)splitViewController:(UISplitViewController*)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return !_shouldShowMaster;
}

- (UIButton*) findClosestParkingButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(launchDrone)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@" Find closest parking " forState:UIControlStateNormal];
    double x = _mapView.frame.origin.x + 20.0;
    double y = _mapView.frame.origin.y + 20.0;
    double height = 150.0;
    double width = 600.0;
    button.titleLabel.font = [UIFont systemFontOfSize:30];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.frame = CGRectMake(x,y,width,height);
    button.backgroundColor = [UIColor colorWithRed:46.00/255.0f green:155.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button sizeToFit];

    return button;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldShowMaster = YES;
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    [_mapView addSubview:[self findClosestParkingButton]];
    [self.view addSubview:_mapView];
    self.splitViewController.delegate = self;
    _mapView.showsUserLocation = YES;
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
  
  self.view.backgroundColor = [UIColor blackColor];
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
                _shouldShowMaster = NO;
                [self hideMaster];
                //[_drone lookForParking];
                CLLocationCoordinate2D noLocation = _drone.userLocation.coordinate;
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 1000, 1000);
                MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
                [_mapView setRegion:adjustedRegion animated:YES];
                _cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
                [self.navigationController pushViewController:_cameraFeed animated:NO];
              
                // Resize the camera frame
              CGRect currFrame = _cameraFeed.view.frame;
              currFrame.size.width = [[UIScreen mainScreen] bounds].size.width * 0.75;
              currFrame.size.height = [[UIScreen mainScreen] bounds].size.height / 4.0;
              _cameraFeed.view.frame = currFrame;
              
              //cameraFeed.view.frame = CGRectMake(200,0,[[UIScreen mainScreen] bounds].size.width / 2 +120, [[UIScreen mainScreen] bounds].size.height / 2.0 );
              
              _cameraFeed.view.frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height );
              
              //Resize the map view
              /*CGRect mapFrame = _mapView.frame;
              mapFrame.size.height = [[UIScreen mainScreen] bounds].size.height / 2.0;
              mapFrame.origin.y = [[UIScreen mainScreen] bounds].size.height / 2.0;
              
              _mapView.frame = mapFrame;*/
              
              //Remove the map view
              [_mapView removeFromSuperview];
              
              [self.view addSubview:_cameraFeed.view];
              
              //_dummyTouchView = [[TransparentTouchView alloc] initWithFrame:CGRectMake(200,0,[[UIScreen mainScreen] bounds].size.width / 2 +120, [[UIScreen mainScreen] bounds].size.height / 2.0)];
              
              _dummyTouchView = [[TransparentTouchView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
              
              _dummyTouchView.backgroundColor = [UIColor clearColor];
              
              [self.view addSubview:_dummyTouchView];
	      //                [self launchDrone];
            }
            default: ; // they pressed cancel : do nothing
                
        }
        
    }
}

-(void)launchDrone{
    _shouldShowMaster = NO;
    [self hideMaster];
    //[_drone lookForParking];
    CLLocationCoordinate2D noLocation = _drone.userLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    DJICameraViewController* cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
    [self.navigationController pushViewController:cameraFeed animated:NO] ;
    // TODO make sure this scales the video correctly
    cameraFeed.view.frame = CGRectMake(0,0,cameraFeed.videoPreviewView.frame.size.width / 4, cameraFeed.videoPreviewView.frame.size.height / 4);
    [self.view addSubview:cameraFeed.view];
}

- (void)hideMaster  {
    NSLog(@"hide-unhide master");
    UISplitViewController* spv = self.splitViewController;
    spv.delegate=self;
    _shouldShowMaster = NO;
    // yes this stuff is deprecated but I cannot acheive my goal (to call shouldHideViewController) otherwise
    [spv willRotateToInterfaceOrientation: (UIInterfaceOrientation)[UIDevice currentDevice].orientation duration:0];
    [spv.view setNeedsLayout];
}

-(CLLocation *) getUserLocation
{
    return _locationManager.location;
}

-(void) userDidClickOnSpot: (CLLocationCoordinate2D) spot
{
  MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
  newAnnotation.coordinate = spot;
  [_mapView addAnnotation:newAnnotation];
  [_mapView selectAnnotation:newAnnotation animated:YES];
  newAnnotation.title = @"Selected spot";
  
  //Time to remove the touch view and the camera view and add the new view
  [self.view addSubview:_mapView];
  [_dummyTouchView removeFromSuperview];
  [_cameraFeed.view removeFromSuperview];
  
}

@end
