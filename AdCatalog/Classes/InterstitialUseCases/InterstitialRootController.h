// InterstitialRootController.h
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
#import "GADInterstitial.h"
#import "GADRequestError.h"

// Wraps GADInterstitial mechanics in a simple UIView/UIViewController pair
// that trivializes interstitial integration into a typical animation-driven
// UX (all three non-splash use cases have mid-animation ads). The
// controller's view acts as a container for those preceding and following
// the interstitial. App-specific subclasses simply overload up to four
// event hooks below defining the ad life-cycle (see GameController and
// MovieController as examples).

@interface InterstitialRootController : UIViewController
    <GADInterstitialDelegate, UIAlertViewDelegate> {
 @private
  GADInterstitial *interstitial_;
  BOOL isPresenting_;
}

// The consumer integrates the controller and its view into the app's UX flow
// just like any other UIViewController. Only an ad unit ID and GADRequest
// must be specified before invoking presentInterstitial to display the ad.

@property(nonatomic, retain) NSString *adUnitID;
@property(nonatomic, retain) GADRequest *interstitialRequest;

// The interstitial is now on-screen. Subclasses may use this hook as an
// opportunity to place a new view behind the ad for immediate display after
// its dismissal (presentationWill/DidEnd: arrive too late).
- (void)presentationDidBegin;

// The interstitial's presentation has concluded due to either user dismissal
// or request error (overload presentationDidFailWithError: to distinguish
// between the two).
- (void)presentationDidEnd;

// The GADRequest has failed. Non-error-handling-related exit logic should
// reside in presentationDidEnd for invocation on both success and failure.
- (void)presentationDidFailWithError:(GADRequestError *)error;

// Invoked by the super-controller to "play" the ad once and transition
// animation has completed and the receiver's positioned on-screen.
- (void)presentInterstitial;

// Presentation tear-down has begun. For timing purposes this is the sweet
// spot for hiding or showing the status bar (if the status bar was
// not hidden immediately before ad display GADInterstitial's default
// behaviour is to restore it).
- (void)presentationWillEnd;

@end
