//
//  BRTransferViewController.h
//  BreadWallet
//
//  Created by Gabor Nagy on 18/10/15.
//  Copyright © 2015 Aaron Voisine. All rights reserved.
//

#import <MrCoinFramework/MrCoinFramework.h>

@interface BRTransferViewController : MrCoinViewController <UINavigationControllerDelegate,
UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

- (IBAction)tip:(id)sender;
- (void) showTip:(id)sender;

@end
