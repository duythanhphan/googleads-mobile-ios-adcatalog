// TableViewExampleController.m
// Copyright 2012 Google Inc. All Rights Reserved.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AdCatalogUtilities.h"
#import "SampleConstants.h"
#import "TableViewExampleController.h"

// The total number of ads showing up in the Table View. This example displays
// one ad in the first cell and one ad in the last cell of the Table View.
#define TOTAL_NUM_ADS_IN_TABLEVIEW 2
// The number of total items in list.
#define TOTAL_ITEMS_IN_LIST 47

@interface TableViewExampleController (Private)

- (void)layoutGADBannerView;
- (GADBannerView *)requestAd;
- (BOOL)rowContainsAd:(int)rowNumber;
- (int)getRowOffset:(int)rowNumber;

@end

@implementation TableViewExampleController

@synthesize tableView=tableView_;

#pragma mark GADBannerView implementation

- (GADBannerView *)requestAd {
  // Create and return the bannerView here so it isn't reused if requestAd
  // is called again.
  bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
  bannerView_.adUnitID = BANNER_AD_UNIT_ID;
  bannerView_.rootViewController = self;
  [bannerView_ setDelegate:self];

  [bannerView_ loadRequest:[AdCatalogUtilities adRequest]];
  // So that the request is not made again redundantly.
  didMakeAdRequest_ = YES;
  return bannerView_;
}

#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  didMakeAdRequest_ = NO;
  listItemsArray_ = [[NSMutableArray array] retain];

  for (int i = 0; i < TOTAL_ITEMS_IN_LIST; ++i) {
    [listItemsArray_ addObject:[NSString stringWithFormat:@"ListItem %d", i]];
  }
  tableView_.dataSource = self;
  tableView_.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInt
                                         duration:(NSTimeInterval)duration {
  [self layoutGADBannerView];
}

- (void)layoutGADBannerView {
  // Resize the adView frame and place it in the middle of the screen.
  CGRect frame = bannerView_.frame;
  frame.origin.x = (bannerView_.superview.bounds.size.width -
                        bannerView_.frame.size.width) / 2.0;
  bannerView_.frame = frame;
}

- (void)dealloc {
  [listItemsArray_ release];
  tableView_.dataSource = nil;
  tableView_.delegate = nil;
  [tableView_ release];
  bannerView_.delegate = nil;
  [bannerView_ release];
  [super dealloc];
}

#pragma mark TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  NSInteger count = [listItemsArray_ count];
  // Return the number items in the list plus the total number of ads displayed.
  return count + TOTAL_NUM_ADS_IN_TABLEVIEW;
}

// Want ad to be displayed at a fixed frequency defined by
// kFrequencyAdsTableViewExample.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  int row = [indexPath row];

  // Want every kFrequencyAdsTableViewExample item to be an ad.
  if ([self rowContainsAd:row]) {
    static NSString *cellIdentifier = @"AdCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier]
              autorelease];
    }
    // First ad request not made, make the ad request and add it to this cell.
    if (!didMakeAdRequest_) {
      //TODO: Use hasAutoRefreshed instead if available
      [self requestAd];
    }
    [cell.contentView addSubview:bannerView_];
    [self layoutGADBannerView];
  } else {
    static NSString *cellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier]
              autorelease];
    }
    // Remember to take into account that ads are being displayed in the list
    // by adding an offset.
    row = [self getRowOffset:row];
    cell.textLabel.text = [listItemsArray_ objectAtIndex:row];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  int row = [indexPath row];

  // Return normal cell size if the cell is not an ad.
  if ([self rowContainsAd:row]) {
    return CGSizeFromGADAdSize(kGADAdSizeBanner).height;
  }
  else {
    return tableView_.rowHeight;
  }
}

// When the user's done simply pop back out to MainController.
- (IBAction)done:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

// Whether this row number should contain an ad or not.
- (BOOL)rowContainsAd:(int)rowNumber {
  return ((rowNumber == 0) ||
          (rowNumber ==
              (listItemsArray_.count + TOTAL_NUM_ADS_IN_TABLEVIEW - 1)));
}

// The actual index into the array for the row when you don't take ads into
// account.
- (int)getRowOffset:(int)rowNumber {
  return rowNumber - 1;
}

#pragma mark GADBannerViewDelegate implementation

- (void)adView:(GADBannerView *)bannerView
    didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"Failed to receive banner ad.");
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  // There's an issue where the iPad TableView cell contentView size returns the
  // size of the iPhone cell size initially before it's first drawing, so until
  // this issue is fixed just layout the adView after it has been received.
  if (!adView.hasAutoRefreshed) {
    [self layoutGADBannerView];
  }
}

@end
