//
//  TD4WViewController.m
//  TD4WButton
//
//  Created by Marc Shilling on 6/25/14.
//  Copyright (c) 2014 JM Apps. All rights reserved.
//

#import "TD4WViewController.h"
#import "UIActionSheet+Blocks.h"

static NSString * const TD4WService = @"td4w-service";

@interface TD4WViewController ()

@property (nonatomic, strong) IBOutlet UIImageView  *disc;
@property (nonatomic, strong) IBOutlet UIButton     *td4wButton;
@property (nonatomic, strong) IBOutlet ADBannerView *adBannerView;

@property (nonatomic, strong) IBOutlet UISwitch     *p2pSwitch;
@property (nonatomic, strong) IBOutlet UILabel      *p2pLabel;

@property (nonatomic, strong) IBOutlet UILabel      *turntLevelLabel;
@property (nonatomic, strong) IBOutlet UILabel      *highScoreLabel;

@property (nonatomic, strong) SessionController *session;

@property (nonatomic, strong) NSURL *td4wURL;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic) NSInteger turntLevel;
@property (nonatomic) NSInteger highScore;

@end

@implementation TD4WViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.turntLevel = 0;
    self.highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %ld", (long)self.highScore];
    
    self.adBannerView.hidden = YES;
    self.td4wURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"td4w" ofType:@"mp3"]];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    [self rotate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SessionControllerDelegate protocol conformance

- (void)sessionDidChangeState
{
    // Ensure UI updates occur on the main queue.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.p2pSwitch.isOn) {
            if (self.session.connectedPeers.count == 0) {
                self.p2pLabel.text = @"Waiting for others...";
            }
            else if (self.session.connectedPeers.count == 1) {
                self.p2pLabel.text = @"Turnt up with 1 other!";
            }
            else {
                self.p2pLabel.text = [NSString stringWithFormat:@"Turnt up with %d others!", (int)self.session.connectedPeers.count];
            }
        }
        else {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Turn up with others nearby!\n(Wi-Fi or Bluetooth required)"];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.f] range:NSMakeRange(27, 28)];
            self.p2pLabel.attributedText = str;
        }
    });
}

- (void)sesssionDidReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self TURNDOWNFORWHAT];
    });
}

- (IBAction)p2pSwitchValueChanged:(UISwitch *)sw
{
    if (sw.isOn) {
        self.session = [[SessionController alloc] init];
        self.session.delegate = self;
        self.p2pLabel.text = @"Waiting for others...";
    }
    else {
        // Dealloc this in the background because it takes some time to clean up
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            self.session = nil;
        });
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Turn up with others nearby!\n(Wi-Fi or Bluetooth required)"];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20] range:NSMakeRange(0, 27)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12] range:NSMakeRange(27, 30)];
        self.p2pLabel.attributedText = str;
    }
}

- (void)TURNDOWNFORWHAT
{
    self.turntLevel = self.turntLevel + (self.session.connectedPeers.count + 1);
    self.turntLevelLabel.text = [NSString stringWithFormat:@"Turnt Level: %ld", (long)self.turntLevel];
    if (self.turntLevel > self.highScore) {
        self.highScore = self.turntLevel;
        self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %ld", (long)self.highScore];
        [[NSUserDefaults standardUserDefaults] setObject:@(self.highScore) forKey:@"highscore"];
    }
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.td4wURL error:nil];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
}

- (IBAction)td4wButtonTapped:(id)sender
{
    if (self.p2pSwitch.isOn) {
        [self.session fireMessage];
    }
    [self TURNDOWNFORWHAT];
}

- (void)rotate
{
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(self.disc.transform, M_PI_2);
        self.disc.transform = transform;
    } completion:^(BOOL finished) {
        [self rotate];
    }];
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
}

#pragma mark iAd Delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //self.adBannerView.hidden = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    self.adBannerView.hidden = YES;
}


@end
