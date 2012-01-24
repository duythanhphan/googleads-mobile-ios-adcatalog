// InterstitialRootController.m
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

#import "InterstitialRootController.h"
#import "SampleConstants.h"

// The controller's view is a trivial black backdrop with an activity indicator
// which spins until the ad can actually be displayed. Its main purpose is to
// serve as a convenient container for animated views preceding and following
// the ad, as they must share a root controller.

@interface InterstitialRootView : UIView {
  InterstitialRootController *controller_;
  UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (id)initWithController:(InterstitialRootController *)controller;

@end


@interface InterstitialRootController (Private)

- (GADInterstitial *)interstitial;
- (void)releaseInterstitial;

@end

@implementation InterstitialRootView

@synthesize activityIndicator;

- (id)initWithController:(InterstitialRootController *)controller {
  if ((self = [super initWithFrame:CGRectZero])) {
    controller_ = controller;
    self.backgroundColor = [UIColor blackColor];

    activityIndicator =
        [[UIActivityIndicatorView alloc]
          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    [self addSubview:activityIndicator];
    [activityIndicator release];
  }

  return self;
}

- (void)layoutSubviews {
  CGSize size = self.frame.size;

  activityIndicator.frame =
    CGRectMake((size.width / 2.0) -
               (activityIndicator.frame.size.width / 2.0),
               (size.height / 2.0) -
               (activityIndicator.frame.size.height / 2.0),
               activityIndicator.frame.size.width,
               activityIndicator.frame.size.height);
}

@end

@implementation InterstitialRootController

@synthesize adUnitID = adUnitID_;
@synthesize interstitialRequest = interstitialRequest_;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    self.adUnitID = INTERSTITIAL_AD_UNIT_ID;
    self.interstitialRequest = [GADRequest request];
    self.interstitialRequest.testDevices =
        [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
  }
  return self;
}

- (void)alertView:(UIAlertView *)alertView
    didDismissWithButtonIndex:(NSInteger)buttonIndex {
  [((InterstitialRootView *)self.view).activityIndicator stopAnimating];
  [self presentationWillEnd];
  [self presentationDidEnd];

}

- (void)dealloc {
  [adUnitID_ release];
  [interstitialRequest_ release];

  [self releaseInterstitial];

  [super dealloc];
}

- (GADInterstitial *)interstitial {
  if (!interstitial_) {
    interstitial_ = [[GADInterstitial alloc] init];

    interstitial_.adUnitID = self.adUnitID;
    interstitial_.delegate = self;
  }

  return interstitial_;
}

- (void)presentationDidEnd {
  isPresenting_ = NO;
  [self releaseInterstitial];
}

- (void)presentationDidFailWithError:(GADRequestError *)error {
  UIAlertView *alertView = [[UIAlertView alloc]
                            initWithTitle:@"GADRequestError"
                            message:[error localizedDescription]
                            delegate:self
                            cancelButtonTitle:@"Drat"
                            otherButtonTitles:nil];

  [[alertView autorelease] show];
}

// GADInterstitialDelegate method which the receiver recasts into
// presentationDidFailWithError: (overload that instead).
- (void)interstitial:(GADInterstitial *)interstitial
    didFailToReceiveAdWithError:(GADRequestError *)error {
  [self presentationDidFailWithError:error];
}

// GADInterstitialDelegate method which the receiver recasts into
// presentationDidEnd: (overload that instead).
- (void)interstitialDidDismissScreen:(GADInterstitial *)sender {
  [self presentationDidEnd];
}

// GADInterstitialDelegate method used to stop the activity indicator and
// present the interstitial on-screen.
- (void)interstitialDidReceiveAd:(GADInterstitial *)sender {
  [interstitial_ presentFromRootViewController:self];
  [((InterstitialRootView *)self.view).activityIndicator stopAnimating];
}

- (void)loadView {
  self.view =
      [[[InterstitialRootView alloc] initWithController:self] autorelease];
}

// Initiates the request and presentation process. The activity indicator
// spins until either the ad is ready or the request fails.
- (void)presentInterstitial {
  [((InterstitialRootView *)self.view).activityIndicator startAnimating];
  [[self interstitial] loadRequest:self.interstitialRequest];
  isPresenting_ = YES;
}

// Interstitial lifecycle event hook. See header for further description.
- (void)presentationDidBegin {
}

// Interstitial lifecycle event hook. See header for further description.
- (void)presentationWillEnd {
}

- (void)releaseInterstitial {
  interstitial_.delegate = nil;
  [interstitial_ release];
  interstitial_ = nil;
}

// UIViewController hook used to generate presentationDidBegin, indicating
// that the interstitial is now fully on-screen.
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  if (isPresenting_) {
    [self presentationDidBegin];
  }
}

// If the view has been destroyed also free up the interstitial.
- (void)viewDidUnload {
  [self releaseInterstitial];
  [super viewDidUnload];
}


// UIViewController hook used to generate presentationWillEnd, indicating
// that the interstitial is now on its way off-screen.
- (void)viewWillAppear:(BOOL)animated {
  if (isPresenting_) {
    [self presentationWillEnd];
  }
  [super viewWillAppear:animated];
}

@end
