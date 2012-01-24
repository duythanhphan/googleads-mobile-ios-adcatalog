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

- (void)animateTransitionFromView:(UIView *)fromView toView:(UIView *)toView;

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;
- (void)gameLevelEndButtonAction:(GameLevelController *)sender;
- (void)presentationDidBegin;
- (void)presentationDidEnd;
- (void)presentationDidFailWithError:(GADRequestError *)requestError;
- (void)presentInterstitial;
- (void)presentationWillEnd;

@end

@implementation GameController

// For demonstration purposes the game transitions between levels and between
// level and interstitial with a fade. This method simply encapsulates that
// fade as a generic operation between two views. The toView is passed as the
// animation's context to let animationDidStop:finished:context: know which
// case it's wrapping up.
- (void)animateTransitionFromView:(UIView *)fromView toView:(UIView *)toView {
  [UIView beginAnimations:NSStringFromSelector(_cmd) context:toView];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  [UIView setAnimationDuration:0.5];
  [UIView setAnimationDelegate:self];

  toView.alpha = 1.0;
  fromView.alpha = 0.0;

  [UIView commitAnimations];
}

// If the fade that just concluded was from level zero to the receiver's
// view (black background), hide the status bar and initiate interstitial
// load. Otherwise, if the fade was to level zero so simply restart it.
-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
         context:(void *)toView {
  if (toView == self.view) {
    CGFloat statusBarHeight = [[UIApplication sharedApplication]
                                  statusBarFrame].size.height;
    [[UIApplication sharedApplication]
        setStatusBarHidden:YES
        withAnimation:UIStatusBarAnimationFade];
    // Resize and reposition view's frame to account for extra space
    CGRect frame = self.view.frame;
    frame.origin.y -= statusBarHeight;
    frame.size.height += statusBarHeight;
    self.view.frame = frame;

    [self presentInterstitial];
  } else if (toView == level0Controller_.view) {
      [level0Controller_ begin];
  }
}

- (GameLevelController *)newGameLevelControllerWithLabel:(NSString *)label
                                               imageName:(NSString *)imageName {
  GameLevelController *result = [[GameLevelController alloc] init];

  result.label = label;
  result.delegate = self;

  [result setCellImage:[UIImage imageNamed:imageName]];

  return result;
}

- (void)loadView {
  [super loadView];
  self.view.frame = [[UIScreen mainScreen] applicationFrame];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;

  level0Controller_ = [self newGameLevelControllerWithLabel:@"Level 0"
                                                  imageName:@"Level0Cell"];

  level1Controller_ = [self newGameLevelControllerWithLabel:@"Level 1"
                                                  imageName:@"Level1Cell"];

  // Keep the second level invisible until its time to for it to fade in.
  level1Controller_.view.alpha = 0.0;
  [self.view addSubview:level0Controller_.view];
  [self.view addSubview:level1Controller_.view];
}

// Initiate the fade to either the receiver's view (black background) or the
// level zero. These animations will conclude in either interstitial display
// or a new game, respectively.
- (void)nextGameLevel:(GameLevelController *)sender {
  if (sender == level0Controller_) {
    [self animateTransitionFromView:level0Controller_.view
                             toView:self.view];
  } else {
    [self animateTransitionFromView:level1Controller_.view
                             toView:level0Controller_.view];
  }
}

// Now that the interstitial has taken over the screen, slip level one in
// behind it and make it visible.
- (void)presentationDidBegin {
  [self.view sendSubviewToBack:level1Controller_.view];
  level1Controller_.view.alpha = 1.0;
  [super presentationDidBegin];
}

// Now that the interstitial's no longer on-screen and the status bar's been
// restored, adjust level one's frame to respect this and start it.
- (void)presentationDidEnd {
  [level1Controller_ begin];

  [super presentationDidEnd];
}

// If interstitial load failed, fade the next level in over (not from) the
// displayed black background. The frame of view will be adjusted for the
// status bar once it's been restored in presentationWillEnd.
- (void)presentationDidFailWithError:(GADRequestError *)requestError {
  [self animateTransitionFromView:nil
                           toView:level1Controller_.view];

  [super presentationDidFailWithError:requestError];
}

// For timing purposes start fading the status bar back in now rather than
// once the interstitial's already gone.
- (void)presentationWillEnd {
  [[UIApplication sharedApplication]
      setStatusBarHidden:NO
      withAnimation:UIStatusBarAnimationFade];

  // Resize and reposition our view to account for the space consumed by the
  // status bar
  CGFloat statusBarHeight = [[UIApplication sharedApplication]
                                statusBarFrame].size.height;
  CGRect frame = self.view.frame;
  frame.origin.y += statusBarHeight;
  frame.size.height -= statusBarHeight;
  self.view.frame = frame;

  [super presentationWillEnd];
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

  if (level1Controller_.view.alpha < 1.0) {
    [level0Controller_ begin];
  }
}

@end
