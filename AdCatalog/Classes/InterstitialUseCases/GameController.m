// GameController.m
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

#import <QuartzCore/QuartzCore.h>
#import "GameController.h"

@interface GameController (Private)

- (GameLevelController *)newGameLevelControllerWithLabel:(NSString *)label
                                               imageName:(NSString *)imageName;
- (void)completeGameLevel:(GameLevelController *)gameLevel;
- (void)presentGameLevel:(GameLevelController *)gameLevel;
- (void)initGameWithLevels;

@end

@implementation GameController

  GameLevelController *firstGameLevel_;

- (GameLevelController *)newGameLevelControllerWithLabel:(NSString *)label
                                               imageName:(NSString *)imageName {
  GameLevelController *result =
      [[[GameLevelController alloc] init] autorelease];
  result.label = label;
  [result setCellImage:[UIImage imageNamed:imageName]];

  return result;
}

- (void)addGameLeveController:(GameLevelController *)levelController {
  if (!firstGameLevel_) {
    firstGameLevel_ = levelController;
  }
  levelController.delegate = self;
  levelController.view.frame = self.view.bounds;
  [self addChildViewController:levelController];
}

- (void)initGameWithLevels {
  // Just add two levels for this example, but can easily add more
  // if we want.
  firstGameLevel_ = nil;
  [self addGameLeveController:
      [self newGameLevelControllerWithLabel:@"Level 0"
                                  imageName:@"Level0Cell"]];
  [self addGameLeveController:
      [self newGameLevelControllerWithLabel:@"Level 1"
                                  imageName:@"Level1Cell"]];
}

- (void)loadView {
  [super loadView];
  self.view.frame = [[UIScreen mainScreen] bounds];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  [self initGameWithLevels];
}

// Initiate the fade to either the receiver's view (black background) or the
// level zero. These animations will conclude in either interstitial display
// or a new game, respectively.
- (void)nextGameLevel:(GameLevelController *)sender {
  [self completeGameLevel:sender];
  if ([self.childViewControllers count] > 0) {
    [self presentInterstitial];
  } else {
    // Start a new game by adding the levels again.
    [self initGameWithLevels];
    [self presentGameLevel:firstGameLevel_];
    [firstGameLevel_ begin];
  }
}

// Now that the interstitial has taken over the screen, slip next level in
// behind it and make it visible.
- (void)presentationDidBegin {
  if ([self.childViewControllers count] > 0) {
    [self presentGameLevel:[self.childViewControllers objectAtIndex:0]];
  }
  [super presentationDidBegin];
}

// Now that the interstitial's no longer on-screen, adjust level one's frame
// to respect this and start it.
- (void)presentationDidEnd {
  if ([self.childViewControllers count] > 0) {
    [[self.childViewControllers objectAtIndex:0] begin];
  }
  [super presentationDidEnd];
}

// If interstitial load failed, fade the next level in over (not from) the
// displayed black background. The frame of view will be adjusted once it's
// been restored in presentationWillEnd.
- (void)presentationDidFailWithError:(GADRequestError *)requestError {
  if ([self.childViewControllers count] > 0) {
    [self presentGameLevel:[self.childViewControllers objectAtIndex:0]];
  }
  [super presentationDidFailWithError:requestError];
}

// When the user's done with this use case simply pop back out to the
// InterstitialCatalogController.
- (void)doneWithGameLevel:(GameLevelController *)sender {
  [self dismissModalViewControllerAnimated:YES];
}

// If the receiver's view is appearing for the very first time (as opposed
// to because the interstitial has ended) begin level.
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if ([self.childViewControllers count] > 0) {
    if ([self.childViewControllers objectAtIndex:0] == firstGameLevel_) {
      [firstGameLevel_ begin];
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if ([self.childViewControllers count] > 0) {
    if ([self.childViewControllers objectAtIndex:0] == firstGameLevel_) {
      // Load the view so that the transition to the first level doesn't
      // go to a black screen mid-transition.
      [self presentGameLevel:firstGameLevel_];
    }
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}

// Forward all of the orientation change events to the child view controller
// currently being presented.
- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
  return YES;
}

- (void)completeGameLevel:(GameLevelController *)gameLevel {
  if ([self.childViewControllers containsObject:gameLevel]) {
    [gameLevel willMoveToParentViewController:nil];
    [gameLevel.view removeFromSuperview];
    [gameLevel removeFromParentViewController];
  }
}

- (void)presentGameLevel:(GameLevelController *)gameLevel {
  if ([self.childViewControllers containsObject:gameLevel]) {
    [self.view addSubview:gameLevel.view];
    [gameLevel didMoveToParentViewController:self];
  }
}

@end
