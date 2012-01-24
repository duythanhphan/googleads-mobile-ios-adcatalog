// InterstitialCatalogController.h
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
#import "InterstitialUseCases.h"

// Manages a UITableView of InterstitialUseCases and a switch toggling
// the splash interstitial. The trivial use case is handled directly
// but the others have their own controllers.
@interface InterstitialCatalogController : UIViewController
    <GADInterstitialDelegate, UITableViewDelegate> {
  GADInterstitial *basicInterstitial_;
}

@property(nonatomic, retain) IBOutlet UITableView *useCaseTableView;
@property(nonatomic, retain) IBOutlet UISwitch *splashSwitch;
@property(nonatomic, retain) InterstitialUseCases *useCases;

- (IBAction)done:(id)sender;
- (IBAction)toggleSplash:(id)sender;

@end
