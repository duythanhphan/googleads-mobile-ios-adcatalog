// GameLevelController.m
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
#import "GameLevelController.h"
#import "TargetConditionals.h"

#define CELL_MARGIN 10.0

#if defined(TARGET_IPHONE_SIMULATOR)
  #define POPULATION_RATE_SECONDS 0.025
#else
  #define POPULATION_RATE_SECONDS 0.001
#endif

@interface GameLevelView (GameLevelController)

- (void)begin;
- (void)clear;

@end

@interface GameLevelController (Private)

- (void)didEnd;
- (void)setDelegate:(id<GameLevelControllerDelegate>)delegate;
- (void)setToolbarHidden:(BOOL)isHidden animate:(BOOL)shouldAnimate;

@end

@implementation GameLevelView

@synthesize cellImage = cellImage_;
@synthesize controller = controller_;

- (void)begin {
  [self clear];
  timer_ = [NSTimer scheduledTimerWithTimeInterval:POPULATION_RATE_SECONDS
                                            target:self
                                          selector:@selector(populateCell)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)clear {
  free(isPopulatedCell_);
  isPopulatedCell_ = NULL;
  cellCount_ = 0;

  [self setNeedsDisplay];
}

- (void)dealloc {
  [controller_ release];
  [cellImage_ release];
  [timer_ invalidate];

  [self clear];

  [super dealloc];
}

- (void)drawRect:(CGRect)rect {
  if (!cellCount_) {
    return;
  }

  CGFloat x = (self.frame.size.width -
               ((cellsPerRow_ * self.cellImage.size.width) +
                (cellsPerRow_ - 1) * CELL_MARGIN)) / 2.0;

  int cellRows = (cellCount_ / cellsPerRow_);
  CGFloat cellFieldHeight = (cellRows * self.cellImage.size.height) +
                            ((cellRows - 1) * CELL_MARGIN);

  CGPoint cellPoint = CGPointMake(x, (self.frame.size.height -
                                      cellFieldHeight) / 2.0);

  for (int r = 0; r < cellCount_ / cellsPerRow_; ++r) {
    for (int c = 0; c < cellsPerRow_; ++c) {
      if (isPopulatedCell_[(r * cellsPerRow_) + c]) {
        [self.cellImage drawAtPoint:cellPoint];
      }
      cellPoint.x += self.cellImage.size.width + CELL_MARGIN;
    }
    cellPoint.x = x;
    cellPoint.y += self.cellImage.size.height + CELL_MARGIN;
  }
}

- (void)end {
  [timer_ invalidate];
  timer_ = nil;

  [self.controller didEnd];
}

- (void)populateCell {
  if (!isPopulatedCell_) {
    CGFloat visibleHeight = self.layer.visibleRect.size.height;
    int cellRows = (visibleHeight - CELL_MARGIN) /
                      (self.cellImage.size.height + CELL_MARGIN);

    cellsPerRow_ = (self.frame.size.width - CELL_MARGIN) /
                      (self.cellImage.size.width + CELL_MARGIN);

    cellCount_ = cellsPerRow_ * cellRows;
    isPopulatedCell_ = calloc(cellCount_, sizeof(BOOL));
    populatedCellCount_ = 0;
  }
  int candidateIndex = arc4random() % cellCount_;

  while ((populatedCellCount_ < cellCount_) &&
         (isPopulatedCell_[candidateIndex])) {
    candidateIndex = random() % cellCount_;
  }

  if (populatedCellCount_ < cellCount_) {
    isPopulatedCell_[candidateIndex] = YES;
    populatedCellCount_++;
    [self setNeedsDisplay];
  } else {
    [self end];
  }
}

@end

@implementation GameLevelController

@synthesize delegate = delegate_;
@synthesize label = label_;
@synthesize levelLabel = levelLabel_;
@synthesize toolbar = toolbar_;

- (void)begin {
  self.levelLabel.center = self.view.center;
  self.levelLabel.alpha = 1.0;
  [self setToolbarHidden:YES animate:NO];

  [UIView animateWithDuration:1.0
                        delay:0.0
                      options:UIViewAnimationCurveLinear
                   animations:^{
                     self.levelLabel.alpha = 0.0;
                   }
                   completion:^(BOOL finished){
                     [((GameLevelView *)self.view) begin];
                   }];
}

- (void)setToolbarHidden:(BOOL)isHidden animate:(BOOL)shouldAnimate {
  CGRect frame = self.toolbar.frame;

  frame.origin.y = self.view.frame.size.height;

  if (!isHidden) {
    frame.origin.y -= self.toolbar.frame.size.height;
  }

  if (shouldAnimate) {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                       self.toolbar.frame = frame;
                     }
                     completion:nil];
  } else {
    self.toolbar.frame = frame;
  }
}

- (void)dealloc {
  [label_ release];
  [levelLabel_ release];
  [toolbar_ release];

  [super dealloc];
}

- (void)didEnd {
  [self setToolbarHidden:NO animate:YES];
}

- (NSString *)logID {
  return self.levelLabel.text;
}

- (IBAction)next:(id)sender {
  [(GameLevelView *)self.view clear];
  [self setToolbarHidden:YES animate:YES];
  [self.delegate nextGameLevel:self];
}

- (IBAction)done:(id)sender {
  [self.delegate doneWithGameLevel:self];
}

- (void)setCellImage:(UIImage *)cellImage {
  ((GameLevelView *)self.view).cellImage = cellImage;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.levelLabel.text = self.label;
  ((GameLevelView *)self.view).controller = self;
  [self setToolbarHidden:YES animate:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInt
                                duration:(NSTimeInterval)duration {
  // Remove the toolbar in case it was already being shown, then restart the
  // level on orientation changes.
  [self setToolbarHidden:YES animate:NO];
  [((GameLevelView *)self.view) clear];
  [((GameLevelView *)self.view) begin];
}

@end
