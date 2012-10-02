//
//  BaseViewController.h
//  OZACustomNav
//
//  Created by John Doran on 20/08/2012.
//  Copyright (c) 2012 John Doran. All rights reserved.
//

/**
 * Based on the fact all our UIViewControllers will contain pullable views, seems a nice concept to be able to control all in a base class.
 * 1. implementing this basecontroller will call layoutViews when its appropriate to render the view on the ui
 * 2. when calling initWithNibName this will handle creating the pullable view + sets it as the VC's view.
 **/

#import <UIKit/UIKit.h>

@interface BasePullableTabViewController : UIViewController

@property(nonatomic, retain)NSString *tabSelectedImageName;
@property(nonatomic, retain)NSString *tabUnselectedImageName;

-(void)layoutViews;

@end
