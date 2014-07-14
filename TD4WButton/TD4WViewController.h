//
//  TD4WViewController.h
//  TD4WButton
//
//  Created by Marc Shilling on 6/25/14.
//  Copyright (c) 2014 JM Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AVFoundation/AVFoundation.h>
//#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "SessionController.h"

@interface TD4WViewController : UIViewController <UIWebViewDelegate, ADBannerViewDelegate, AVAudioPlayerDelegate, SessionControllerDelegate>

@end
