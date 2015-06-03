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
#import "ParkingSpotHighlightBridge.h"

@implementation AerialViewController
{
    UIView * _dummyTouchView;
    DJICameraViewController* _cameraFeed;
    UIButton * _findClosestParkingButton;
    bool _nextAnnotationIsSpot;
    bool _firstLocationUpdate;
    
    UIImageView *_parkingLotView;
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
    UIImage *image = [UIImage imageNamed:@"parking-icon.png"];
    if (_nextAnnotationIsSpot){
        image = [UIImage imageNamed:@"car_big.png"];
        _nextAnnotationIsSpot = NO;
    }
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingLot"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [annotationView setImage:image];
    return annotationView;
}


- (void) addAnnnotationWithOffset:(bool)isParkingSpot location:(CLLocationCoordinate2D)location{
    
#ifdef USING_GMAPS
    assert(0);
#else
    if (isParkingSpot){
        MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        annot.title = @"Parking Lot";
        [_mapView selectAnnotation:annot animated:YES];
        
    } else {
        _droneAnnotation.coordinate = location;
        [_mapView addAnnotation:_droneAnnotation];
        [_mapView selectAnnotation:_droneAnnotation animated:YES];
        _droneAnnotation.title = @"Drone";
        [[_mapView viewForAnnotation:_droneAnnotation] setTag:1];
        UIImage *image = [UIImage imageNamed:@"drone_small.png"];
        [[_mapView viewForAnnotation:_droneAnnotation] setImage:image];
        [_mapView deselectAnnotation:_droneAnnotation animated:YES];
    }
#endif
}


- (void) goToNavigation: (CLLocationCoordinate2D)destination {
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        _parkingSpace = destination;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parking spot found!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Navigate to spot",@"View spot", nil];
        [alert show];
    }
}


- (BOOL)splitViewController:(UISplitViewController*)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return !_shouldShowMaster;
}

-(void) testGPS
{
    [((TransparentTouchView *)_dummyTouchView) insertArticifialTouchWithYaw:-179.505600
                                                                   altitude:40.775520
                                                                          X:534.500000
                                                                          Y:28.500000
                                                           aerialController:self
                                                                  viewWidth:self.view.frame.size.width
                                                                 viewHeight:self.view.frame.size.height];
}

-(void) parkingSpotFill
{
    // Here we are going to pass in an image to the parking spot fill. This image is supposed to be a simulated image from the drone
    // Create a UIImage from the "Parking.JPG" file
    UIImage *image = [UIImage imageNamed:@"Parking.JPG"];
    
    // Scale the image to fill up the size of the frame
    
    UIImage *scaledImage = [ParkingSpotHighlightBridge imageByScalingAndCroppingWithImage:image forSize:self.view.frame.size];
    
    _parkingLotView = [[UIImageView alloc] initWithImage:scaledImage];
    
    [self.view addSubview:_parkingLotView];
    [self.view addSubview:_dummyTouchView];
}

-(void) highlightTouchedUserSpot:(float) x withY:(float) y
{
    [_parkingLotView removeFromSuperview];
    
    UIImage *image = [UIImage imageNamed:@"Parking.JPG"];
    
    UIImage *scaledImage = [ParkingSpotHighlightBridge imageByScalingAndCroppingWithImage:image forSize:self.view.frame.size];
    
    UIImage * newImage = [ParkingSpotHighlightBridge initWithUIImage:scaledImage andClickX:x andClickY: y];
    
    _parkingLotView = [[UIImageView alloc] initWithImage:newImage];
    
    [self.view addSubview:_parkingLotView];
    [self.view addSubview:_dummyTouchView];
}


- (UIButton*) findClosestParkingButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
#ifdef DRONE_GPS_TEST
    [button addTarget:self
               action:@selector(testGPS)
     forControlEvents:UIControlEventTouchUpInside];
#elif PARKING_SPOT_FILL
    [button addTarget:self
               action:@selector(parkingSpotFill)
     forControlEvents:UIControlEventTouchUpInside];
#else
    [button addTarget:self
               action:@selector(launchDrone)
     forControlEvents:UIControlEventTouchUpInside];
#endif
    
    [button setTitle:@"Top view" forState:UIControlStateNormal];
    
#ifdef USING_GMAPS
    double x = _googleMapView.frame.origin.x + 20.0;
    double y = _googleMapView.frame.origin.y + 50.0;
#else
    double x = _mapView.frame.origin.x + 20.0;
    double y = _mapView.frame.origin.y + 50.0;
#endif
    double height = 40.0;
    double width = 300.0;
    button.titleLabel.font = [UIFont systemFontOfSize:30];
  
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [ button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.frame = CGRectMake(x,y,width,height);
    button.backgroundColor = [UIColor colorWithRed:46.00/255.0f green:155.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldShowMaster = YES;
    _nextAnnotationIsSpot = NO;
    _firstLocationUpdate = NO;
    
#ifdef USING_GMAPS
    
    #ifdef SPLITSCREENWITHDRONE
        CGRect mapFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2);
        _googleMapView = [[GMSMapView alloc] initWithFrame:mapFrame];
    #else
        _googleMapView = [[GMSMapView alloc] initWithFrame:self.view.frame];
    #endif
    _googleMapView.delegate = self;
    
#else
    
    #ifdef SPLITSCREENWITHDRONE
        CGRect mapFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2);
        _mapView = [[MKMapView alloc] initWithFrame:mapFrame];
    #else
        _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    #endif
    _mapView.delegate = self;
#endif
    
    
    _findClosestParkingButton = [self findClosestParkingButton];
    [_findClosestParkingButton setTitle:@"Drone view" forState:UIControlStateNormal];
#ifdef SPLITSCREENWITHDRONE
    _cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
    _cameraFeed.view.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height / 2,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height / 2 );
    _dummyTouchView = [[TransparentTouchView alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height / 2,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height / 2)];
    _dummyTouchView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_cameraFeed.view];
    [self.view addSubview:_dummyTouchView];
    
#else
    _cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
    _cameraFeed.view.frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height );
    _dummyTouchView = [[TransparentTouchView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    _dummyTouchView.backgroundColor = [UIColor clearColor];
#endif

#ifdef USING_GMAPS
    
    #ifdef SPLITSCREENWITHDRONE
    #else
    [_googleMapView addSubview:_findClosestParkingButton];
    #endif
    
    [self.view addSubview:_googleMapView];
    
    [_googleMapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _googleMapView.myLocationEnabled = YES;
    });
    
    _googleMapView.settings.myLocationButton = YES;
    
    GMSCameraPosition *stanford = [GMSCameraPosition cameraWithLatitude:37.4300
                                                            longitude:-122.1700
                                                                 zoom:16];
    
    [_googleMapView setCamera:stanford];
#else
    
    #ifdef SPLITSCREENWITHDRONE
    #else
    [_mapView addSubview:_findClosestParkingButton];
    #endif
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
#endif
    
    
    self.splitViewController.delegate = self;
    
    self.view.backgroundColor = [UIColor blackColor];
}


-(void) viewWillAppear:(BOOL)animated{
   // [self launchDrone];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!_firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _googleMapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                        zoom:17];
    }
}


-(void) findParkingClicked:(UIButton *) sender
{
    //Perform segue here manually to table view controller
    [self performSegueWithIdentifier:@"NearbyParkingSegue" sender:self];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
#ifdef USING_GMAPS
    // assert(0);
    // We don't need to search for parking lots as we aren't doing this anymore
#else
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
#endif
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
                        for(MKRoute *route in [response routes]) {
#ifdef USING_GMAPS
                            assert(0);
#else
                            [_mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
                            // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
#endif
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
                [self launchDrone];
            }
            default: ; // they pressed cancel : do nothing
                
        }
        
    }
}


-(void)launchDrone{
#ifdef USING_GMAPS
    [_googleMapView removeFromSuperview];
#else
    [_mapView removeFromSuperview];
#endif
    [self.view addSubview:_dummyTouchView];
    [self.view addSubview:_cameraFeed.view];
    _shouldShowMaster = NO;
    [self hideMaster];
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


-(void) userDidClickOnSpot: (CLLocationCoordinate2D) spot
{
    
#ifdef USING_GMAPS
    //assert(0);
    
    CLLocationCoordinate2D position = spot;
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = @"Hello World";
    marker.map = _googleMapView;
    marker.icon = [UIImage imageNamed:@"car_big.png"];
    
    CLLocation * myLocation = _googleMapView.myLocation;
    
    GMSCameraPosition *stanford = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                                              longitude:myLocation.coordinate.longitude
                                                                   zoom:19];
    
    [_googleMapView setCamera:stanford];
    
    [self.view addSubview:_googleMapView];
#else
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 10, 10);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    _nextAnnotationIsSpot = YES;

    MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
    newAnnotation.coordinate = spot;
    [_mapView addAnnotation:newAnnotation];
    [_mapView selectAnnotation:newAnnotation animated:YES];
    newAnnotation.title = @"Selected spot";
    
    [self.view addSubview:_mapView];
#endif
    
    //Time to remove the touch view and the camera view and add the new view
#ifdef SPLITSCREENWITHDRONE
#else
    [_dummyTouchView removeFromSuperview];
    [_cameraFeed.view removeFromSuperview];
#endif
  
    [_findClosestParkingButton setTitle:@"Drone view" forState:UIControlStateNormal];
    _findClosestParkingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}


-(void) showMap{
#ifdef USING_GMAPS
    [self.view addSubview:_googleMapView];
#else
    [self.view addSubview:_mapView];
#endif
    [_dummyTouchView removeFromSuperview];
    [_cameraFeed.view removeFromSuperview];
    
    [_findClosestParkingButton setTitle:@"Drone view" forState:UIControlStateNormal];
    _findClosestParkingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

}

@end
