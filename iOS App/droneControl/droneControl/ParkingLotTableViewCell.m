//
//  ParkingLotTableViewCell.m
//  droneControl
//
//  Created by Ellen Sebastian on 5/2/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingLotTableViewCell.h"
@implementation ParkingLotTableViewCell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkingLotTableViewCell *cell = (ParkingLotTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Parking Lot"];
    return cell;
}
@end