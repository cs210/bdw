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
#import "LocationManager.h"

@implementation AerialViewController
{
    UIView * _dummyTouchView;
    DJICameraViewController* _cameraFeed;
    bool _firstLocationUpdate;
    UIImageView *_parkingLotView;
    NSURLConnection *currentConnection;
    
}

- (void) goToNavigation: (CLLocationCoordinate2D)destination {
    Class mapItemClass = [MKMapItem class];
    
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        _parkingSpace = destination;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parking spot found!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Navigate to spot", nil];
        [alert show];
    }
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




- (void)viewDidLoad {
    [super viewDidLoad];
    _firstLocationUpdate = NO;
    _GMViewController = [[GoogleMapsViewController alloc] init];
    [_GMViewController viewDidLoad];
    
    _GMViewController.googleMapView = [[GMSMapView alloc] initWithFrame:self.view.frame];
    _cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
    _cameraFeed.view.frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height );
    _dummyTouchView = [[TransparentTouchView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    _dummyTouchView.backgroundColor = [UIColor clearColor];
    
    GMSCameraPosition * pos = [GMSCameraPosition cameraWithLatitude:37.43 longitude:-122.17 zoom:17];
    _GMViewController.googleMapView.camera = pos;

    CGRect mapFrame = CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    _GMViewController.googleMapView.frame = mapFrame;
    
    CLLocation * userLocation = [[LocationManager sharedManager] getUserLocation];
    CLLocationCoordinate2D userLocationCoordinate = userLocation.coordinate;
    
    
    GMSCameraPosition *stanford = [GMSCameraPosition cameraWithLatitude: userLocationCoordinate.latitude                                                                longitude:userLocationCoordinate.longitude
                                                                   zoom:19];
    
    [_GMViewController.googleMapView setCamera:stanford];

    [self.view addSubview:_GMViewController.googleMapView];
    [self.view addSubview:_dummyTouchView];
    [self.view addSubview:_cameraFeed.view];
    [self.view addSubview:_GMViewController.googleMapView];
    
    self.view.backgroundColor = [UIColor blackColor];
}


-(void) viewWillAppear:(BOOL)animated{
    [(DJICameraViewController *)_cameraFeed publicViewWillAppearMethod:animated];
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
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.apiReturnXMLData setLength:0];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    NSLog(@"didReceiveData, length: %lu", (unsigned long)data.length);
    
    [self.apiReturnXMLData appendData:data];
    
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"URL Connection Failed!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
    NSError *error = nil;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:self.apiReturnXMLData options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        NSLog(@"Array: %@", jsonArray);
    }
    
    currentConnection = nil;
    
    
}

- (void) gotoGoogleMaps: (CLLocationCoordinate2D) startingLocation destinationLocation:(CLLocationCoordinate2D) destinationLocation{
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *googleMapsString = [NSString stringWithFormat:
                                      @"%@?saddr=%f,%f&daddr=%f,%f&directionsmode=driving",
                                      @"comgooglemaps://",
                                      startingLocation.latitude,
                                      startingLocation.longitude,
                                      destinationLocation.latitude,
                                      destinationLocation.longitude];
        NSLog(googleMapsString);
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:googleMapsString]];
    } else {        
        NSString *urlString = [NSString stringWithFormat:
                               @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
                               @"https://maps.googleapis.com/maps/api/directions/json",
                               startingLocation.latitude,
                               startingLocation.longitude,
                               destinationLocation.latitude,
                               destinationLocation.longitude,
                               @"AIzaSyBhGlOQOhHiPR9VPXS1QDoxCYbxB2Y5yG0"];
        NSURL *directionsURL = [NSURL URLWithString:urlString];
        
        //Build the Request
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:directionsURL];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        //Get the Result of Request
        if (!error) {
            //NSString *response = [request responseString];
            //NSDictionary *json =[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *json =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
            GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
            singleLine.strokeWidth = 7;
            singleLine.strokeColor = [UIColor greenColor];
            singleLine.map = _GMViewController.googleMapView;
        }
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
            // "cancel" or other: do nothing / go back to homepage?
        }
    }
}


-(void) userDidClickOnSpot: (CLLocationCoordinate2D) spot
{
    
    GMSMarker *marker = [GMSMarker markerWithPosition:spot];
    marker.title = @"Hello World";
    marker.map = _GMViewController.googleMapView;
    marker.icon = [UIImage imageNamed:@"car_big.png"];
    
    CLLocation * myLocation = _GMViewController.googleMapView.myLocation;
    GMSCameraPosition *currentLocation = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                                              longitude:myLocation.coordinate.longitude
                                                                   zoom:19];
    
    [_GMViewController.googleMapView setCamera:currentLocation];
    
    [self.view addSubview:_GMViewController.googleMapView];
    [self goToNavigation:spot];

    
    //Time to remove the touch view and the camera view and add the new view
    [_dummyTouchView removeFromSuperview];
    [_cameraFeed.view removeFromSuperview];
    
}


-(void) showMap{
    [self.view addSubview:_GMViewController.googleMapView];
    [_dummyTouchView removeFromSuperview];
    [_cameraFeed.view removeFromSuperview];
    
}

@end
