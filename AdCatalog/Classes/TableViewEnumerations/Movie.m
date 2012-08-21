// Movie.m
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

#import "Movie.h"

@implementation Movie

@synthesize title = title_;
@synthesize url = url_;

#pragma mark Movie methods

+ (Movie *)movieWithTitle:(NSString *)title url:(NSURL *)url {
  Movie *result = [[[Movie alloc] init] autorelease];
  result.title = title;
  result.url = url;
  return result;
}

- (void)dealloc {
  [title_ release];
  [url_ release];
  [super dealloc];
}

@end
