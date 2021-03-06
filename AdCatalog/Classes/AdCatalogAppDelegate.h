// AdCatalogAppDelegate.h
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

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@class MainController;

// The app delegate simply (0) loads the MainController, (1) manages the
// splash interstitial if shouldShouldSplashInterstitial and (2) vends the
// interstitialAnUnitID also used by InterstitialUseCaseDataSource.
@interface AdCatalogAppDelegate : NSObject
    <UIApplicationDelegate, GADInterstitialDelegate> {
 @private
  GADInterstitial *splashInterstitial_;
}

@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet MainController *viewController;

@property(nonatomic, assign) BOOL shouldShowSplashInterstitial;
@property(nonatomic, assign) BOOL shouldShowTestAds;
@property(nonatomic, readonly) NSString *interstitialAdUnitID;

@end
