//
//  GSViewControllerInteractiveAnimator.m
//  CustomTransitionAndBlur
//
//  Created by Gao Song on 10/31/15.
//  Copyright © 2015 Gao Song. All rights reserved.
//

#import "GSViewControllerInteractiveAnimator.h"

@interface GSViewControllerInteractiveAnimator ()

@property id<UIViewControllerContextTransitioning> contextData;
@property UIPanGestureRecognizer *panGesture;

@end

@implementation GSViewControllerInteractiveAnimator

-(instancetype)initWithPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self=[super init]) {
        
        self.panGesture=gestureRecognizer;
    }
    
    return self;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Always call super first.
    [super startInteractiveTransition:transitionContext];
    
    // Save the transition context for future reference.
    self.contextData = transitionContext;
    
    [self.panGesture addTarget:self action:@selector(handleSwipeUpdate:)];
}
-(void)handleSwipeUpdate:(UIGestureRecognizer *)gestureRecognizer {
    
    UIView* container = [self.contextData containerView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // Reset the translation value at the beginning of the gesture.
        [self.panGesture setTranslation:CGPointMake(0, 0) inView:container];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // Get the current translation value.
        CGPoint translation = [self.panGesture translationInView:container];
        
        // Compute how far the gesture has travelled vertically,
        //  relative to the height of the container view.
        CGFloat percentage = fabs(translation.x / CGRectGetWidth(container.bounds));
        
        // Use the translation value to update the interactive animator.
        [self updateInteractiveTransition:percentage];
    }
    else if (gestureRecognizer.state >= UIGestureRecognizerStateEnded) {
        // Finish the transition and remove the gesture recognizer.
        [self finishInteractiveTransition];
        // [[self.contextData containerView] removeGestureRecognizer:self.panGesture];
    }
}
@end
