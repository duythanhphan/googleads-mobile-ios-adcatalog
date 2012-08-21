// GameController.h
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

#import "GameLevelController.h"
#import "InterstitialRootController.h"

// An InterstitialRootController subclass managing two GameLevelControllers,
// fading between the two with an interstitial between them on the way up.
@interface GameController : InterstitialRootController
    <GameLevelControllerDelegate>

@end
