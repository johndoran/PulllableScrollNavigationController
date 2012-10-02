//
//  BaseViewController.m
//  OZACustomNav
//
//  Created by John Doran on 20/08/2012.
//  Copyright (c) 2012 John Doran. All rights reserved.
//

#import "BasePullableTabViewController.h"
#import "PullableView.h"


@implementation BasePullableTabViewController

@synthesize tabSelectedImageName;
@synthesize tabUnselectedImageName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tabSelectedImageName = @"warning.png";
        tabUnselectedImageName = @"city_unsel.png";
    }
    return self;
}

-(void)layoutViews
{
    //override in the implementation

    //Add the generic labels
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"I am view no %i", self.view.tag];
    [self.view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(130, 150, 200, 30)];
    label.alpha = 1;
    label.opaque = YES;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"View %i", self.view.tag];
    [self.view addSubview:label];
    [label release];
    label = nil;
}

-(void)dealloc
{
    [tabSelectedImageName release];
    tabSelectedImageName = nil;
    [tabUnselectedImageName release];
    tabUnselectedImageName = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
