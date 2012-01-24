// AdTypes.m
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

#import "AdTypes.h"
#import "BannerCatalogController.h"
#import "InterstitialCatalogController.h"

@implementation AdType

@synthesize controllerClass = controllerClass_;
@synthesize title = title_;

#pragma mark AdType methods
+ (AdType *)adTypeWithTitle:(NSString *)title
            controllerClass:(Class)controllerClass {
  AdType *result = [[[AdType alloc] init] autorelease];
  result.title = title;
  result.controllerClass = controllerClass;
  return result;
}

- (void)dealloc {
  [title_ release];
  [super dealloc];
}

@end


#pragma mark -
@implementation AdTypes

@synthesize values = values_;

#pragma mark AdTypes methods
+ (AdTypes *)singleton {
  static AdTypes *result = nil;

  if (!result) {
    result = [[AdTypes alloc] init];
    NSMutableArray *adTypes = [NSMutableArray array];
    [adTypes addObject:[AdType
        adTypeWithTitle:@"Banners"
        controllerClass:[BannerCatalogController class]]];
    [adTypes addObject:[AdType
        adTypeWithTitle:@"Interstitials"
        controllerClass:[InterstitialCatalogController class]]];
    result.values = adTypes;
  }
  return result;
}

- (Class)classForAdTypeAtIndex:(NSUInteger)index {
  AdType *adType = [self.values objectAtIndex:index];
  return adType.controllerClass;
}

- (void)dealloc {
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

  InterstitialUseCase *useCase =
      [self.values objectAtIndex:[indexPath indexAtPosition:1]];
  result.textLabel.text = useCase.title;
  return result;
}

- (NSInteger)tableView:(UITableView *)sender
    numberOfRowsInSection:(NSInteger)section {
  return [self.values count];
}

@end
