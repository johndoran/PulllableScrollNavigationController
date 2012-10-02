//
//  PullableView
//  Outbreak Zombie Apocalypse
//
//  Created by John Doran on 17/08/2012.
//  Copyright (c) 2012 JD. All rights reserved.
//
#import <UIKit/UIKit.h>

@class PullableView;

//Protocol for objects that wish to be notified when the state changes
@protocol PullableViewDelegate <NSObject>

//Notifies of a changed state
- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened;

@end

/**
 Class that implements a view that can be pulled out by a handle.
 Supports pulling in the horizontal or vertical axis. This is determined by
 the values for openedCenter and closedCenter that you set: if
 both have the same x coordinate, the pulling should happen in the
 vertical axis, or the horizontal axis otherwise.
 */
@interface PullableView : UIView {
    
    CGPoint closedCenter;
    CGPoint openedCenter;
    
    UIView *handleView;
    UIPanGestureRecognizer *dragRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
    
    BOOL verticalAxis;
    
    BOOL toggleOnTap;
    
    BOOL animate;
    float animationDuration;
    
    id<PullableViewDelegate> delegate;
}

/**
 Gesture recognizer responsible for the dragging of the handle view.
 It is exposed as a property so you can change the number of touches
 or created dependencies to other recognizers in your views.
 */
@property (nonatomic,readonly) UIPanGestureRecognizer *dragRecognizer;

/**
 Gesture recognizer responsible for handling tapping of the handle view.
 It is exposed as a property so you can change the number of touches
 or created dependencies to other recognizers in your views.
 */
@property (nonatomic,readonly) UITapGestureRecognizer *tapRecognizer;

//State of the pullable view
@property(nonatomic, readonly) BOOL opened;

//The handle for the PullableView. You can style it, add subviews or set its frame at will. 
@property (nonatomic,readonly) UIView *handleView;

//Center of the view when in its closed state.
@property (readwrite,assign) CGPoint closedCenter;

//Center of the view when in its opened state. You must set this before using the PullableView.
@property (readwrite,assign) CGPoint openedCenter;

//If set to YES, tapping the handle view will toggle the PullableView. Default value is YES.
@property (readwrite,assign) BOOL toggleOnTap;

//If set to YES, the opening or closing of the PullableView will be animated. Default value is YES.
@property (readwrite,assign) BOOL animate;

///Duration of the opening/closing animation, if enabled. Default value is 0.2.
@property (readwrite,assign) float animationDuration;

//Delegate that will be notified when the PullableView changes state. If the view is set to animate transitions, the delegate will be called only when the animation finishes.
@property (readwrite,assign) id<PullableViewDelegate> delegate;

//Toggles the state of the PullableView
- (void)setOpened:(BOOL)op animated:(BOOL)anim;

@end
