//
//  LocationManager.h
//  droneControl
//
//  Created by Michael Weingert on 2015-05-23.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


/*!
 @class LocationManager
 @abstract Fetches and manages the user's location, making it available to the entire app.
 */



@protocol LocationManagerProtocol

/*!
 * @discussion Protocol method called when the location manager gets a new location
 * @param locations The array of user locations
 */
-(void) locationManagerDidUpdateLocation: (NSArray *)locations;

@end

@interface LocationManager : NSObject < CLLocationManagerDelegate >

/*!
 * @brief A reference to the inner locationManager object
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/*!
 * @discussion Singleton reference to this class
 * @return A reference to the singleton object
 */
+ (instancetype)sharedManager;

/*!
 * @discussion Public method called when touch events are captured on this view
 * @return The current user location
 */
-(CLLocation *) getUserLocation;

@end
