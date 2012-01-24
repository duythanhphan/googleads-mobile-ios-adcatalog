// InterstitialCatalogController.m
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

#import "InterstitialCatalogController.h"
#import "AdCatalogAppDelegate.h"
#import "InterstitialRootController.h"
#import "InterstitialUseCases.h"
#import "SampleConstants.h"

@implementation InterstitialCatalogController

@synthesize splashSwitch = splashSwitch_;
@synthesize useCaseTableView = useCaseTableView_;
@synthesize useCases = useCases_;

- (GADRequest *)buildGADRequest {
  GADRequest *request = [GADRequest request];
  request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
  return request;
}

// When the user's done simply pop back out to MainController.
- (IBAction)done:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
  basicInterstitial_.delegate = nil;
  [basicInterstitial_ release];

  useCaseTableView_.dataSource = nil;
  useCaseTableView_.delegate = nil;
  [useCaseTableView_ release];
  [splashSwitch_ release];

  [useCases_ release];

  [super dealloc];
}

#pragma mark GADInterstitialDelegate methods
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
  [ad presentFromRootViewController:self];
}

// Alert the user if the basic interstitial fails to load.
- (void)interstitial:(GADInterstitial *)sender
    didFailToReceiveAdWithError:(GADRequestError *)error {
  UIAlertView *alertView = [[UIAlertView alloc]
                            initWithTitle:@"GADRequestError"
                            message:[error localizedDescription]
                            delegate:nil
                            cancelButtonTitle:@"Drat"
                            otherButtonTitles:nil];

  [[alertView autorelease] show];
}

#pragma mark UITableViewDelegate methods
// Whenever the user selects one of the InterstitialUseCases see if it has a
// controller. If so simply present it, but if not load a trivial one.
- (void)tableView:(UITableView *)sender
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Class controllerClass =
      [self.useCases classForUseCaseAtIndex:[indexPath indexAtPosition:1]];
  UIViewController *controller =
      [[[controllerClass alloc] initWithNibName:nil bundle:nil] autorelease];
  controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

  if (controller) {
    [self presentModalViewController:controller animated:YES];
  } else {
    if (!basicInterstitial_) {
      basicInterstitial_ = [[GADInterstitial alloc] init];
      basicInterstitial_.adUnitID = INTERSTITIAL_AD_UNIT_ID;
      basicInterstitial_.delegate = self;
    }
    [basicInterstitial_ loadRequest:[self buildGADRequest]];
  }
  [useCaseTableView_ reloadData];
}

// Update AdCatalogAppDelegate.shouldShowSplashInterstitial as per the user.
- (IBAction)toggleSplash:(id)sender {
  ((AdCatalogAppDelegate *)[UIApplication sharedApplication].delegate).
      shouldShowSplashInterstitial = splashSwitch_.on;
}

// The receiver is the useCaseTableView_'s delegate for input events
// and the InterstitialUseCases singleton is its datasource.
- (void)viewDidLoad {
  splashSwitch_.on =
      ((AdCatalogAppDelegate *)[UIApplication sharedApplication].delegate).
          shouldShowSplashInterstitial;

  self.useCases = [InterstitialUseCases singleton];
  useCaseTableView_.dataSource = self.useCases;
  useCaseTableView_.delegate = self;
}

@end
