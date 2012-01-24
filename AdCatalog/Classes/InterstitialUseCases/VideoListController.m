// VideoListController.m
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
#import "VideoListController.h"

@interface VideoListController (Private)

-(void)animationDidStop:(CAAnimation *)animation
               finished:(BOOL)flag
                context:(void *)isVideoControllerHidden;
- (NSArray *)bundledVideoURLs;
- (void)setVideoControllerHidden:(BOOL)isHidden;

@end

@implementation VideoListController

@synthesize controlGroupView = controlGroupView_;
@synthesize videoController = videoController_;
@synthesize videoTableView = videoTableView_;
@synthesize movies = movies_;

// The VideoListController's view is a UIView acting as a control group for
// a UINavigationBar, a UITableView and a UIToolbar (this simplifies animating
// all three). When a table row is selected, VideoListController reproduces
// the left-to-right animation of a UINavigationController, bringing its
// InterstitialRootController subclass VideoController in from stage right.
// This slow-transitioning animation requires a little extra coordination
// between these two controllers to assure neither of their views is
// torn-down or otherwise invalidated before the transition's complete.
-(void)animationDidStop:(CAAnimation *)animation
               finished:(BOOL)flag
                context:(void *)isVideoControllerHidden {
  // Now that the VideoController's completely off-screen, let it know it's
  // fully hidden and remove it from the view hierarchy.
  if (isVideoControllerHidden) {
    [self.videoController wasHidden];
    [self.videoController.view removeFromSuperview];
  } else {
    // Now that the VideoController's fully on-screen initiate playback and
    // remove the control group from the hierarchy, making VideoController
    // the root.
    NSUInteger selectionIndex =
        [[self.videoTableView indexPathForSelectedRow] indexAtPosition:1];
    NSURL *url = [self.movies urlForMovieAtIndex:selectionIndex];
    [self.videoController playVideoWithURL:url];

    [self.view removeFromSuperview];
  }
}

- (void)dealloc {
  [controlGroupView_ release];
  [videoController_ release];

  videoTableView_.delegate = nil;
  [videoTableView_ release];
  [movies_ release];

  [super dealloc];
}

// When the user's done with this use case simply pop back out to the
// InterstitialCatalogController.
- (IBAction)done:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundleName {
  if ((self = [super initWithNibName:nibName bundle:bundleName])) {
    self.videoController =
        [[[VideoController alloc] initWithListController:self] autorelease];
  }

  return self;
}

// When this hook is invoked by videoController the interstitial's been
// dismissed and the player is full-screen. Take this opportunity to slip
// the receiver's view back into the hierarchy behind it in preparation
// for subsequent left-to-right animation.
- (void)presentationDidEnd {
  self.view.hidden = YES;
  [self.videoController.view.window addSubview:self.view];
  [self.videoController.view.window sendSubviewToBack:self.view];
  self.view.hidden = NO;
}

// Either slides videoController in from the right (YES) or controlGroup_ in
// from the left (NO) as dictated by isHidden.
- (void)setVideoControllerHidden:(BOOL)isHidden {
  [UIView beginAnimations:NSStringFromSelector(_cmd)
                  context:(void *)(long)isHidden];

  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.50];
  [UIView setAnimationDelegate:self];

  CGFloat xMotion =
      [UIScreen mainScreen].bounds.size.width * ((isHidden) ? 1.0 : -1.0);

  self.videoController.view.frame =
      CGRectOffset(self.videoController.view.frame, xMotion, 0.0);

  self.controlGroupView.frame = CGRectOffset(self.controlGroupView.frame,
                                             xMotion, 0.0);
  [UIView commitAnimations];
}

// When a video's selected add the videoController to the hierarchy stage
// right and animate it in (the inverse of presentation/videoDidEnd).
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CGRect screenBounds = [UIScreen mainScreen].bounds;

  self.videoController.view.frame = CGRectOffset(screenBounds,
                                                 screenBounds.size.width, 0.0);

  [[self.view superview] addSubview:self.videoController.view];
  [self setVideoControllerHidden:NO];
}

// When the user has dismissed the video, animate the hidden controlGroup_
// back in an reset the videoTableView.
- (void)videoDidEnd {
  [self setVideoControllerHidden:YES];
  [self.videoTableView reloadData];
}

// The Movies singleton is videoTableView's dataSource and the receiver is its
// delegate for input events.
- (void)viewDidLoad {
  self.movies = [Movies singleton];
  self.videoTableView.dataSource = self.movies;
  self.videoTableView.delegate = self;
}

@end
