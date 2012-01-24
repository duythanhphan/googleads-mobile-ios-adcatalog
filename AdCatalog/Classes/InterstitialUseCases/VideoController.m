// VideoController.m
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
#import "VideoController.h"
#import "VideoListController.h"

@interface VideoController (Private)

- (void)presentationDidBegin;
- (void)presentationDidEnd;
- (void)presentationDidFailWithError:(GADRequestError *)requestError;
- (void)releaseMovieController;

@end

@implementation VideoController

- (void)dealloc {
  [listController_ release];
  if (moviePlayerController_ != nil) {
    [self releaseMovieController];
  }
  [super dealloc];
}

- (id)initWithListController:(VideoListController *)listController {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    listController_ = [listController retain];
    self.view.frame = [UIScreen mainScreen].bounds;
  }

  return self;
}

// Inform the super-controller that the user has dismissed the player by
// pressing "Done."
- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification {
  [listController_ videoDidEnd];
}

// Initiates "playback" by both initializing the player controller and
// kicking off the interstitial. The former's view will be added to the
// hierarchy only once the ad covers the screen (see presentationDidBegin:).
- (void)playVideoWithURL:(NSURL *)url {
  [[UIApplication sharedApplication]
      setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

  self.view.frame = [UIScreen mainScreen].bounds;

  moviePlayerController_ =
      [[MPMoviePlayerController alloc] initWithContentURL:url];
  moviePlayerController_.shouldAutoplay = FALSE;

  moviePlayerController_.view.frame = self.view.frame;

  [self presentInterstitial];
}

// Now that the interstitial's on-screen insert the player view behind it
// so it's already present as the ad is dismissed.
- (void)presentationDidBegin {
  moviePlayerController_.view.hidden = YES;

  [self.view addSubview:moviePlayerController_.view];
  [self.view sendSubviewToBack:moviePlayerController_.view];

  moviePlayerController_.view.hidden = NO;

  [super presentationDidBegin];
}

- (void)presentationDidEnd {
  moviePlayerController_.controlStyle = MPMovieControlStyleFullscreen;

  [[NSNotificationCenter defaultCenter]
      addObserver:self
      selector:@selector(moviePlayerPlaybackDidFinish:)
      name:MPMoviePlayerPlaybackDidFinishNotification
      object:moviePlayerController_];

  [UIApplication sharedApplication].statusBarStyle =
      UIStatusBarStyleBlackTranslucent;

  [moviePlayerController_ play];
  [listController_ presentationDidEnd];

  [super presentationDidEnd];
}

- (void)presentationDidFailWithError:(GADRequestError *)requestError {
  [self.view addSubview:moviePlayerController_.view];
  [super presentationDidFailWithError:requestError];
}

- (void)releaseMovieController {
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
      name:MPMoviePlayerPlaybackDidFinishNotification
      object:moviePlayerController_];

  [moviePlayerController_.view removeFromSuperview];
  [moviePlayerController_ release];

  moviePlayerController_ = nil;
}

- (void)wasHidden {
  [self releaseMovieController];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

@end
