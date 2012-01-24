// BannerSizes.m
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

#import "BannerSizes.h"
#import "GADBannerView.h"

@implementation BannerSize

@synthesize size = size_;
@synthesize title = title_;

#pragma mark BannerSize methods
+ (BannerSize *)instanceWithTitle:(NSString *)title size:(CGSize)size {
  BannerSize *result = [[[BannerSize alloc] init] autorelease];
  result.size = size;
  result.title = title;
  return result;
}

- (void)dealloc {
  [title_ release];
  [super release];
}

@end

#pragma mark -
@implementation BannerSizes

@synthesize title = title_;
@synthesize values = values_;

#pragma mark BannerSizes methods
+ (BannerSizes *)singleton {
  static BannerSizes *result = nil;

  if (!result) {
    result = [[BannerSizes alloc] init];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[BannerSize instanceWithTitle:@"320x50"
                                               size:GAD_SIZE_320x50]];
    [values addObject:[BannerSize instanceWithTitle:@"300x250"
                                               size:GAD_SIZE_300x250]];

    result.title = @"Sizes";
    result.values = values;
  }
  return result;
}

- (CGSize)sizeForBannerSizeAtIndex:(NSUInteger)index {
  BannerSize *bannerSize = [self.values objectAtIndex:index];
  return bannerSize.size;
}

- (void)dealloc {
  [title_ release];
  [values_ release];
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
