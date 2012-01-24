// BannerCatalogController.h
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
#import "GADBannerView.h"
#import "BannerSizes.h"

// Manages a UITableView of available BannerSizes, requesting a matching
// ad when one is selected.
@interface BannerCatalogController : UIViewController
    <UITableViewDelegate, GADBannerViewDelegate> {
  GADBannerView *adView_;
}

@property(nonatomic, retain) IBOutlet UITableView *sizeTableView;
@property(nonatomic, retain) BannerSizes *bannerSizes;

- (IBAction)done:(id)sender;

@end