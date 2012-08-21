// InterstitialUseCase.m
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

#import "InterstitialUseCase.h"

@implementation InterstitialUseCase

@synthesize controllerClass = controllerClass_;
@synthesize title = title_;

#pragma mark InterstitialUseCase methods

+ (InterstitialUseCase *)interstitialUseCaseWithTitle:(NSString *)title
                                      controllerClass:(Class)controllerClass {
  InterstitialUseCase *result =
      [[[InterstitialUseCase alloc] init] autorelease];
  result.title = title;
  result.controllerClass = controllerClass;
  return result;
}

- (void)dealloc {
  [title_ release];
  [super dealloc];
}

@end
