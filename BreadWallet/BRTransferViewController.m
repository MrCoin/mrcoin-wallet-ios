//
//  BRTransferViewController.m
//  BreadWallet
//
//  Created by Gabor Nagy on 18/10/15.
//  Copyright © 2015 Aaron Voisine. All rights reserved.
//

#import "BRTransferViewController.h"
#import "BRBubbleView.h"
#import "BRWalletManager.h"
#import "BRKey.h"
#import "NSData+Bitcoin.h"
#import "NSString+Bitcoin.h"
#import "BRBIP32Sequence.h"

@interface BRTransferViewController ()

@property (nonatomic, strong) BRBubbleView *tipView;
@property (nonatomic, assign) BOOL showTips;

- (IBAction)tip:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)serviceProvider:(id)sender;

@end

@implementation BRTransferViewController
{
    NSString *publicKey;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MrCoin sharedController] setDelegate:self];
    
    [[MrCoin api] authenticate:^(id result) {
        NSLog(@"result %@",result);
    } error:^(NSArray *errors, MRCAPIErrorType errorType) {
        NSLog(@"errors %@",errors);
    }];
}
- (NSString*) requestPublicKey
{
    return publicKey;
}
- (NSString*) requestPrivateKey
{
    publicKey = nil;
    return [[BRWalletManager sharedInstance] authPrivateKey];
}
- (NSString*) requestMessageSignature:(NSString*)message privateKey:(NSString*)privateKey;
{
    NSString *sign;
    if([privateKey isValidBitcoinPrivateKey]){
        BRKey *key = [BRKey keyWithPrivateKey:privateKey];
        publicKey = [NSString hexWithData:[key publicKey]];
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        
        NSData *signData = [key sign:[data SHA256]];
        if([[BRKey keyWithPublicKey:[key publicKey]] verify:[data SHA256] signature:signData]){
            sign = [NSString hexWithData:signData];
        }
    }
    return sign;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tip:(id)sender
{
}
- (BOOL)nextTip
{
    if (self.tipView.alpha < 0.5) return [(id)self.parentViewController.parentViewController nextTip];
    
    return YES;
}

#pragma mark - UIViewControllerAnimatedTransitioning

// This is used for percent driven interactive transitions, as well as for container controllers that have companion
// animations that might need to synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

// This method can only be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey],
    *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [containerView addSubview:to.view];
    
    [UIView transitionFromView:from.view toView:to.view duration:[self transitionDuration:transitionContext]
                       options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
                           [from.view removeFromSuperview];
                           [transitionContext completeTransition:YES];
                       }];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

@end
