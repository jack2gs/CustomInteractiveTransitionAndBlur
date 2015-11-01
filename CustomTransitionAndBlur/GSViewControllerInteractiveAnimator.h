//
//  GSViewControllerInteractiveAnimator.h
//  CustomTransitionAndBlur
//
//  Created by Gao Song on 10/31/15.
//  Copyright © 2015 Gao Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GSViewControllerInteractiveAnimator : UIPercentDrivenInteractiveTransition
-(instancetype)initWithPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer;
@end
