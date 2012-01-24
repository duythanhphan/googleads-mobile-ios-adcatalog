// MainController.m
// Copyright 2011 Google Inc.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MainController.h"
#import "BannerCatalogController.h"
#import "InterstitialCatalogController.h"

#define MARGIN 13.0

@implementation MainController

@synthesize adTypeTableView = adTypeTableView_;
@synthesize adTypes = adTypes_;

#pragma mark MainController methods
// Grab a reference to the AdTypes UITableViewDataSource to populate our
// table view.
- (void)viewDidLoad {
  [super viewDidLoad];

  self.adTypes = [AdTypes singleton];

  self.adTypeTableView.dataSource = self.adTypes;
  self.adTypeTableView.delegate = self;
  self.adTypeTableView.rowHeight =
      (self.view.frame.size.height - (2 * MARGIN)) / 2;
}

- (void)dealloc {
  adTypeTableView_.dataSource = nil;
  adTypeTableView_.delegate = nil;
  [adTypeTableView_ release];
  [adTypes_ release];

  [super dealloc];
}

#pragma mark UITableViewDelegate methods
// When the user selects an ad type simply let its associated controller
// take over and display the catalog.
- (void)tableView:(UITableView *)sender
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  Class controllerClass =
      [self.adTypes classForAdTypeAtIndex:[indexPath indexAtPosition:1]];
  UIViewController *controller =
      [[[controllerClass alloc] initWithNibName:nil bundle:nil] autorelease];
  controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  [self presentModalViewController:controller animated:YES];

  [self.adTypeTableView reloadData];
}

- (void)tableView:(UITableView *)tableView
    willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.textLabel.textAlignment = UITextAlignmentCenter;
}

@end
