//
//  OBViewController.m
//  OZACustomNav
//
//  Created by John Doran on 20/08/2012.
//  Copyright (c) 2012 John Doran. All rights reserved.
//

#import "OBDemoViewController.h"
#import "PullableNavigationController.h"

#import "OBFirstViewController.h"
#import "OBSecondViewController.h"
#import "OBThirdViewController.h"
#import "OBFourthViewController.h"
#import "OBFifthViewController.h"

@interface OBDemoViewController ()

@end

@implementation OBDemoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    mapButton.frame = CGRectMake(290, 385, 18, 18);
    mapButton.backgroundColor = [UIColor clearColor];
    [mapButton addTarget:self action:@selector(toggleAnimationOnHide)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapButton];
//    [mapButton release];

    
    CGFloat xOffset = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        xOffset = 224;
    }
    
    OBFirstViewController *no1 = [[OBFirstViewController alloc]initWithNibName:nil bundle:nil];
    OBSecondViewController *no2 = [[OBSecondViewController alloc]initWithNibName:nil bundle:nil];
    OBThirdViewController *no3 = [[OBThirdViewController alloc]initWithNibName:nil bundle:nil];
    OBFourthViewController *no4 = [[OBFourthViewController alloc]initWithNibName:nil bundle:nil];
    OBFifthViewController *no5 = [[OBFifthViewController alloc]initWithNibName:nil bundle:nil];
    NSMutableArray *controllers = [[NSMutableArray alloc]initWithObjects:no1, no2, no3, no4, no5, nil];
    navController = [[PullableNavigationController alloc]initWithRootController:self andToolbarControllers:controllers];
}

-(void)toggleAnimationOnHide
{
    navController.animationWhenClosingViews = !navController.animationWhenClosingViews;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end