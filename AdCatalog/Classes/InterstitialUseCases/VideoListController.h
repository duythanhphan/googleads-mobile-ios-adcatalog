// VideoListController.h
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

#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
#import "VideoController.h"
#import "Movies.h"

// Manages a UITableView of video clips and the right-to-left
// UINavigationController-style animation of each clip being loaded.
@interface VideoListController : UIViewController <UITableViewDelegate> {
}

@property(nonatomic, retain) IBOutlet UIView *controlGroupView;
@property(nonatomic, retain) VideoController *videoController;
@property(nonatomic, retain) IBOutlet UITableView *videoTableView;
@property(nonatomic, retain) Movies *movies;

- (void)presentationDidEnd;
- (IBAction)done:(id)sender;
- (void)videoDidEnd;

@end
