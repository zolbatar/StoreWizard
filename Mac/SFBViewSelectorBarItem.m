/*
 *  Copyright (C) 2009 Stephen F. Booth <me@sbooth.org>
 *  All Rights Reserved
 */

#import "SFBViewSelectorBarItem.h"

@implementation SFBViewSelectorBarItem

@synthesize identifier = _identifier;
@synthesize label = _label;
@synthesize tooltip = _tooltip;
@synthesize image = _image;
@synthesize view = _view;

+ (id) itemWithIdentifier:(NSString *)identifier label:(NSString *)label tooltip:(NSString *)tooltip image:(NSImage *)image view:(NSView *)view
{
	return [[[SFBViewSelectorBarItem alloc] initWithIdentifier:identifier label:label tooltip:tooltip image:image view:view] autorelease];
}

- (id) initWithIdentifier:(NSString *)identifier label:(NSString *)label tooltip:(NSString *)tooltip image:(NSImage *)image view:(NSView *)view
{
	// The identifier and view are the only two required parameters
	NSParameterAssert(nil != identifier);
	NSParameterAssert(nil != view);
	
	if((self = [super init])) {
		self.identifier = identifier;
		self.label = label;
		self.tooltip = tooltip;
		self.image = image;
		self.view = view;
	}
	
	return self;
}

- (void) dealloc
{
	[_identifier release], _identifier = nil;
	[_label release], _label = nil;
	[_tooltip release], _tooltip = nil;
	[_image release], _image = nil;
	[_view release], _view = nil;
	
	[super dealloc];
}

@end
