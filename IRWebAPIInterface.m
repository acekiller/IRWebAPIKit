//
//  IRWebAPIInterface.m
//  IRWebAPIKit
//
//  Created by Evadne Wu on 12/1/10.
//  Copyright 2010 Iridia Productions. All rights reserved.
//

#import "IRWebAPIKit.h"





@implementation IRWebAPIInterface

@synthesize engine, authenticator;

- (id) init {

	return [self initWithEngine:nil authenticator:nil];

}

- (id) initWithEngine:(IRWebAPIEngine *)inEngine authenticator:(IRWebAPIAuthenticator *)inAuthenticator {

	self = [super init]; if (!self) return nil;
	
	engine = [inEngine retain];
	authenticator = [inAuthenticator retain];
	
	return self;

}

@end
