//
//  BRTransferViewController.m
//  BreadWallet
//
//  Created by Gabor Nagy on 18/10/15.
//  Copyright © 2015 Aaron Voisine. All rights reserved.
//

#import "BRTransferViewController.h"
#import "BRBubbleView.h"

#define WELCOME_TIP      NSLocalizedString(@"TIP", nil)
#define QUICKTRANSFER_TIP NSLocalizedString(@"Whatever amount you transfer (up to 1,000 EUR), it will be converted to Bitcoin and sent directly into your wallet.\nPlease allow 12-48 banking hours for the transfer to clear in the Plan Old Banking System.", nil)

@interface BRTransferViewController ()

@property (nonatomic, strong) BRBubbleView *tipView;
@property (nonatomic, assign) BOOL showTips;

- (IBAction)tip:(id)sender;

@end

@implementation BRTransferViewController
{
    BOOL _showTransferTipOnly;
    NSString *publicKey;
    UITapGestureRecognizer *r1, *r2, *r3;
    UITapGestureRecognizer *r4, *r5, *r6;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //
    r1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tip:)];
    r2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tip:)];
    r3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tip:)];
    self.emptyViewController.view.gestureRecognizers = @[r1];
    self.emptyViewController.mrCoin.gestureRecognizers = @[r2];
    self.emptyViewController.titleView.gestureRecognizers = @[r3];
    
    r4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tip2:)];
    r5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tip2:)];
    r6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tip2:)];
    self.transferViewController.view.gestureRecognizers = @[r4];
    self.transferViewController.mrCoin.gestureRecognizers = @[r5];
    self.transferViewController.titleView.gestureRecognizers = @[r6];
}

- (void) showTip:(id)sender
{
    CGPoint p = [self.transferViewController.mrCoin.superview convertPoint:self.transferViewController.mrCoin.frame.origin toView:self.view];
    p.x += self.transferViewController.mrCoin.frame.size.width*0.5f;
    self.tipView = [BRBubbleView viewWithText:QUICKTRANSFER_TIP
                                     tipPoint:p
                                 tipDirection:BRBubbleTipDirectionDown];
    self.tipView.backgroundColor = [UIColor orangeColor];
    self.tipView.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    [self.view addSubview:[self.tipView popIn]];
}


- (IBAction)tip:(id)sender
{
    if ([self nextTip]) return;
    if (! [sender isKindOfClass:[UIGestureRecognizer class]] ||
        ([sender view] != self.emptyViewController.mrCoin && ! [[sender view] isKindOfClass:[UILabel class]])) {
        if (! [sender isKindOfClass:[UIViewController class]]) return;
        self.showTips = YES;
    }
    
    CGPoint p = [self.emptyViewController.mrCoin.superview convertPoint:self.emptyViewController.mrCoin.frame.origin toView:self.view];
    p.x += self.emptyViewController.mrCoin.frame.size.width*0.5f;
    p.x -= 15.0f;
    p.y += 10.0f;
    
    self.tipView = [BRBubbleView viewWithText:WELCOME_TIP
                                     tipPoint:p
                                 tipDirection:BRBubbleTipDirectionDown];
    self.tipView.backgroundColor = [UIColor orangeColor];
    self.tipView.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    [self.view addSubview:[self.tipView popIn]];
}

- (IBAction)tip2:(id)sender
{
    if ([self nextTip]) return;
    
    if (! [sender isKindOfClass:[UIGestureRecognizer class]] ||
        ([sender view] != self.transferViewController.mrCoin && ! [[sender view] isKindOfClass:[UILabel class]])) {
        if (! [sender isKindOfClass:[UIViewController class]]) return;
        self.showTips = YES;
    }
    
    CGPoint p = [self.transferViewController.mrCoin.superview convertPoint:self.transferViewController.mrCoin.frame.origin toView:self.view];
    p.x += self.transferViewController.mrCoin.frame.size.width*0.5f;
    self.tipView = [BRBubbleView viewWithText:QUICKTRANSFER_TIP
                                     tipPoint:p
                                 tipDirection:BRBubbleTipDirectionDown];
    self.tipView.backgroundColor = [UIColor orangeColor];
    self.tipView.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    [self.view addSubview:[self.tipView popIn]];
}
- (BOOL)nextTip
{
    if (!_showTransferTipOnly && self.tipView.alpha < 0.5) return [(id)self.parentViewController.parentViewController nextTip];
    
    BRBubbleView *tipView = self.tipView;
    
    self.tipView = nil;
    [tipView popOut];
    
//    if ([tipView.text hasPrefix:WELCOME_TIP]) {
//        self.tipView = [BRBubbleView viewWithText:ADDRESS_TIP tipPoint:[self.addressButton.superview
//                                                                        convertPoint:CGPointMake(self.addressButton.center.x, self.addressButton.center.y - 10.0)
//                                                                        toView:self.view] tipDirection:BRBubbleTipDirectionDown];
//        self.tipView.backgroundColor = tipView.backgroundColor;
//        self.tipView.font = tipView.font;
//        self.tipView.userInteractionEnabled = NO;
//        [self.view addSubview:[self.tipView popIn]];
//    }
//    else
        if (self.showTips) { // && [tipView.text hasPrefix:ADDRESS_TIP]
        self.showTips = NO;
        _showTransferTipOnly = NO;
        [(id)self.parentViewController.parentViewController tip:self];
    }
    
    return YES;
}

- (void)hideTips
{
    if (self.tipView.alpha > 0.5) [self.tipView popOut];
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
