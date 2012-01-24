// InterstitialUseCases.m
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

#import "GameController.h"
#import "InterstitialUseCases.h"
#import "VideoListController.h"


@implementation InterstitialUseCase

@synthesize controllerClass = controllerClass_;
@synthesize title = title_;

#pragma mark InterstitialUseCase methods
+ (InterstitialUseCase *)interstitialUseCaseWithTitle:(NSString *)title
                                      controllerClass:(Class)controllerClass {
  InterstitialUseCase *result =
      [[[InterstitialUseCase alloc] init] autorelease];
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
@implementation InterstitialUseCases

@synthesize title = title_;
@synthesize values = values_;

#pragma mark NewInterstitialUseCases methods
+ (InterstitialUseCases *)singleton {
  static InterstitialUseCases *result = nil;

  if (!result) {
    result = [[InterstitialUseCases alloc] init];
    result.title = @"Use Cases";

    NSMutableArray *useCases = [NSMutableArray array];
    [useCases addObject:[InterstitialUseCase
        interstitialUseCaseWithTitle:@"Basic"
        controllerClass:nil]];
    [useCases addObject:[InterstitialUseCase
        interstitialUseCaseWithTitle:@"Game Levels"
        controllerClass:[GameController class]]];
    [useCases addObject:[InterstitialUseCase
        interstitialUseCaseWithTitle:@"Video Pre-Roll"
        controllerClass:[VideoListController class]]];
    result.values = useCases;
  }
  return result;
}

- (Class)classForUseCaseAtIndex:(NSUInteger)index {
  InterstitialUseCase *useCase = [self.values objectAtIndex:index];
  return useCase.controllerClass;
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

  InterstitialUseCase *useCase =
      [self.values objectAtIndex:[indexPath indexAtPosition:1]];
  result.textLabel.text = useCase.title;
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
