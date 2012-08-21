// BannerCatalogController.m
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

#import "AdCatalogUtilities.h"
#import "BannerCatalogController.h"
#import "SampleConstants.h"

@interface BannerCatalogController (Private)

- (GADAdSize)selectedBannerSize;
- (void)layoutGADBannerView;

@end

@implementation BannerCatalogController

@synthesize sizeTableView = sizeTableView_;
@synthesize bannerSizes = bannerSizes_;

// BannerCatalogController is the sizeTableView_'s delegate for input events and
// the BannerSizes singleton is its datasource.
- (void)viewDidLoad {
  self.bannerSizes = [[[BannerSizeDataSource alloc] init] autorelease];
  self.bannerSizes.delegate = self;
  self.sizeTableView.delegate = self;
  self.sizeTableView.dataSource = self.bannerSizes;

  adView_ = [[GADBannerView alloc] initWithFrame:CGRectZero];
  adView_.adUnitID = BANNER_AD_UNIT_ID;
  adView_.delegate = self;
  [adView_ setRootViewController:self];

  [self.view insertSubview:adView_ aboveSubview:self.sizeTableView];
}

// When the user's done simply pop back out to MainController.
- (IBAction)done:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

// Set the origin of the adView frame per the selected size for the banner.
- (void)layoutGADBannerView {
  CGSize bannerCGSize = CGSizeFromGADAdSize(adView_.adSize);
  CGRect frame = adView_.frame;
  CGSize screenSize = CGSizeMake(self.view.bounds.size.width,
                                 self.view.bounds.size.height);
  frame.origin.x = (screenSize.width - bannerCGSize.width) / 2.0;
  frame.origin.y = screenSize.height - bannerCGSize.height;
  adView_.frame = frame;
  if (adView_.hidden) {
    adView_.hidden = NO;
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}

- (void)dealloc {
  sizeTableView_.dataSource = nil;
  sizeTableView_.delegate = nil;
  [sizeTableView_ release];

  adView_.delegate = nil;
  [adView_ release];

  bannerSizes_.delegate = nil;
  [bannerSizes_ release];

  [super dealloc];
}

#pragma mark UITableView delegate methods

// Returns the currently selected BannerSize's GADAdSize to load.
- (GADAdSize)selectedBannerSize {
  NSInteger index =
      [[self.sizeTableView indexPathForSelectedRow] indexAtPosition:1];
  return [self.bannerSizes sizeForBannerSizeAtIndex:index];
}

// Whenever the user selects a BannerSize, hide the stale adView,
// resize it to inform the SDK of the desired format, center it at the bottom
// of the display and load a generic GADRequest.
- (void)tableView:(UITableView *)sender
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  adView_.hidden = YES;
  adView_.adSize = [self selectedBannerSize];
  [self layoutGADBannerView];
  [adView_ loadRequest:[AdCatalogUtilities adRequest]];
}

#pragma mark GADBannerView callback methods

// Now that the ad's been loaded make it visible.
- (void)adViewDidReceiveAd:(GADBannerView *)view {
  adView_.hidden = NO;
}

- (void)adView:(GADBannerView *)view
    didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"Failed to receive banner ad.");
}

#pragma mark BannerSizes delegate methods

// The data source for the table changed the entries so we have to reload the
// tableview.
- (void)bannerSizesChanged {
  [self.sizeTableView reloadData];
  adView_.hidden = YES;
}

@end
