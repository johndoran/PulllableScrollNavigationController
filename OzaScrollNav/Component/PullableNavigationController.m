//
//  PullableNavigationController.m
//  OZACustomNav
//
//  Created by John Doran on 20/08/2012.
//  Copyright (c) 2012 John Doran. All rights reserved.
//

#import "PullableNavigationController.h"
#import "PullableView.h"
#import "BasePullableTabViewController.h"

@implementation PullableNavigationController

@synthesize toolBar;
@synthesize currentViewController;
@synthesize viewControllers;
@synthesize animationWhenClosingViews;

-(id)initWithRootController:(UIViewController*)rootController andToolbarControllers:(NSMutableArray*)controllers;
{
    [super init];
    self.viewControllers = controllers;
    rootViewController = rootController;
    int i = 0;
    controllerSelectedImageNames = [[NSMutableArray alloc]initWithCapacity:[viewControllers count]];
    controllerUnselectedImageNames = [[NSMutableArray alloc]initWithCapacity:[viewControllers count]];
    for(BasePullableTabViewController *controller in viewControllers){
        [controllerSelectedImageNames addObject:controller.tabSelectedImageName];
        [controllerUnselectedImageNames addObject:controller.tabUnselectedImageName];
        controller.view.tag = i;
        i++;
    }
    [self displayScrollView];
    [self buildToolbar];
    return self;
}

-(void)buildToolbar
{
    CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 64, [[UIScreen mainScreen] bounds].size.width, 44);
    toolBar = [[UIToolbar alloc]initWithFrame:frame];
    toolBar.clearsContextBeforeDrawing = NO;
    toolBar.opaque = NO;
    menuButtons = [[NSMutableArray alloc]initWithCapacity:[viewControllers count]];
    //toolBar.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    
    NSMutableArray *toolbarButtons = [[NSMutableArray alloc] init];
    int tag = 0;
    for(BasePullableTabViewController *controller in viewControllers){
        controller.view.tag = tag;
        //done want a spacer after the last button
        if(tag!=[viewControllers count]){
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spacer.width = 18.0f;
            [toolbarButtons addObject:spacer];
            [spacer release];
            spacer = nil;
        }
        if(tag==0){
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spacer.width = 18.0f;
            [toolbarButtons addObject:spacer];
            [spacer release];
            spacer = nil;
        }
        
        UIBarButtonItem *button;
        if(controller.tabSelectedImageName==nil||controller.tabSelectedImageName==@""){
            button = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%i", tag]
                                                      style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(menuButtonTapped:)];
            [menuButtons addObject:button];
        }else{
            UIImage *toolbarImage = [UIImage imageNamed:[controllerUnselectedImageNames objectAtIndex:tag]];
            button = [[UIBarButtonItem alloc] initWithImage:toolbarImage
                                        landscapeImagePhone:toolbarImage
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(menuButtonTapped:)];
            [toolbarImage release];
            toolbarImage = nil;
            [menuButtons addObject:button];
        }
       
        button.tag = tag;
        [toolbarButtons addObject:button];
        [button release];
        button = nil;
        tag++;
    }
    [self.toolBar setItems:toolbarButtons];
    [toolbarButtons release];
    toolbarButtons = nil;
    
    [rootViewController.view addSubview:toolBar];
    [toolBar release];
    toolBar = nil;
}

-(void)displayScrollView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    //The pullview
    pullView = [[PullableView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    pullView.openedCenter = CGPointMake(160, screen.size.height-196);
    pullView.closedCenter = CGPointMake(160, screen.size.height + 200);
    pullView.center = pullView.closedCenter;
    pullView.handleView.frame = CGRectMake(0, 0, screen.size.width, 20);
    pullView.handleView.backgroundColor = [UIColor blackColor];
    pullView.delegate = self;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 20)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"--------------------";
    [pullView addSubview:label];
    
    [label release];
    label = nil;
       
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, screen.size.width, screen.size.height)];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    [scrollView setContentSize:CGSizeMake(screen.size.width*[viewControllers count], screen.size.height-80)];
    scrollView.delegate = self; //todo
    UIColor *color = [UIColor colorWithRed: .5 green: .5 blue: .5 alpha:0.3];
    [scrollView setBackgroundColor:color];


    currentPage = 0;
      
    [pullView addSubview:scrollView];
    [rootViewController.view addSubview:pullView];

    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    if (page >= [viewControllers count])return;
    
    // replace the placeholder if necessary
    BasePullableTabViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[BasePullableTabViewController alloc] initWithNibName:nil bundle:nil];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = -10;
        controller.view.frame = frame;
        [controller layoutViews];
        [scrollView addSubview:controller.view];
    }
}


- (void)menuButtonTapped:(id)sender{
    UIBarButtonItem *sentButton = (UIBarButtonItem*)sender;
    if(!pullView.opened){
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * [sender tag];
        frame.origin.y = -10;
        [scrollView scrollRectToVisible:frame animated:NO];
        sentButton.image = [UIImage imageNamed:[controllerSelectedImageNames objectAtIndex:[sender tag]]];
        [pullView setOpened:YES animated:YES];
    }
    else if([sender tag]==currentPage.intValue){
        [pullView setOpened:NO animated:YES];
        [self resetAllButtons];
    }else{
        // update the scroll view to the appropriate page
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * [sender tag];
        frame.origin.y = 0;
        [scrollView scrollRectToVisible:frame animated:NO];
        [self resetAllButtons];
        sentButton.image = [UIImage imageNamed:[controllerSelectedImageNames objectAtIndex:[sender tag]]];
    }
    
}

-(void)resetAllButtons{
    int i=0;
    for(UIBarButtonItem *button in menuButtons){
        if(button.image!=nil){
            button.image = [UIImage imageNamed:[controllerUnselectedImageNames objectAtIndex:i]];
            i++;
        }
    }
}

#pragma scrollview delegate impl
- (void)scrollViewDidScroll:(UIScrollView *)sender
{	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPage = [NSNumber numberWithInt:page];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self resetAllButtons];
    UIBarButtonItem *button = [menuButtons objectAtIndex:page];
    button.image = [UIImage imageNamed:[controllerSelectedImageNames objectAtIndex:page]];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

#pragma pull view delegate impl
- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened
{
    if(!opened){
        [self resetAllButtons];
    }
}

- (void)dealloc
{
    currentPage = nil;
    [toolBar release];
    toolBar = nil;
    [currentViewController release];
    currentViewController = nil;
    [viewControllers release];
    viewControllers = nil;
    [rootViewController release];
    rootViewController = nil;
    [scrollView release];
    scrollView = nil;
    [menuButtons release];
    menuButtons = nil;
    [super dealloc];
}

@end
