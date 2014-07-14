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

@property (nonatomic, strong) IBOutlet UISwitch     *hostSwitch;

@property (nonatomic, strong) MCPeerID                  *localPeerID;
@property (nonatomic, strong) MCNearbyServiceBrowser    *serviceBrowser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic, strong) MCSession                 *session;

//@property (nonatomic, strong) IBOutlet UIView               *downloadView;
//@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *downloadViewConstraint;
//@property (nonatomic, strong) IBOutlet UILabel              *downloadLabel;

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
    
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:self.localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    self.session.delegate = self;
    
    self.serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID serviceType:TD4WService];
    self.serviceBrowser.delegate = self;
    
    self.serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID discoveryInfo:nil serviceType:TD4WService];
    self.serviceAdvertiser.delegate = self;
    [self.serviceAdvertiser startAdvertisingPeer];

//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Never turn down. Download the track."];
//    [string addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange(17, 8)];
//    self.downloadLabel.attributedText = string;
    
    [self rotate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    [self playtd4w];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    // Empty implementation
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    // Empty implementation
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    // Empty implementation
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    // Empty implementation
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertise didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    //NSLog(@"Received invitiation from peer: %@", peerID);
    
    [UIActionSheet showInView:self.view withTitle:[NSString stringWithFormat:@"Received Invitation From %@", peerID.displayName] cancelButtonTitle:@"Turn Down" destructiveButtonTitle:nil otherButtonTitles:@[@"!! Turn Up !!"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        BOOL acceptedInvitation = (buttonIndex == [actionSheet firstOtherButtonIndex]);
        if (acceptedInvitation) {
            [self.hostSwitch setOn:NO];
            [self hostSwitchValueChanged:self.hostSwitch];
        }
        invitationHandler(acceptedInvitation, self.session);
    }];
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    //NSLog(@"Found peer: %@", peerID);

    [self.serviceBrowser invitePeer:peerID toSession:self.session withContext:nil timeout:10];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    // Empty implementation
}


- (IBAction)hostSwitchValueChanged:(UISwitch *)sw
{
    if (sw.isOn) {
        [self.serviceBrowser startBrowsingForPeers];
    }
    else {
        [self.serviceBrowser stopBrowsingForPeers];
        
        [self.session disconnect];
        self.session = [[MCSession alloc] initWithPeer:self.localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
        self.session.delegate = self;
    }
}

- (void)playtd4w
{
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.td4wURL error:nil];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
}

- (IBAction)td4wButtonTapped:(id)sender
{
    if (self.session.connectedPeers.count > 0) {
        NSData *data = [@"TURN DOWN FOR WHAT" dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        if (![self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error]) {
            NSLog(@"[Error] %@", error);
        }
    }
    
    [self playtd4w];
}

//- (IBAction)downloadButtonTapped:(id)sender
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/album/turn-down-for-what/id786489553?i=786489670&uo=4"]];
//}

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
    //self.downloadViewConstraint.constant = 50;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    self.adBannerView.hidden = YES;
    //self.downloadViewConstraint.constant = 0;
}


@end
