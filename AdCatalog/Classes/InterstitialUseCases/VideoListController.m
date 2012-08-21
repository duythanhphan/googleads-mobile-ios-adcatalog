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

- (void)setVideoControllerHidden:(BOOL)isHidden;
- (void)updateViewFrameForStatusBarDisplay;

@end

@implementation VideoListController

@synthesize controlGroupView = controlGroupView_;
@synthesize videoController = videoController_;
@synthesize videoTableView = videoTableView_;
@synthesize movies = movies_;

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

// Either slides videoController in from the right (YES) or controlGroup_ in
// from the left (NO) as dictated by isHidden.
- (void)setVideoControllerHidden:(BOOL)isHidden {
  if (!isHidden) {
    [self addChildViewController:self.videoController];
    self.videoController.view.hidden = NO;
    self.videoController.view.frame = self.view.bounds;
    [UIView transitionWithView:self.view
                      duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                      self.controlGroupView.hidden = YES;
                      [self.view addSubview:self.videoController.view];
                    } completion:^(BOOL finished){
                      [self.videoController didMoveToParentViewController:self];
                      NSUInteger selectionIndex =
                          [[self.videoTableView indexPathForSelectedRow]
                              indexAtPosition:1];
                      NSURL *url =
                          [self.movies urlForMovieAtIndex:selectionIndex];
                      [self.videoController playVideoWithURL:url];
                    }];
  } else {
    if (![UIApplication sharedApplication].statusBarHidden) {
      [self updateViewFrameForStatusBarDisplay];
    }
    self.controlGroupView.frame = self.view.bounds;
    [UIView transitionWithView:self.view
                      duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                      self.videoController.view.hidden = YES;
                      self.controlGroupView.hidden = NO;
                    } completion:^(BOOL finished) {
                      [self.videoController wasHidden];
                      [self.videoController willMoveToParentViewController:nil];
                      [self.videoController.view removeFromSuperview];
                      [self.videoController removeFromParentViewController];
                    }];
  }
}

- (void)updateViewFrameForStatusBarDisplay {
  CGRect tempFrame = self.view.frame;
  if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
    tempFrame.origin.y +=
        [UIApplication sharedApplication].statusBarFrame.size.height;
  } else if (self.interfaceOrientation ==
                UIInterfaceOrientationPortraitUpsideDown) {
    tempFrame.origin.y -=
        [UIApplication sharedApplication].statusBarFrame.size.height;
  } else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
    tempFrame.origin.x +=
        [UIApplication sharedApplication].statusBarFrame.size.width;
  } else if (self.interfaceOrientation ==
                UIInterfaceOrientationLandscapeRight) {
    tempFrame.origin.x -=
        [UIApplication sharedApplication].statusBarFrame.size.width;
  }
  self.view.frame = tempFrame;
}

// When a video's selected add the videoController to the hierarchy stage
// right and animate it in (the inverse of presentation/videoDidEnd).
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
  self.movies = [[[MovieDataSource alloc] init] autorelease];
  self.videoTableView.dataSource = self.movies;
  self.videoTableView.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
  return YES;
}

@end
