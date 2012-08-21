// ScrollViewExampleController.m
// Copyright 2012 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AdCatalogUtilities.h"
#import "GADBannerView.h"
#import "SampleConstants.h"
#import "ScrollViewExampleController.h"

@interface ScrollViewExampleController (Private)

- (void)layoutGADBannerView;

@end

@implementation ScrollViewExampleController

@synthesize scrollView = scrollView_;
@synthesize label = label_;

// When the user's done simply pop back out to MainController.
- (IBAction)done:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  label_.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 0);
  label_.lineBreakMode = UILineBreakModeWordWrap;
  label_.numberOfLines = 0;
  label_.text = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
      @"Nam cursus. Morbi ut mi. Nullam enim"
      @"leo, egestas id, condimentum at, laoreet mattis, massa. Sed eleifend"
      @"nonummy diam. Praesent mauris ante, elementum et, bibendum at, posuere"
      @"sit amet, nibh. Duis tincidunt lectus quis dui viverra vestibulum."
      @"Suspendisse vulputate aliquam dui. Nulla elementum dui ut augue."
      @"vehicula mi at mauris. Maecenas placerat, nisl at consequat rhoncus,"
      @"nunc gravida justo, quis eleifend arcu velit quis lacus. Morbi magna"
      @"magna, tincidunt a, mattis non, imperdiet vitae, tellus. Sed odio est,"
      @"auctor ac, sollicitudin in, consequat vitae, orci. Fusce id felis."
      @"Vivamus sollicitudin metus eget eros."
      @"\n\nPellentesque habitant morbi tristique senectus et netus et mal"
      @"fames ac turpis egestas. In posuere felis nec tortor. Pellentesque"
      @"faucibus. Ut accumsan ultricies elit. Maecenas at justo id velit"
      @"placerat molestie. Donec dictum lectus non odio. Cras a ante vitae enim"
      @"iaculis aliquam. Mauris nunc quam, venenatis nec, euismod sit amet,"
      @"egestas placerat, est. Pellentesque habitant morbi tristique senectus"
      @"netus et malesuada fames ac turpis egestas. Cras id elit. Integer quis"
      @"urna. Ut ante enim, dapibus malesuada, fringilla eu, condimentum quis,"
      @"tellus. Aenean porttitor eros vel dolor. Donec convallis pede venenatis"
      @"nibh. Duis quam. Nam eget lacus. Aliquam erat volutpat. Quisque"
      @"dignissim congue leo."
      @"\n\nMauris vel lacus vitae felis vestibulum volutpat. Etiam est nunc,"
      @"venenatis in, tristique eu, imperdiet ac, nisl. Cum sociis natoque"
      @"penatibus et magnis dis parturient montes, nascetur ridiculus mus. In"
      @"iaculis facilisis massa. Etiam eu urna. Sed porta. Suspendisse quam"
      @"molestie sed, luctus quis, feugiat in, pede. Fusce tellus. Sed metus"
      @"augue, convallis et, vehicula ut, pulvinar eu, ante. Integer orci"
      @"tellus, tristique vitae, consequat nec, porta vel, lectus. Nulla sit"
      @"amet diam. Duis non nunc. Nulla rhoncus dictum metus. Curabitur"
      @"tristique mi condimentum orci. Phasellus pellentesque aliquam enim."
      @"Proin dui lectus, cursus eu, mattis laoreet, viverra sit amet, quam."
      @"Curabitur vel dolor ultrices ipsum dictum tristique. Praesent vitae"
      @"lacus. Ut velit enim, vestibulum non, fermentum nec, hendrerit quis,"
      @"leo. Pellentesque rutrum malesuada neque."
      @"\n\nNunc tempus felis vitae urna. Vivamus porttitor, neque at volutpat"
      @"rutrum, purus nisi eleifend libero, a tempus libero lectus feugiat"
      @"felis. Morbi diam mauris, viverra in, gravida eu, mattis in, ante."
      @"eget arcu. Morbi porta, libero id ullamcorper nonummy, nibh ligula"
      @"pulvinar metus, eget consectetuer augue nisi quis lacus. Ut ac mi quis"
      @"lacus mollis aliquam. Curabitur iaculis tempus eros. Curabitur vel mi"
      @"sit amet magna malesuada ultrices. Ut nisi erat, fermentum vel, congue"
      @"id, euismod in, elit. Fusce ultricies, orci ac feugiat suscipit, leo"
      @"massa sodales velit, et scelerisque mi tortor at ipsum. Proin orci odio"
      @"commodo ac, gravida non, tristique vel, tellus. Pellentesque nibh"
      @"libero, ultricies eu, sagittis non, mollis sed, justo. Praesent metus"
      @"ipsum, pulvinar pulvinar, porta id, fringilla at, est."
      @"\n\nPhasellus felis dolor, scelerisque a, tempus eget, lobortis id,"
      @"libero. Donec scelerisque leo ac risus. Praesent sit amet est. In"
      @"dictum, dolor eu dictum porttitor, enim felis viverra mi, eget luctus"
      @"massa purus quis odio. Etiam nulla massa, pharetra facilisis, volutpat"
      @"in, imperdiet sit amet, sem. Aliquam nec erat at purus cursus interdum."
      @"Vestibulum ligula augue, bibendum accumsan, vestibulum ut, commodo a,"
      @"mi. Morbi ornare gravida elit. Integer congue, augue et malesuada"
      @"iaculis, ipsum dui aliquet felis, at cursus magna nisl nec elit. Donec"
      @"iaculis diam a nisi accumsan viverra. Duis sed tellus et tortor"
      @"vestibulum gravida. Praesent elementum elit at tellus. Curabitur metus"
      @"ipsum, luctus eu, malesuada ut, tincidunt sed, diam. Donec quis mi sed"
      @"magna hendrerit accumsan. Suspendisse risus nibh, ultricies eu, volutpa"
      @"non, condimentum hendrerit, augue. Etiam eleifend, metus vitae"
      @"adipiscing semper, mauris ipsum iaculis elit, congue gravida elit mi"
      @"egestas orci. Curabitur pede."
      @"\n\nMaecenas aliquet velit vel turpis. Mauris neque metus, malesuada"
      @"nec, ultricies sit amet, porttitor mattis, enim. In massa libero,"
      @"interdum nec, interdum vel, blandit sed, nulla. In ullamcorper, est ege"
      @"tempor cursus, neque mi consectetuer mi, a ultricies massa est sed nis."
      @"Class aptent taciti sociosqu ad litora torquent per conubia nostra, per"
      @"inceptos hymenaeos. Proin nulla arcu, nonummy luctus, dictum eget,"
      @"fermentum et, lorem. Nunc porta convallis pede.";

  bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];

  // Make all of the necessary ad setup.
  bannerView_.adUnitID = BANNER_AD_UNIT_ID;
  bannerView_.delegate = self;
  bannerView_.rootViewController = self;
  [self.view addSubview:bannerView_];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [label_ sizeToFit];
  scrollView_.contentSize = label_.frame.size;
  // Initialize the banner off the screen so that it animates up when
  // displaying.
  didReceiveFirstAd_ = NO;
  CGPoint origin =
      CGPointMake((self.view.bounds.size.width -
                      CGSizeFromGADAdSize(kGADAdSizeBanner).width) / 2.0,
                  self.view.bounds.size.height);
  bannerView_.frame = CGRectMake(origin.x,
                                 origin.y,
                                 bannerView_.frame.size.width,
                                 bannerView_.frame.size.height);
  [bannerView_ loadRequest:[AdCatalogUtilities adRequest]];
}

- (void)dealloc {
  bannerView_.delegate = nil;
  [bannerView_ release];
  [scrollView_ release];
  [label_ release];
  [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations.
  return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInt
                                         duration:(NSTimeInterval)duration {
  [self layoutGADBannerView];
}

- (void)layoutGADBannerView {
  bannerView_.frame =
      CGRectMake((self.view.bounds.size.width - bannerView_.frame.size.width)
                    / 2.0,
                 self.view.bounds.size.height - bannerView_.frame.size.height,
                 bannerView_.frame.size.width,
                 bannerView_.frame.size.height);
  [label_ sizeToFit];
  scrollView_.contentSize = label_.frame.size;
}

#pragma mark GADBannerViewDelegate implementation

// Since we've received an ad, let's go ahead and animate it in.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  // Want this animation to happen only on the first ad received so we put the
  // code in here instead of just calling layoutGADBannerView:.
  if (!didReceiveFirstAd_) {
    CGRect newScrollFrame =
        CGRectMake(scrollView_.frame.origin.x,
                   scrollView_.frame.origin.y,
                   scrollView_.frame.size.width,
                   scrollView_.frame.size.height -
                      bannerView_.frame.size.height);
    CGRect newAdFrame =
        CGRectMake((self.view.bounds.size.width - bannerView_.frame.size.width)
                      / 2.0,
                   self.view.bounds.size.height - bannerView_.frame.size.height,
                   bannerView_.frame.size.width,
                   bannerView_.frame.size.height);
    [label_ sizeToFit];
    [UIView animateWithDuration:1.0 animations:^{
      scrollView_.frame = newScrollFrame;
      bannerView_.frame = newAdFrame;
      scrollView_.contentSize = label_.frame.size;
    }];
    // We only want the animation to happen for the first ad received.
    didReceiveFirstAd_ = YES;
  }
}

@end
