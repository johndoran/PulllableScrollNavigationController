//
//  PullableNavigationController.h
//  OZACustomNav
//
//  Created by John Doran on 20/08/2012.
//  Copyright (c) 2012 John Doran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullableView.h"

@interface PullableNavigationController : NSObject <UIScrollViewDelegate, PullableViewDelegate>
{
    UIViewController *rootViewController;
    UIScrollView *scrollView;
    PullableView *pullView;
    NSNumber *currentPage;
    NSMutableArray *controllerSelectedImageNames;
    NSMutableArray *controllerUnselectedImageNames;
    NSMutableArray *menuButtons;//lets us control the images
}

@property(nonatomic, readonly)UIToolbar *toolBar;

//The view controller at the top of the navigation stack. (read-only)
@property(nonatomic, readonly, retain) UIViewController *currentViewController;

//The view controllers currently on the navigation stack.
//YOur view controller must extend BasePullableTabViewController
@property(nonatomic, copy) NSMutableArray *viewControllers;

@property(nonatomic, readwrite)BOOL animationWhenClosingViews;

-(id)initWithRootController:(UIViewController*)rootController andToolbarControllers:(NSMutableArray*)controllers;

@end