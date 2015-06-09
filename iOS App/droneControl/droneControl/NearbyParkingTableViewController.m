//
//  NearbyParkingTableViewController.m
//  droneControl
//
//  Created by Michael Weingert on 2015-04-26.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "NearbyParkingTableViewController.h"
#import "ParkingLotFinder.h"
#import "DJICameraViewController.h"
#import "AerialViewController.h"
#import "ParkingLotTableViewCell.h"
#import "ParkingLot.h"
#import "LocationManager.h"

@interface NearbyParkingTableViewController () <ParkingLotFinderDelegate>
{
  NSMutableArray * _parkingLotsNearby;
}

@end

@implementation NearbyParkingTableViewController

@end
