// AdvancedLayoutDataSource.m
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

#import "AdvancedLayoutDataSource.h"
#import "AdvancedLayoutUseCase.h"
#import "OpenGLExampleController.h"
#import "ScrollViewExampleController.h"
#import "TabbedViewExampleController.h"
#import "TableViewExampleController.h"

#pragma mark -

@implementation AdvancedLayoutDataSource

@synthesize title = title_;
@synthesize values = values_;

#pragma mark NewAdvancedLayoutDataSource methods

- (id)init {
  if (self = [super init]) {
    self.title = @"Use Cases";

    NSMutableArray *useCases = [NSMutableArray array];
    [useCases addObject:[AdvancedLayoutUseCase
                         advancedLayoutUseCaseWithTitle:@"Tabbed View"
                         controllerClass:[TabbedViewExampleController class]]];
    [useCases addObject:[AdvancedLayoutUseCase
                         advancedLayoutUseCaseWithTitle:@"Table View"
                         controllerClass:[TableViewExampleController class]]];
    [useCases addObject:[AdvancedLayoutUseCase
                         advancedLayoutUseCaseWithTitle:@"Scroll View"
                         controllerClass:[ScrollViewExampleController class]]];
    [useCases addObject:[AdvancedLayoutUseCase
                         advancedLayoutUseCaseWithTitle:@"OpenGL View"
                         controllerClass:[OpenGLExampleController class]]];
    self.values = useCases;
  }
  return self;
}

- (Class)classForUseCaseAtIndex:(NSUInteger)index {
  AdvancedLayoutUseCase *useCase = [self.values objectAtIndex:index];
  return useCase.controllerClass;
}

- (void)dealloc {
  [title_ release];
  [values_ release];
  [super dealloc];
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

  AdvancedLayoutUseCase *useCase =
      [self.values objectAtIndex:[indexPath indexAtPosition:1]];
  result.textLabel.text = useCase.title;
  return result;
}

- (NSInteger)tableView:(UITableView *)sender
    numberOfRowsInSection:(NSInteger)section {
  return [self.values count];
}

- (NSString *)tableView:(UITableView *)sender
    titleForHeaderInSection:(NSInteger)section {
  return self.title;
}

@end
