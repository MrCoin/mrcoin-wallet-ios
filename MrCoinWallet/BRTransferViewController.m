//
//  BRTransferViewController.m
//  BreadWallet
//
//  Created by Gabor Nagy on 18/10/15.
//  Copyright © 2015 Aaron Voisine. All rights reserved.
//

#import "BRTransferViewController.h"
#import "BRBubbleView.h"

#define WELCOME_TIP      NSLocalizedString(@"Let others scan this QR code to get your bitcoin address. Anyone can send "\
"bitcoins to your wallet by transferring them to your address.", nil)
#define QUICKTRANSFER_TIP NSLocalizedString(@"This is your bitcoin address. Tap to copy it or send it by email or sms. The "\
"address will change each time you receive funds, but old addresses always work.", nil)

@interface BRTransferViewController ()

@property (nonatomic, strong) BRBubbleView *tipView;
@property (nonatomic, assign) BOOL showTips;

- (IBAction)tip:(id)sender;

@end

@implementation BRTransferViewController
{
    NSString *publicKey;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[MrCoin api] authenticate:^(id result) {
//        NSLog(@"result %@",result);
//    } error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tip:(id)sender
{
    if ([self nextTip]) return;
    
    if (! [sender isKindOfClass:[UIGestureRecognizer class]] ||
        ([sender view] != self.transferViewController.mrCoin && ! [[sender view] isKindOfClass:[UILabel class]])) {
        if (! [sender isKindOfClass:[UIViewController class]]) return;
        self.showTips = YES;
    }
    
    self.tipView = [BRBubbleView viewWithText:WELCOME_TIP
                                     tipPoint:[self.transferViewController.mrCoin.superview convertPoint:self.transferViewController.mrCoin.center toView:self.view]
                                 tipDirection:BRBubbleTipDirectionUp];
    self.tipView.backgroundColor = [UIColor orangeColor];
    self.tipView.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    [self.view addSubview:[self.tipView popIn]];
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
