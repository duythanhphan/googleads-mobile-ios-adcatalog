// Movies.m
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

#import "Movies.h"

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


#pragma mark -
@implementation Movies

@synthesize values = values_;

#pragma mark Movies methods
+ (Movies *)singleton {
  static Movies *result = nil;

  if (!result) {
    result = [[Movies alloc] init];
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSMutableArray *movies = [NSMutableArray array];

    NSURL *movieURL = [bundleURL URLByAppendingPathComponent:@"Earthquake.mp4"];
    [movies addObject:[Movie movieWithTitle:@"Earthquake" url:movieURL]];

    movieURL = [bundleURL URLByAppendingPathComponent:@"FillInTheBlanks.mp4"];
    [movies addObject:[Movie movieWithTitle:@"Fill In The Blanks"
                                        url:movieURL]];

    movieURL = [bundleURL URLByAppendingPathComponent:@"PackageTracking.mp4"];
    [movies addObject:[Movie movieWithTitle:@"Package Tracking" url:movieURL]];

    result.values = movies;
  }
  return result;
}

- (NSURL *)urlForMovieAtIndex:(NSUInteger)index {
  Movie *movie = [self.values objectAtIndex:index];
  return movie.url;
}

- (void)dealloc {
  [values_ release];
}

#pragma mark UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *identifier = NSStringFromClass([self class]);
  UITableViewCell *result =
      [sender dequeueReusableCellWithIdentifier:identifier];
  if (!result) {
    result =
        [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:identifier] autorelease];
  }

  Movie *movie = [self.values objectAtIndex:[indexPath indexAtPosition:1]];
  result.textLabel.text = movie.title;
  return result;
}

- (NSInteger)tableView:(UITableView *)sender
    numberOfRowsInSection:(NSInteger)section {
  return [self.values count];
}

@end
