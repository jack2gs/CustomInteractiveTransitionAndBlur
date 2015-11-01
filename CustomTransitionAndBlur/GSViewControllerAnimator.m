//
//  GSViewControllerAnimatedTransitioning.m
//  CustomTransitionAndBlur
//
//  Created by Gao Song on 10/31/15.
//  Copyright © 2015 Gao Song. All rights reserved.
//

#import "GSViewControllerAnimator.h"
#import "UIView+BluredSnapshot.h"


@implementation GSViewControllerAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Get the set of relevant objects.
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext
                                viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext
                                viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // Set up some variables for the animation.
    CGRect containerFrame = containerView.frame;
    CGRect toViewStartFrame = [transitionContext initialFrameForViewController:toVC];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
    
    UIImageView *snapshotImageView=nil;
    CGRect snapshotImageViewFinalFrame;
    
    // Set up the animation parameters.
    if (self.presenting) {
        // Modify the frame of the presented view so that it starts
        // offscreen at the lower-right corner of the container.
        toViewStartFrame.origin.x = -containerFrame.size.width;
        toViewStartFrame.origin.y = 0;
        toViewStartFrame.size=containerView.frame.size;
        
        CGRect snapshotImageViewStartFrame;
        
        snapshotImageViewStartFrame=CGRectMake(0, 0, 0, CGRectGetHeight(fromView.frame));
        snapshotImageViewFinalFrame=CGRectMake(0, 0, CGRectGetWidth(fromView.frame), CGRectGetHeight(fromView.frame));
        
        
        UIImage *bluredSnapshotimage=[fromView blurredSnapshot];
        
        snapshotImageView=[[UIImageView alloc] initWithImage:bluredSnapshotimage];
        
        [snapshotImageView setContentMode:UIViewContentModeLeft];
        [snapshotImageView setClipsToBounds:YES];
        
        snapshotImageView.tag=100;
        
        snapshotImageView.frame=snapshotImageViewStartFrame;
    }
    else {
        // Modify the frame of the dismissed view so it ends in
        // the lower-right corner of the container view.
        fromViewFinalFrame = CGRectMake(-containerFrame.size.width,
                                        0,
                                        toView.frame.size.width,
                                        toView.frame.size.height);
        
        toViewStartFrame=containerFrame;
        
        snapshotImageViewFinalFrame=CGRectMake(0, 0, 0, CGRectGetHeight(fromView.frame));
        
        snapshotImageView=[containerView viewWithTag:100];
    }
    
    // add  image view
    if (self.presenting) {
        [containerView addSubview:snapshotImageView];
    }
    
    // Always add the "to" view to the container.
    // And it doesn't hurt to set its start frame.
    [containerView addSubview:toView];
    toView.frame = toViewStartFrame;
    
    // if not presenting bring from view to front
    if (!self.presenting) {
        [containerView bringSubviewToFront:snapshotImageView];
        [containerView bringSubviewToFront:fromView];
    }
    
    
    // Animate using the animator's own duration value.
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         if (self.presenting) {
                             // Move the presented view into position.
                             [toView setFrame:toViewFinalFrame];
                         }
                         else {
                             // Move the dismissed view offscreen.
                             [fromView setFrame:fromViewFinalFrame];
                         }
                         snapshotImageView.frame=snapshotImageViewFinalFrame;
                     }
                     completion:^(BOOL finished){
                         BOOL success = ![transitionContext transitionWasCancelled];
                         
                         // After a failed presentation or successful dismissal, remove the view.
                         if (!success) {
                             [toView removeFromSuperview];
                             if (self.presenting) {
                                 [snapshotImageView removeFromSuperview];
                             }
                         }
                         else
                         {
                             [fromView removeFromSuperview];
                             if (!self.presenting) {
                                 [snapshotImageView removeFromSuperview];
                             }
                         }
                         
                         // Notify UIKit that the transition has finished
                         [transitionContext completeTransition:success];
                     }];
    
}

@end
