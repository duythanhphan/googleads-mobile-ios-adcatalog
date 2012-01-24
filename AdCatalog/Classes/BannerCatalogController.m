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

#import "BannerCatalogController.h"
#import "SampleConstants.h"


@interface BannerCatalogController (Private)

- (CGSize)selectedBannerSize;

@end

@implementation BannerCatalogController

@synthesize sizeTableView = sizeTableView_;
@synthesize bannerSizes = bannerSizes_;

#pragma mark BannerCatalogController methods
// BannerCatalogController is the sizeTableView_'s delegate for input events and
// the BannerSizes singleton is its datasource.
- (void)viewDidLoad {
  self.bannerSizes = [BannerSizes singleton];
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

- (void)dealloc {
  sizeTableView_.dataSource = nil;
  sizeTableView_.delegate = nil;
  [sizeTableView_ release];

  adView_.delegate = nil;
  [adView_ release];

  [bannerSizes_ release];

  [super dealloc];
}

#pragma mark UITableView delegate methods
// Returns the currently selected BannerSize's CGSize to load.
- (CGSize)selectedBannerSize {
  NSInteger index =
      [[self.sizeTableView indexPathForSelectedRow] indexAtPosition:1];
  return [self.bannerSizes sizeForBannerSizeAtIndex:index];
}

// Whenever the user selects a BannerSize, hide the stale adView,
// resize it to inform the SDK of the desired format, center it at the bottom
// of the display and load a generic GADRequest.
- (void)tableView:(UITableView *)sender
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGSize bannerSize = [self selectedBannerSize];

  adView_.hidden = YES;

  // Resize the adView frame per the selected banner's dimensions.
  CGRect frame = adView_.frame;
  frame.size = bannerSize;
  // Set its x,y origin such that the banner is centered at the bottom of the
  // screen.
  frame.origin.x = (self.view.frame.size.width - bannerSize.width) / 2.0;
  frame.origin.y = self.view.frame.size.height - bannerSize.height;

  // Move it up a bit to give the banner a nice "framed" look.
  if (CGSizeEqualToSize(bannerSize, GAD_SIZE_300x250)) {
    frame.origin.y -= frame.origin.x;
  }
  adView_.frame = frame;

  GADRequest *request = [GADRequest request];
  request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];

  [adView_ loadRequest:request];
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

@end
