//
//  ViewController.m
//  CustomTransitionAndBlur
//
//  Created by Gao Song on 10/31/15.
//  Copyright © 2015 Gao Song. All rights reserved.
//

#import "ViewController.h"
#import "GSViewController.h"
#import "GSViewControllerAnimator.h"
#import "GSViewControllerInteractiveAnimator.h"

@interface ViewController ()
@property UIScreenEdgePanGestureRecognizer *currentGestureRecognizer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIScreenEdgePanGestureRecognizer *recognizer=[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(show:)];
    
    [recognizer setEdges:UIRectEdgeLeft];
    
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        
        
         self.currentGestureRecognizer=recognizer;
        
        GSViewController *controller=[[GSViewController alloc] init];
        
        controller.transitioningDelegate=self;
        
        UIScreenEdgePanGestureRecognizer *closeRecognizer=[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        
        [closeRecognizer setEdges:UIRectEdgeRight];
        
        [controller.view addGestureRecognizer:closeRecognizer];
        
        [self presentViewController:controller animated:YES completion:^{
            self.currentGestureRecognizer=nil;
        }];
    }
    
    NSLog(@"%@",NSStringFromCGPoint([recognizer locationInView:self.view]));
   
}

-(void)close:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        
        self.currentGestureRecognizer=recognizer;
        
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            self.currentGestureRecognizer=nil;
        }];
    }
}

#pragma  mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    GSViewControllerAnimator *animatior=[[GSViewControllerAnimator alloc] init];
    
    animatior.presenting=YES;
    
    return animatior;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    GSViewControllerAnimator *animatior=[[GSViewControllerAnimator alloc] init];
    
    animatior.presenting=NO;
    
    return animatior;
}

- ( id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return [[GSViewControllerInteractiveAnimator alloc] initWithPanGestureRecognizer:self.currentGestureRecognizer];
}

- ( id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return [[GSViewControllerInteractiveAnimator alloc] initWithPanGestureRecognizer:self.currentGestureRecognizer];
}

@end
