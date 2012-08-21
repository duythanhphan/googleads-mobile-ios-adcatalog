// BannerSizeDataSource.m
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

#import "BannerSize.h"
#import "BannerSizeDataSource.h"
#import "GADBannerView.h"

#pragma mark -

@implementation BannerSizeDataSource

@synthesize title = title_;
@synthesize values = values_;
@synthesize delegate = delegate_;

#pragma mark BannerSizeDataSource methods

- (id)init{
  if (self = [super init]) {
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[BannerSize instanceWithTitle:@"Banner"
                                               size:kGADAdSizeBanner]];
    // These ad types should only be displayed on the iPad.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      [values addObject:
          [BannerSize instanceWithTitle:@"Medium Rectangle"
                                   size:kGADAdSizeMediumRectangle]];
      [values addObject:[BannerSize instanceWithTitle:@"Full Banner"
                                                 size:kGADAdSizeFullBanner]];
      [values addObject:[BannerSize instanceWithTitle:@"Leaderboard"
                                                 size:kGADAdSizeLeaderboard]];
      [values addObject:[BannerSize instanceWithTitle:@"Skyscraper"
                                                 size:kGADAdSizeSkyscraper]];
    }
    UIInterfaceOrientation currentOrientation =
        [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
      [values addObject:
          [BannerSize instanceWithTitle:@"Smart Banner - Portrait"
                                   size:kGADAdSizeSmartBannerPortrait]];
    } else {
      [values addObject:
          [BannerSize instanceWithTitle:@"Smart Banner - Landscape"
                                   size:kGADAdSizeSmartBannerLandscape]];
    }
    self.title = @"Sizes";
    self.values = values;

    // Listen to orientation events to handle changing the table view entry for
    // portrait vs landscape smart banners.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(deviceOrientationDidChange:)
               name:UIDeviceOrientationDidChangeNotification
             object:nil];
  }
  return self;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  // Ignoring specific orientations we don't care about.
  if (orientation == UIDeviceOrientationFaceUp ||
      orientation == UIDeviceOrientationFaceDown ||
      orientation == UIDeviceOrientationUnknown) {
    return;
  }
  // On orientation changes we do care about, remove the Smart Banner entry and
  // replace it with the Smart Banner entry correct for the orientation we are
  // in.
  for (BannerSize *value in values_) {
    if ((GADAdSizeEqualToSize(value.size, kGADAdSizeSmartBannerLandscape)) ||
        (GADAdSizeEqualToSize(value.size, kGADAdSizeSmartBannerPortrait))) {
      [values_ removeObject:value];
      if (UIInterfaceOrientationIsLandscape(orientation)) {
        [values_ addObject:
            [BannerSize instanceWithTitle:@"Smart Banner - Landscape"
                                     size:kGADAdSizeSmartBannerLandscape]];
      } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        [values_ addObject:
            [BannerSize instanceWithTitle:@"Smart Banner - Portrait"
                                     size:kGADAdSizeSmartBannerPortrait]];
      }
      [delegate_ performSelector:@selector(bannerSizesChanged)];
    }
  }
}

- (GADAdSize)sizeForBannerSizeAtIndex:(NSUInteger)index {
  BannerSize *bannerSize = [self.values objectAtIndex:index];
  return bannerSize.size;
}

- (void)dealloc {
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [title_ release];
  [values_ release];
  [super dealloc];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *identifier = NSStringFromClass([self class]);
  UITableViewCell *result =
      [sender dequeueReusableCellWithIdentifier:identifier];
  if (!result) {
    result =
        [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:identifier] autorelease];
  }

  BannerSize *bannerSize =
      [self.values objectAtIndex:[indexPath indexAtPosition:1]];
  result.textLabel.text = bannerSize.title;
  return result;
}

- (NSInteger)tableView:(UITableView *)sender
    numberOfRowsInSection:(NSInteger)section {
  return [self.values count];
}

- (NSString *)tableView:(UITableView *)sender
    titleForHeaderInSection:(NSInteger)section {
  return self.title;
}

@end
