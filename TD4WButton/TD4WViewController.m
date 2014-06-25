//
//  TD4WViewController.m
//  TD4WButton
//
//  Created by Marc Shilling on 6/25/14.
//  Copyright (c) 2014 JM Apps. All rights reserved.
//

#import "TD4WViewController.h"

@interface TD4WViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *disc;
@property (nonatomic, strong) IBOutlet UIButton *td4wButton;
@property (nonatomic, strong) IBOutlet ADBannerView *adBannerView;

@property (nonatomic, strong) NSURL *td4wURL;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

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
    
    self.adBannerView.hidden = YES;
    self.td4wURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"td4w" ofType:@"mp3"]];
    
    [self rotate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)td4wButtonTapped:(id)sender
{
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.td4wURL error:nil];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
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


#pragma mark iAd Delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    self.adBannerView.hidden = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    self.adBannerView.hidden = YES;
}


@end
