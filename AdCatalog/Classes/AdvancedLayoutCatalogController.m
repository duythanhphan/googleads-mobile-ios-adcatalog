// AdvancedLayoutCatalogController.m
// Copyright 2012 Google Inc.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AdvancedLayoutCatalogController.h"

@implementation AdvancedLayoutCatalogController

@synthesize layoutsTableView = layoutsTableView_;
@synthesize advancedLayouts = advancedLayouts_;

// When the user's done simply pop back out to MainController.
- (IBAction)done:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

// The receiver is the layoutsTableView_'s delegate for input events
// and the AdvancedLayoutDataSource singleton is its datasource.
- (void)viewDidLoad {
  self.advancedLayouts = [[[AdvancedLayoutDataSource alloc] init] autorelease];
  layoutsTableView_.dataSource = self.advancedLayouts;
  layoutsTableView_.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}

- (void)dealloc {
  layoutsTableView_.dataSource = nil;
  layoutsTableView_.delegate = nil;
  [layoutsTableView_ release];

  [advancedLayouts_ release];

  [super dealloc];
}

#pragma mark UITableViewDelegate methods

// Whenever the user selects one of the LayoutUseCases see if it has a
// controller. If so simply present it, but if not load a trivial one.
- (void)tableView:(UITableView *)sender
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Class controllerClass =
      [self.advancedLayouts
          classForUseCaseAtIndex:[indexPath indexAtPosition:1]];
  UIViewController *controller =
      [[[controllerClass alloc] initWithNibName:nil bundle:nil] autorelease];
  controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

  if (controller) {
    [self presentModalViewController:controller animated:YES];
  }
  [layoutsTableView_ reloadData];
}

@end
