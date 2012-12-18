//
//  CSStatusBarWindow.h
//  CSStatusBar
//
//  Created by Marc Ammann on 3/6/12.
//  Copyright (c) 2012 codesofa.com. All rights reserved.
//

#import "CSStatusBarWindow.h"


@interface CSStatusBarWindow ()
@property (nonatomic, strong) NSMutableArray *informationStrings;
- (void)handleTap:(UIGestureRecognizer *)recognizer;
- (void)handleSwipe:(UIGestureRecognizer *)recognizer;

- (NSString *)getBundleValueForKey:(NSString *)key;
@end

@implementation CSStatusBarWindow

const NSInteger kLabelBaseTag = 100;

typedef NSString CSBundleKey;
CSBundleKey * const kCFBundleVersion = @"CFBundleVersion";
CSBundleKey * const kCFBundleShortVersionString = @"CFBundleShortVersionString";
CSBundleKey * const kCSBundleGitDescription = @"CSBundleGitDescription";
CSBundleKey * const kCSBundleGitInfo = @"CSBundleGitInfo";
CSBundleKey * const kCSBundleGitRef = @"CSBundleGitRef";

@synthesize informationStrings = informationStrings_;
@synthesize informationBarHidden = informationBarHidden_;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		
		self.windowLevel = UIWindowLevelStatusBar + 1;
		
		informationStrings_ = [[NSMutableArray alloc] init];
		
		informationIndex = 0;
		
		CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
		
		[[UIApplication sharedApplication] addObserver:self forKeyPath:@"statusBarFrame" options:0 context:NULL];
		[[UIApplication sharedApplication] addObserver:self forKeyPath:@"statusBarOrientation" options:0 context:NULL];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutStatusBar) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutStatusBar) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
		
		informationBar = [[UIView alloc] initWithFrame:statusBarFrame];
		
		[informationBar setBackgroundColor:[UIColor blackColor]];
		[self addSubview:informationBar];
		
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		[self addGestureRecognizer:tapRecognizer];
		
		UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
		[self addGestureRecognizer:swipeRightRecognizer];
		
		UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
		[self addGestureRecognizer:swipeLeftRecognizer];
	}
	
	return self;
}


- (void)dealloc {
}


#define DegToRad(degrees) (degrees * M_PI / 180)

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
	switch (orientation) {
		case UIInterfaceOrientationLandscapeLeft:
			return CGAffineTransformMakeRotation(-DegToRad(90));
			
		case UIInterfaceOrientationLandscapeRight:
			return CGAffineTransformMakeRotation(DegToRad(90));
			
		case UIInterfaceOrientationPortraitUpsideDown:
			return CGAffineTransformMakeRotation(DegToRad(180));
			
		case UIInterfaceOrientationPortrait:
		default:
			return CGAffineTransformMakeRotation(DegToRad(0));
	}
}

		 
- (void)layoutStatusBar {
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
	
	[self setFrame:CGRectMake(0, 0, width, 20.0f)];
	[informationBar setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 20.0f)];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self layoutStatusBar];
}


- (void)addInformation:(NSString *)value {
	[self.informationStrings addObject:value];
	[self setNeedsLayout];
}


- (NSString *)getBundleValueForKey:(CSBundleKey *)key {
	NSBundle *mainBundle = [NSBundle mainBundle];
	return (NSString *)[mainBundle objectForInfoDictionaryKey:key];
}


- (void)addGitRef {
	[self addInformation:[NSString stringWithFormat:@"Git Ref: %@", [self getBundleValueForKey:kCSBundleGitRef]]];
}


- (void)addGitDescription {
	[self addInformation:[NSString stringWithFormat:@"Git Description: %@", [self getBundleValueForKey:kCSBundleGitDescription]]];
}


- (void)addBundleVersion {
	[self addInformation:[NSString stringWithFormat:@"Build: %@", [self getBundleValueForKey:kCFBundleVersion]]];
}


- (void)addBundleShortVersionString {
	[self addInformation:[NSString stringWithFormat:@"Version: %@", [self getBundleValueForKey:kCFBundleShortVersionString]]];
}


- (void)setInformationBarHidden:(BOOL)hidden animated:(BOOL)animated {
	void (^changeInformationBarVisibility)(UIView *, CGFloat) = ^(UIView *bar, CGFloat visibility) {
		[bar setAlpha:visibility];
	};
	
	CGFloat newVisibility = hidden ? 0.0f : 1.0f;
	
	self.informationBarHidden = hidden;
	
	if (animated) {
		[UIView animateWithDuration:0.3f animations:^{
			changeInformationBarVisibility(informationBar, newVisibility);
		}];
	} else {
		changeInformationBarVisibility(informationBar, newVisibility);
	}
	
}


- (void)handleTap:(UIGestureRecognizer *)recognizer {
	[self setInformationBarHidden:!self.isInformationBarHidden animated:YES];
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {	
	if ([recognizer direction] == UISwipeGestureRecognizerDirectionLeft) {
		[self showNextInformation:YES];
	} else if ([recognizer direction] == UISwipeGestureRecognizerDirectionRight) {
		[self showPreviousInformation:YES];
	}
}


- (void)showPreviousInformation:(BOOL)animated {
	NSInteger nextIndex = informationIndex - 1;
	if (nextIndex <= 0) {
		nextIndex = [self.informationStrings count] - 1;
	}
	[self showInformationAtIndex:nextIndex animated:animated direction:UISwipeGestureRecognizerDirectionRight];	
}


- (void)showNextInformation:(BOOL)animated {
	NSInteger nextIndex = (informationIndex + 1) % [self.informationStrings count];
	[self showInformationAtIndex:nextIndex animated:animated direction:UISwipeGestureRecognizerDirectionLeft];
}


- (void)showInformationAtIndex:(NSInteger)index animated:(BOOL)animated direction:(UISwipeGestureRecognizerDirection)direction {
	CGRect statusBarFrame = informationBar.bounds;
	
	// The values where the current label is coming from.
	CGFloat previousOldAlpha = informationBar.alpha;
	CGPoint previousOldOrigin = informationBar.frame.origin;
	
	// The values that the current label is going to be sent to.
	CGFloat previousNewAlpha = 0.0f;
	CGPoint previousNewOrigin;
	if (direction == UISwipeGestureRecognizerDirectionLeft) {
		previousNewOrigin = CGPointMake(-statusBarFrame.size.width, statusBarFrame.origin.y);
	} else {
		previousNewOrigin = CGPointMake(statusBarFrame.size.width, statusBarFrame.origin.y);
	}
	
	// The values where the new label is coming from.
	CGFloat nextOldAlpha = 0.0f;
	CGPoint nextOldOrigin;
	if (direction == UISwipeGestureRecognizerDirectionLeft) {
		nextOldOrigin = CGPointMake(statusBarFrame.size.width, statusBarFrame.origin.y);
	} else {
		nextOldOrigin = CGPointMake(-statusBarFrame.size.width, statusBarFrame.origin.y);
	}
	
	// The value where the new label is going to.
	CGFloat nextNewAlpha = 1.0f;
	CGPoint nextNewOrigin = statusBarFrame.origin;

	UIView *previousLabel = [self viewWithTag:(kLabelBaseTag + informationIndex)];
	UIView *nextLabel = [self viewWithTag:(kLabelBaseTag + index)];
	if (!nextLabel) {
		UILabel *aLabel = [[UILabel alloc] initWithFrame:statusBarFrame];
		[aLabel setBackgroundColor:[UIColor clearColor]];
		[aLabel setTextColor:[UIColor lightGrayColor]];
		[aLabel setTextAlignment:UITextAlignmentCenter];
		[aLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
		[aLabel setText:[self.informationStrings objectAtIndex:index]];
		[aLabel setTag:(kLabelBaseTag + index)];
		nextLabel = aLabel;
	}
	
	void (^transitionLabels)(UIView *, UIView *, CGPoint, CGFloat, CGPoint, CGFloat) = ^(UIView *nextLabel, UIView *previousLabel, CGPoint nextOrigin, CGFloat nextAlpha, CGPoint previousOrigin, CGFloat previousAlpha) {
		
		CGRect nextLabelFrame = nextLabel.frame;
		nextLabelFrame.origin = nextOrigin;
		[nextLabel setFrame:nextLabelFrame];
		[nextLabel setAlpha:nextAlpha];
		
		if (previousLabel) {
			CGRect previousLabelFrame = previousLabel.frame;
			previousLabelFrame.origin = previousOrigin;
			[previousLabel setFrame:previousLabelFrame];
			[previousLabel setAlpha:previousAlpha];
		}
	};
	
	// Position the views initially, not animated
	transitionLabels(nextLabel, previousLabel, nextOldOrigin, nextOldAlpha, previousOldOrigin, previousOldAlpha);
	[informationBar addSubview:nextLabel];
	
	informationIndex = index;
	
	if (animated) {
		[UIView animateWithDuration:0.3f animations:^{
			transitionLabels(nextLabel, previousLabel, nextNewOrigin, nextNewAlpha, previousNewOrigin, previousNewAlpha);
		}];
	} else {
		transitionLabels(nextLabel, previousLabel, nextNewOrigin, nextNewAlpha, previousNewOrigin, previousNewAlpha);
	}
}



- (void)layoutSubviews {
	if ([self.informationStrings count] == 0) {
		[self setInformationBarHidden:YES animated:NO];
		return;
	}
	
	[self showInformationAtIndex:informationIndex animated:NO direction:UISwipeGestureRecognizerDirectionLeft];
	
	
}

@end
