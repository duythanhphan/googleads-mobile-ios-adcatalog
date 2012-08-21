// OpenGLExampleController.m
// Copyright 2012 Google Inc.

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
#import "OpenGLExampleController.h"
#import "SampleConstants.h"

@interface OpenGLExampleController (Private)

- (void)layoutGADBannerView;

@end

@implementation OpenGLExampleController

@synthesize glView = glView_;

- (void)viewDidLoad {
  [super viewDidLoad];

  didReceiveFirstAd_ = NO;

  // Add the glView into the hierarchy.
  [self.view addSubview:glView_];
  [glView_ startAnimation];

  bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];

  // Make all of the ad setup necessary.
  bannerView_.adUnitID = BANNER_AD_UNIT_ID;
  bannerView_.delegate = self;
  bannerView_.rootViewController = self;
  [self.view addSubview:bannerView_];
}

- (void)viewWillAppear:(BOOL)animated {
  // Initialize the banner off the screen so that it animates up when
  // displaying.
  didReceiveFirstAd_ = NO;
  CGPoint origin =
      CGPointMake((self.view.bounds.size.width -
                      CGSizeFromGADAdSize(kGADAdSizeBanner).width) / 2.0,
                  self.view.bounds.size.height);
  bannerView_.frame = CGRectMake(origin.x,
                                 origin.y,
                                 bannerView_.frame.size.width,
                                 bannerView_.frame.size.height);
  [bannerView_ loadRequest:[AdCatalogUtilities adRequest]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInt
                                         duration:(NSTimeInterval)duration {
  [self layoutGADBannerView];
}

- (void)layoutGADBannerView {
  bannerView_.frame =
      CGRectMake((self.view.bounds.size.width - bannerView_.frame.size.width)
                    / 2.0,
                 self.view.bounds.size.height - bannerView_.frame.size.height,
                 bannerView_.frame.size.width,
                 bannerView_.frame.size.height);
}

- (void)dealloc {
  bannerView_.delegate = nil;
  [bannerView_ release];
  [glView_ stopAnimation];
  [glView_ release];
  [super dealloc];
}

#pragma mark GADBannerViewDelegate implementation

// Since we've received an ad, let's go ahead and animate it in.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  // Don't use layoutGADBannerView: for this animation since it's the first ad
  // we only need to show this animation one time.
  if (!didReceiveFirstAd_) {
    CGRect newGlFrame =
        CGRectMake(glView_.frame.origin.x,
                   glView_.frame.origin.y,
                   glView_.frame.size.width,
                   glView_.frame.size.height - bannerView_.frame.size.height);
    CGRect newAdFrame =
        CGRectMake((self.view.bounds.size.width - bannerView_.frame.size.width)
                      / 2.0,
                   self.view.bounds.size.height - bannerView_.frame.size.height,
                   bannerView_.frame.size.width,
                   bannerView_.frame.size.height);
    [UIView animateWithDuration:1.0 animations:^{
      glView_.frame = newGlFrame;
      bannerView_.frame = newAdFrame;
    }];

    // We only want the animation to happen for the first ad received
    didReceiveFirstAd_ = YES;
  }
}

- (void)adView:(GADBannerView *)view
    didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
  [glView_ stopAnimation];
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
  [glView_ startAnimation];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
  [glView_ stopAnimation];
}

// When the user's done simply pop back out to MainController.
- (IBAction)done:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end
