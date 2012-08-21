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

#import "AdCatalogAppDelegate.h"
#import "AdvancedLayoutCatalogController.h"
#import "BannerCatalogController.h"
#import "InterstitialCatalogController.h"
#import "MainController.h"

#define MARGIN_IPHONE 13.0
#define MARGIN_IPAD 26.0

@interface MainController (Private)

- (void)layoutTableView;

@end

@implementation MainController

@synthesize adTypeTableView = adTypeTableView_;
@synthesize adTypes = adTypes_;
@synthesize testModeSwitch = testModeSwitch_;
@synthesize testModeLabel = testModeLabel_;

// Grab a reference to the AdTypes UITableViewDataSource to populate our
// table view.
- (void)viewDidLoad {
  [super viewDidLoad];
  self.adTypes = [[[AdTypeDataSource alloc] init] autorelease];
  self.adTypeTableView.dataSource = self.adTypes;
  self.adTypeTableView.delegate = self;
  // Update the testing switch to show the testing option that was last chosen.
  AdCatalogAppDelegate *delegate =
      (AdCatalogAppDelegate *)[UIApplication sharedApplication].delegate;
  self.testModeSwitch.on = delegate.shouldShowTestAds;

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self layoutTableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInt
                                         duration:(NSTimeInterval)duration {
  [self layoutTableView];
}

- (void)layoutTableView {
  CGSize screenSize = CGSizeMake(self.adTypeTableView.bounds.size.width,
                                 self.adTypeTableView.bounds.size.height);
  CGFloat margin =
      UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? MARGIN_IPAD :
                                                             MARGIN_IPHONE;
  self.adTypeTableView.rowHeight =
      (screenSize.height - ([self.adTypes.values count] * margin)) /
          [self.adTypes.values count];
  [self.adTypeTableView reloadData];

}

- (IBAction)toggleTestingSwitch:(id)sender {
  AdCatalogAppDelegate *delegate =
      (AdCatalogAppDelegate *)[UIApplication sharedApplication].delegate;
  delegate.shouldShowTestAds = self.testModeSwitch.on;
}

- (void)dealloc {
  adTypeTableView_.dataSource = nil;
  adTypeTableView_.delegate = nil;
  [adTypeTableView_ release];
  [adTypes_ release];

  [testModeSwitch_ release];
  [testModeLabel_ release];
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
