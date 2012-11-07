// AdCatalogUtilities.m
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

#import "AdCatalogAppDelegate.h"
#import "AdCatalogUtilities.h"
#import "GADRequest.h"

@implementation AdCatalogUtilities

+ (GADRequest *)adRequest {
  AdCatalogAppDelegate *delegate =
      (AdCatalogAppDelegate *)[UIApplication sharedApplication].delegate;
  GADRequest *request = [GADRequest request];

  if (delegate.shouldShowTestAds) {
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    request.testDevices =
        [NSArray arrayWithObjects:
            // TODO: Add your device/simulator test identifiers here. They are
            // printed to the console when the app is launched.
            nil];
  }
  return request;
}

@end
