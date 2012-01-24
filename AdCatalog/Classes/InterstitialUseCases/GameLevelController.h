// GameLevelController.h
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

#import <UIKit/UIKit.h>

// GameLevelController displays a little "pseudo-game" to give the feel of
// real-world application but beyond GameController's implementation of its
// delegate interface should simply be considered a black box with no bearing
// on SDK usage.

@class GameLevelController;

@interface GameLevelView : UIView {
  NSTimer *timer_;
  BOOL *isPopulatedCell_;
  int populatedCellCount_;
  int cellsPerRow_;
  int cellCount_;
}

@property(nonatomic, retain) UIImage *cellImage;
@property(nonatomic, retain) GameLevelController *controller;

@end

@protocol GameLevelControllerDelegate <NSObject>

- (void)nextGameLevel:(GameLevelController *)sender;
- (void)doneWithGameLevel:(GameLevelController *)sender;

@end

@interface GameLevelController : UIViewController {
}

@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) IBOutlet UILabel *levelLabel;
@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic, assign) id<GameLevelControllerDelegate> delegate;

- (IBAction)next:(id)sender;
- (IBAction)done:(id)sender;

- (void)begin;
- (void)setCellImage:(UIImage *)cellImage;

@end

