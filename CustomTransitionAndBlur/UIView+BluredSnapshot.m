//
//  UIView+BluredSnapshot.m
//  CustomTransitionAndBlur
//
//  Created by Gao Song on 11/1/15.
//  Copyright © 2015 Gao Song. All rights reserved.
//

#import "UIView+BluredSnapshot.h"
#import "UIImageEffects.h"

@implementation UIView (BluredSnapshot)
-(UIImage *)blurredSnapshot
{
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    
    // There he is! The new API method
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Now apply the blur effect using Apple's UIImageEffect category
    UIImage *blurredSnapshotImage = [UIImageEffects imageByApplyingLightEffectToImage:snapshotImage];;
       
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}
@end
