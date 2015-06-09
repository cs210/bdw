
//
//  AerialViewController
//  droneControl
//
//  Created by Michael Weingert on 2015-03-16.
//  Copyright (c) 2015 bdw. All rights reserved.
//


#import "AerialViewController.h"

@implementation AerialViewController

static const int ZOOM = 18;
static const NSString * GoogleDirectionsApiKey = @"AIzaSyBhGlOQOhHiPR9VPXS1QDoxCYbxB2Y5yG0";
static const NSString * GoogleDirectionsURL = @"https://maps.googleapis.com/maps/api/directions/json";
static NSString * OpenGoogleMapsApp = @"comgooglemaps://";

- (void) goToNavigation: (CLLocationCoordinate2D)destination
{
    Class mapItemClass = [MKMapItem class];
    
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        _parkingSpace = destination;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parking spot found!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Navigate to spot", nil];
        [alert show];
    }
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    _firstLocationUpdate = NO;
    _GMViewController = [[GoogleMapsViewController alloc] init];
    [_GMViewController viewDidLoad];
    
    _GMViewController.googleMapView = [[GMSMapView alloc] initWithFrame:self.view.frame];
    _cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
    _cameraFeed.view.frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height );
    _dummyTouchView = [[TransparentTouchView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    _dummyTouchView.backgroundColor = [UIColor clearColor];
    
    CGRect mapFrame = CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    _GMViewController.googleMapView.frame = mapFrame;
    
    CLLocation * userLocation = [[LocationManager sharedManager] getUserLocation];
    CLLocationCoordinate2D userLocationCoordinate = userLocation.coordinate;
    
    GMSCameraPosition *stanford = [GMSCameraPosition cameraWithLatitude: userLocationCoordinate.latitude                                                                longitude:userLocationCoordinate.longitude
                                                                   zoom:ZOOM];
    
    [_GMViewController.googleMapView setCamera:stanford];
    
    [_GMViewController.googleMapView addObserver:self
                     forKeyPath:@"myLocation"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    
    [self.view addSubview:_dummyTouchView];
    [self.view addSubview:_cameraFeed.view];
    [self.view addSubview:_GMViewController.googleMapView];
    
    self.view.backgroundColor = [UIColor blackColor];
}

-(void) viewWillAppear:(BOOL)animated
{
    [(DJICameraViewController *)_cameraFeed publicViewWillAppearMethod:animated];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor blueColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    return nil;
}

// update the map location
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _GMViewController.googleMapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:ZOOM];
}



- (void) gotoGoogleMaps: (CLLocationCoordinate2D) startingLocation destinationLocation:(CLLocationCoordinate2D) destinationLocation
{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:OpenGoogleMapsApp]])
    {
        NSString *googleMapsString = [NSString stringWithFormat:
                                      @"%@?center=%f,%f&saddr=%f,%f&daddr=%f,%f&directionsmode=driving",
                                      OpenGoogleMapsApp,
                                      startingLocation.latitude,
                                      startingLocation.longitude,
                                      startingLocation.latitude,
                                      startingLocation.longitude,
                                      destinationLocation.latitude,
                                      destinationLocation.longitude];
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:googleMapsString]];
    }
    else
    {
        NSString *urlString = [NSString stringWithFormat:
                               @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
                               GoogleDirectionsURL,
                               startingLocation.latitude,
                               startingLocation.longitude,
                               destinationLocation.latitude,
                               destinationLocation.longitude,
                               GoogleDirectionsApiKey];
        NSURL *directionsURL = [NSURL URLWithString:urlString];
        
        //Build the Request
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:directionsURL];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        //Get the Result of Request
        if (!error)
        {
            NSDictionary *json =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
            GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
            singleLine.strokeWidth = 7;
            singleLine.strokeColor = [UIColor greenColor];
            singleLine.map = _GMViewController.googleMapView;
        }
        [_GMViewController.googleMapView addSubview:[self cancelNavigationButton]];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Parking spot found!"]){
        if (buttonIndex == 1){
            _GMViewController.googleMapView.frame = self.view.frame;
            
            CLLocation * myLocation1 = [[LocationManager sharedManager] getUserLocation];
            
            CLLocationCoordinate2D myLocation = _GMViewController.googleMapView.myLocation.coordinate;
            
            CLLocationCoordinate2D startingLocation = myLocation1.coordinate;
            
            CLLocationCoordinate2D destinationLocation = _parkingSpace;
            
            if (myLocation.latitude < 1.0){
                NSLog(@"no location detected; setting to default");
                myLocation.latitude = 37.431184;
                myLocation.longitude = -122.173391;
                
            }
            [self gotoGoogleMaps:startingLocation destinationLocation:destinationLocation];
        }
    }
}

-(void) userDidClickOnSpot: (CLLocationCoordinate2D) spot
{
    GMSMarker *marker = [GMSMarker markerWithPosition:spot];
    marker.title = @"Selected parking spot";
    marker.map = _GMViewController.googleMapView;
    marker.icon = [UIImage imageNamed:@"car_big.png"];
    [self goToNavigation:spot];
}

-(void) showMap
{
    [self.view addSubview:_GMViewController.googleMapView];
    [_dummyTouchView removeFromSuperview];
    [_cameraFeed.view removeFromSuperview];
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

-(void) cancelNavigation{
    [self viewDidLoad];
}

- (UIButton*) cancelNavigationButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(cancelNavigation)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"Cancel Navigation" forState:UIControlStateNormal];
    
    double x = _GMViewController.googleMapView.frame.origin.x + 20.0;
    double y = _GMViewController.googleMapView.frame.origin.y + 50.0;

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

@end
