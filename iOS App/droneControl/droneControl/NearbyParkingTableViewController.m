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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  //Get the number of parking lots from the parking lot finder
  [[ParkingLotFinder sharedManager] registerForLotUpdates:self];
  
  _parkingLotsNearby = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didUpdateLots
{
  _parkingLotsNearby = [[ParkingLotFinder sharedManager] getLots];
  [self.tableView reloadData];
}

-(void) lotOrderChanged
{
  _parkingLotsNearby = [[ParkingLotFinder sharedManager] getLots];
  [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navVC = self.navigationController;
    UISplitViewController *splitVC = navVC.splitViewController;
    NSArray *viewControllers = splitVC.viewControllers;
  
    if ([viewControllers count] < 1)
      return;
  
    AerialViewController *aerialVC = [viewControllers objectAtIndex:1];
  
    //This is a temp fix for now when the drone video is on the main screen
    if (aerialVC)
    {
      ParkingLot *pl = [_parkingLotsNearby objectAtIndex:indexPath.row];
      NSString * title = [NSString stringWithFormat:@"look for parking in %@?", pl->name];
      [aerialVC showParkingLotConfirmationWithTitle:title];
    }
}


// segue to a DJICameraViewController
- (void) showDroneVideo{
    NSLog(@"Showing drone video");
    NSLog(@"Moving gimbal and then to next view controller");
    DJICameraViewController* cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
    [self.navigationController pushViewController:cameraFeed animated:NO];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_parkingLotsNearby count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkingLotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Parking lot" forIndexPath:indexPath];
    ParkingLot *currentObject = [_parkingLotsNearby objectAtIndex:[indexPath row]];
    cell.lotNameLabel.text = currentObject->name;
  
    //Calculate the distance from current location to parking lot
  CLLocation * parkingLocation = [[CLLocation alloc] initWithLatitude:currentObject->coordinate.latitude longitude:currentObject->coordinate.longitude];
  CLLocation * myLocation = [[LocationManager sharedManager] getUserLocation];
  CLLocationDistance parkingDistance = [parkingLocation distanceFromLocation:myLocation];
  
  cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f mi", parkingDistance / 1609.34];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
