//
//  OBViewController.h
//  OZACustomNav
//
//  Created by John Doran on 20/08/2012.
//  Copyright (c) 2012 John Doran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullableView.h"
#import "PullableNavigationController.h"

@interface OBDemoViewController : UIViewController {
    PullableView *firstPullUp;
    PullableView *secondPullUp;
    
    UILabel *pullUpLabel;
    
    PullableView *pullRightView;
    
    PullableNavigationController *navController;
}

@end
