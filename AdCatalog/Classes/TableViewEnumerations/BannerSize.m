// BannerSize.m
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

#import "BannerSize.h"

@implementation BannerSize

@synthesize size = size_;
@synthesize title = title_;

#pragma mark BannerSize methods

+ (BannerSize *)instanceWithTitle:(NSString *)title size:(GADAdSize)size {
  BannerSize *result = [[[BannerSize alloc] init] autorelease];
  result.size = size;
  result.title = title;
  return result;
}

- (void)dealloc {
  [title_ release];
  [super dealloc];
}

@end
