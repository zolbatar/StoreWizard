//
//  STPriviligedTask.h
//  StoreWizard
//
//  Created by Daryl Dudey on 16/02/2011.
//  Copyright 2011 Daryl Dudey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <Security/Authorization.h>

#define STPrivilegedTaskDidTerminateNotification	@"STPrivilegedTaskDidTerminateNotification"

@interface STPrivilegedTask : NSObject 
{
	NSArray			*arguments;
	NSString		*cwd;
	NSString		*launchPath;
	BOOL			isRunning;
	int				pid;
	int				terminationStatus;
	NSFileHandle	*outputFileHandle;
	
	NSTimer			*checkStatusTimer;
}

- (id)initWithLaunchPath: (NSString *)path arguments:  (NSArray *)args;
+ (STPrivilegedTask *)launchedPrivilegedTaskWithLaunchPath:(NSString *)path arguments:(NSArray *)arguments;
- (NSArray *)arguments;
- (NSString *)currentDirectoryPath;
- (BOOL)isRunning;
- (int)launch;
- (NSString *)launchPath;
- (int)processIdentifier;
- (void)setArguments:(NSArray *)arguments;
- (void)setCurrentDirectoryPath:(NSString *)path;
- (void)setLaunchPath:(NSString *)path;
- (NSFileHandle *)outputFileHandle;
- (void)terminate;  // doesn't work
- (int)terminationStatus;
- (void)_checkTaskStatus;
- (void)waitUntilExit;

@end