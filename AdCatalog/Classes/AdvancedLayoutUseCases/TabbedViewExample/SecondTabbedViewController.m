// SecondTabbedViewController.m
// Copyright 2012 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "SecondTabbedViewController.h"

@implementation SecondTabbedViewController

@synthesize textView = textView_;
@synthesize label = label_;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Second", @"Second");
    self.tabBarItem.image = [UIImage imageNamed:@"SecondTabIcon"];
  }
  return self;
}

- (void)dealloc {
  [textView_ release];
  [label_ release];
  [super dealloc];
}

#pragma mark - UITabBarControllerDelegate implementation

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  NSLog(@"SecondTab: Received ad successfully.");
}

- (void)adView:(GADBannerView *)view
    didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"SecondTab: Failed to receive ad with error: %@.",
        [error localizedFailureReason]);
}

@end
