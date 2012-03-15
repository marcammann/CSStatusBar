//
//  CSStatusBarWindow.h
//  CSStatusBar
//
//  Created by Marc Ammann on 3/6/12.
//  Copyright (c) 2012 codesofa.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSStatusBarWindow : UIWindow {
	UIView *informationBar;
	NSInteger informationIndex;
}

- (void)addInformation:(NSString *)value;
- (void)setInformationBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)showNextInformation:(BOOL)animated;
- (void)showPreviousInformation:(BOOL)animated;
- (void)showInformationAtIndex:(NSInteger)index animated:(BOOL)animated direction:(UISwipeGestureRecognizerDirection)direction;

- (void)addGitRef;
- (void)addGitDescription;
- (void)addBundleVersion;
- (void)addBundleShortVersionString;

@property (nonatomic, readwrite, getter = isInformationBarHidden) BOOL informationBarHidden;

@end
