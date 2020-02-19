/*
 *  Copyright (C) 2009 Stephen F. Booth <me@sbooth.org>
 *  All Rights Reserved
 */

#import "SFBViewSelector.h"
#import "SFBViewSelectorBar.h"
#import "SFBViewSelectorBarItem.h"

#import <QuartzCore/QuartzCore.h>

@interface SFBViewSelector (Private)
- (void) createSelectorBarAndBody;
- (void) applicationWillTerminate:(NSNotification *)notification;
@end

@implementation SFBViewSelector

- (id) initWithFrame:(NSRect)frame
{
	if((self = [super initWithFrame:frame]))
		[self createSelectorBarAndBody];
	return self;
}

- (id) initWithCoder:(NSCoder *)decoder
{
	if((self = [super initWithCoder:decoder]))
		[self createSelectorBarAndBody];
	return self;
}

- (void) dealloc
{
	[_selectorBar release], _selectorBar = nil;
	[_bodyView release], _bodyView = nil;
	
	[super dealloc];
}

- (void) awakeFromNib
{
	_initialWindowSize = [[self window] frame].size;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];

#if USE_CORE_ANIMATION
	[_bodyView setWantsLayer:YES];

	/*
	 CIBarsSwipeTransition,
	 CICopyMachineTransition,
	 CIDisintegrateWithMaskTransition,
	 CIDissolveTransition,
	 CIFlashTransition,
	 CIModTransition,
	 CIPageCurlTransition,
	 CIRippleTransition,
	 CISwipeTransition
	 */
	CIFilter *transitionFilter = [CIFilter filterWithName:@"CIDissolveTransition"];
	[transitionFilter setDefaults];
	
	CATransition *transition = [CATransition animation];
	[transition setFilter:transitionFilter];

	NSDictionary *animations = [NSDictionary dictionaryWithObject:transition forKey:@"subviews"];
	[_bodyView setAnimations:animations];
#endif

//	// Restore the selected pane
//	NSString *autosaveName = [[self window] frameAutosaveName];
//	if(autosaveName) {
//		NSString *selectedPaneDefaultsName = [autosaveName stringByAppendingFormat:@" Selected Pane"];		
//		NSString *selectedIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:selectedPaneDefaultsName];
//
//		if(selectedIdentifier)
//			[[self selectorBar] selectItemWithIdentifer:selectedIdentifier];
//	}
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
#pragma unused(keyPath)
#pragma unused(object)
#pragma unused(context)
	
	NSNumber *oldIndex = [change objectForKey:NSKeyValueChangeOldKey];
	NSNumber *newIndex = [change objectForKey:NSKeyValueChangeNewKey];
	
	NSView *oldView = nil;
	if(-1 != [oldIndex integerValue]) {
		oldView = [[[self selectorBar] itemAtIndex:[oldIndex unsignedIntegerValue]] view];
		[oldView removeFromSuperviewWithoutNeedingDisplay];
	}
	else
		oldView = _bodyView;

	// No new view was specified, so keep the existing window frame but clear the title
	if(-1 == [newIndex integerValue]) {
		[[self window] setTitle:@""];
		return;
	}
	
	NSView *newView = [[[self selectorBar] itemAtIndex:[newIndex unsignedIntegerValue]] view];
	
	// Calculate the new window size
	CGFloat deltaY = [newView frame].size.height - [oldView frame].size.height;
//	CGFloat deltaX = [newView frame].size.width - [oldView frame].size.width;
	
	NSRect currentWindowFrame = [[self window] frame];
	NSRect newWindowFrame = currentWindowFrame;
	
//	newWindowFrame.origin.x -= deltaX / 2;
	newWindowFrame.origin.y -= deltaY;

//	newWindowFrame.size.width += deltaX;
	newWindowFrame.size.height += deltaY;
	
	[[self window] setFrame:newWindowFrame display:YES animate:YES];
	
#if USE_CORE_ANIMATION
	[[_bodyView animator] addSubview:newView];
#else
	[_bodyView addSubview:newView];
#endif
		
	// Update the key view
	NSView *view = [newView nextValidKeyView];
	if(view)
		[[self window] makeFirstResponder:view];
	
	// Set the window's title to the selected pane's title
	NSString *newTitle = [[[self selectorBar] itemAtIndex:[newIndex integerValue]] label];
	if(!newTitle)
		newTitle = @"";
	
	[[self window] setTitle:newTitle];
}

- (SFBViewSelectorBar *) selectorBar
{
	return [[_selectorBar retain] autorelease];
}

@end

@implementation SFBViewSelector (Private)

- (void) createSelectorBarAndBody
{
	// Divide our bounds into the bar and body areas
	NSRect selectorBarFrame, bodyFrame;	
	NSDivideRect([self bounds], &selectorBarFrame, &bodyFrame, VIEW_SELECTOR_BAR_HEIGHT, NSMaxYEdge);
	
	_selectorBar = [[SFBViewSelectorBar alloc] initWithFrame:selectorBarFrame];
	
	[_selectorBar setAutoresizingMask:(NSViewWidthSizable | NSViewMinYMargin)];
	
	[_selectorBar addObserver:self forKeyPath:@"selectedIndex" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
	
	_bodyView = [[NSView alloc] initWithFrame:bodyFrame];
	
	[_bodyView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[self addSubview:_selectorBar];
	[self addSubview:_bodyView];

	[self setAutoresizesSubviews:YES];
}

- (void) applicationWillTerminate:(NSNotification *)notification
{
	
#pragma unused(notification)
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
//	// Save the selected pane
//	NSString *autosaveName = [[self window] frameAutosaveName];
//	if(autosaveName) {
//		NSString *selectedIdentifier = [[[self selectorBar] selectedItem] identifier];
//		NSString *selectedPaneDefaultsName = [autosaveName stringByAppendingFormat:@" Selected Pane"];
//		
//		[[NSUserDefaults standardUserDefaults] setValue:selectedIdentifier forKey:selectedPaneDefaultsName];
//		
//		[[NSUserDefaults standardUserDefaults] synchronize];
//	}	
	
	// Reset the window's frame to its initial size
	NSRect currentWindowFrame = [[self window] frame];
	NSRect newWindowFrame = currentWindowFrame;
	
	CGFloat deltaY = _initialWindowSize.height - currentWindowFrame.size.height;
	
	newWindowFrame.origin.y -= deltaY;
	newWindowFrame.size.height += deltaY;
	
	[[self window] setFrame:newWindowFrame display:NO animate:NO];
}

@end
