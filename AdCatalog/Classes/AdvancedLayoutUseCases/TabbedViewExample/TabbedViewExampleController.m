// TabbedViewExampleController.m
// Copyright 2012 Google Inc.
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

#import "AdCatalogUtilities.h"
#import "GADBannerView.h"
#import "FirstTabbedViewController.h"
#import "SampleConstants.h"
#import "SecondTabbedViewController.h"
#import "TabbedViewExampleController.h"

@interface TabbedViewExampleController (Private)

- (void)layoutGADBannerView;

@end

@implementation TabbedViewExampleController

@synthesize tabBarController = tabBarController_;
@synthesize navBar = navBar_;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Do any additional setup after loading the view from its nib.
    UIViewController *viewController1 =
        [[[FirstTabbedViewController alloc]
          initWithNibName:@"FirstTabbedViewController"
                   bundle:nil] autorelease];
    UIViewController *viewController2 =
        [[[SecondTabbedViewController alloc]
          initWithNibName:@"SecondTabbedViewController"
                   bundle:nil] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             viewController1,
                                             viewController2,
                                             nil];
    self.tabBarController.delegate = self;
    [self.view addSubview:self.tabBarController.view];

    // Since banner is initialized in this block, you will only have one banner
    // throughout the tabbed view.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.rootViewController = self;
    bannerView_.adUnitID = BANNER_AD_UNIT_ID;
    [bannerView_ loadRequest:[AdCatalogUtilities adRequest]];

    // Have to set the initial view controller for the ad since the
    // UITabBarControllerDelegate method will not get called.
    bannerView_.delegate = (id<GADBannerViewDelegate>) viewController1;
    [viewController1.view addSubview:bannerView_];
  }
  return self;
}

- (void)layoutGADBannerView {
  // Resize the adView frame and place it in the middle of the screen.
  CGRect frame = bannerView_.frame;
  frame.origin.x = (self.view.bounds.size.width - bannerView_.frame.size.width)
                        / 2.0;
  bannerView_.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // Change the frame here because in init:, sizes for the navBar aren't
  // available yet.
  self.tabBarController.view.frame =
      CGRectMake(0,
                 self.navBar.frame.size.height,
                 self.view.frame.size.width,
                 self.view.frame.size.height - self.navBar.frame.size.height);
  [self layoutGADBannerView];
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

- (void)dealloc {
  bannerView_.delegate = nil;
  [bannerView_ release];
  [tabBarController_ release];
  [navBar_ release];
  [super dealloc];
}

// When the user's done simply pop back out to MainController.
- (IBAction)done:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITabBarControllerDelegate implementation

// Every time the user selects a new tab, we need to update the new view
// controller shown to be the delegate for the adView, as well as add the adView
// into the hierarchy of the new view being shown.
- (void)tabBarController:(UITabBarController *)tabBarController
    didSelectViewController:(UIViewController *)viewController {
  if ([viewController conformsToProtocol:@protocol(GADBannerViewDelegate)]) {
    bannerView_.delegate = (id<GADBannerViewDelegate>) viewController;
  }
  else {
    NSLog(@"Warning: The selected view controller will not be able to listen "
          @"to ad events because it does not conform to the "
          @"GADBannerViewDelegate protocol.");
  }
  // Don't need to confrom to GADBannerViewDelegate to have a GADBanner in view
  // hierarchy.
  [viewController.view addSubview:bannerView_];
  [self layoutGADBannerView];
}

@end
