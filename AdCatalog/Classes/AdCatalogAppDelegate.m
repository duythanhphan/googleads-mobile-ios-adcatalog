// AdCatalogAppDelegate.m
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

#import <AdSupport/ASIdentifierManager.h>

#import "AdCatalogAppDelegate.h"
#import "AdCatalogUtilities.h"
#import "MainController.h"
#import "SampleConstants.h"

static NSString * const kDefaultsKeyShouldShowSplashInterstitial =
    @"shouldShowSplashInterstitial";
static NSString * const kDefaultsKeyShouldShowTestAds = @"shouldShowTestAds";

@implementation AdCatalogAppDelegate

@synthesize viewController = viewController_;
@synthesize window = window_;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Print IDFA (from AdSupport Framework) for iOS 6 and UDID for iOS < 6.
  if (NSClassFromString(@"ASIdentifierManager")) {
    NSLog(@"GoogleAdMobAdsSDK ID for testing: %@" ,
              [[[ASIdentifierManager sharedManager]
                  advertisingIdentifier] UUIDString]);
  } else {
    NSLog(@"GoogleAdMobAdsSDK ID for testing: %@" ,
              [[UIDevice currentDevice] uniqueIdentifier]);
  }

  [self.window setRootViewController:self.viewController];
  [self.window makeKeyAndVisible];

  // If the user's switched on the splash interstitial via
  // InterstitialCatalogController fire it up using the SDK's
  // use-case-specific API.

  if (self.shouldShowSplashInterstitial) {
    splashInterstitial_ = [[GADInterstitial alloc] init];

    splashInterstitial_.adUnitID = self.interstitialAdUnitID;
    splashInterstitial_.delegate = self;

    GADRequest *request = [AdCatalogUtilities adRequest];

    UIImage *image = [UIImage imageNamed:@"InitialImage"];

    [splashInterstitial_ loadAndDisplayRequest:request
                                   usingWindow:self.window
                                  initialImage:image];
  }

  return YES;
}

- (void)dealloc {
  splashInterstitial_.delegate = nil;
  [splashInterstitial_ release];
  [viewController_ release];
  [window_ release];

  [super dealloc];
}

// Alert the user if the splash interstitial fails to load.
- (void)interstitial:(GADInterstitial *)sender
    didFailToReceiveAdWithError:(GADRequestError *)error {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"GADRequestError"
                               message:[error localizedDescription]
                               delegate:nil
                               cancelButtonTitle:@"Drat"
                               otherButtonTitles:nil];

  [[alertView autorelease] show];
}

- (NSString *)interstitialAdUnitID {
  return INTERSTITIAL_AD_UNIT_ID;
}

// Updates the NSUserDefault flagging whether the user wants an interstitial
// at launch, a property read and written by InterstitialCatalogController.
- (void)setShouldShowSplashInterstitial:(BOOL)shouldShowSplashInterstitial {
  [[NSUserDefaults standardUserDefaults]
      setBool:shouldShowSplashInterstitial
       forKey:kDefaultsKeyShouldShowSplashInterstitial];

  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldShowSplashInterstitial {
  return [[NSUserDefaults standardUserDefaults]
             boolForKey:kDefaultsKeyShouldShowSplashInterstitial];
}

// Updates the NSUserDefault flagging whether the user wants to display test
// ads.
- (void)setShouldShowTestAds:(BOOL)shouldShowTestAds {
  [[NSUserDefaults standardUserDefaults]
      setBool:shouldShowTestAds
       forKey:kDefaultsKeyShouldShowTestAds];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldShowTestAds {
  return [[NSUserDefaults standardUserDefaults]
             boolForKey:kDefaultsKeyShouldShowTestAds];
}

@end
