//
//  IRWebAPIGoogleReaderAuthenticator.m
//  IRWebAPIKit
//
//  Created by Evadne Wu on 11/21/10.
//  Copyright 2010 Iridia Productions. All rights reserved.
//

#import "IRWebAPIKit.h"
#import "IRWebAPIGoogleReaderAuthenticator.h"

@interface IRWebAPIGoogleReaderAuthenticator ()

@property (nonatomic, retain, readwrite) NSString *authToken;

@end


@implementation IRWebAPIGoogleReaderAuthenticator

@synthesize authToken;

- (void) createTransformerBlocks {

	self.globalRequestPreTransformerBlock = [[^ (NSDictionary *inOriginalContext) {
	
		if (!self.currentCredentials) return inOriginalContext;
		if (!self.authToken) return inOriginalContext;
		
		NSMutableDictionary *transformedContext = [[inOriginalContext mutableCopy] autorelease];
		volatile NSMutableDictionary *headerFields = [transformedContext valueForKey:kIRWebAPIEngineRequestHTTPHeaderFields];
		headerFields = headerFields ? [[headerFields mutableCopy] autorelease] : [NSMutableDictionary dictionary];
		[transformedContext setObject:headerFields forKey:kIRWebAPIEngineRequestHTTPHeaderFields];
		[headerFields setObject:[NSString stringWithFormat:@"GoogleLogin auth=%@", self.authToken] forKey:@"Authorization"];
		
		return (NSDictionary *)transformedContext;
	
	} copy] autorelease];

	self.globalResponsePreTransformerBlock = [[^ (NSDictionary *inParsedResponse, NSDictionary *inResponseContext) {
	
		return inParsedResponse;
	
	} copy] autorelease];

}

- (void) associateWithEngine:(IRWebAPIEngine *)inEngine {

	[self disassociateEngine];
		
	self.authToken = nil;
	self.engine = inEngine;
	
	[super associateWithEngine:inEngine];
	
}

- (void) authenticateCredentials:(IRWebAPICredentials *)inCredentials onSuccess:(IRWebAPIAuthenticatorCallback)successHandler onFailure:(IRWebAPIAuthenticatorCallback)failureHandler {

	[self.engine fireAPIRequestNamed:@"accounts/ClientLogin" withArguments:[NSDictionary dictionaryWithObjectsAndKeys:

//		Does not quite work
//		@"HOSTED_OR_GOOGLE", @"accountType",

		@"reader", @"service",		
		inCredentials.identifier, @"Email",
		inCredentials.qualifier, @"Passwd",
	
	nil] options:[NSDictionary dictionaryWithObjectsAndKeys:
	
		IRWebAPIResponseQueryResponseParserMake(), kIRWebAPIEngineParser,
		@"POST", kIRWebAPIEngineRequestHTTPMethod,
		[NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded", @"Content-type", nil], kIRWebAPIEngineRequestHTTPHeaderFields,
	
	nil] validator: ^ (NSDictionary *inResponseOrNil, NSDictionary *inResponseContext) {
	
		if ([inResponseOrNil valueForKey:@"Auth"] == nil)
		return NO;
		
		if ([inResponseOrNil valueForKey:@"Error"])
		return NO;
		
		return YES;
	
	} successHandler: ^ (NSDictionary *inResponseOrNil, NSDictionary *inResponseContext, BOOL *outNotifyDelegate, BOOL *outShouldRetry) {
	
		self.authToken = [inResponseOrNil valueForKey:@"Auth"];
		self.currentCredentials = inCredentials;
		self.currentCredentials.authenticated = YES;
		
		if (successHandler)
		successHandler(self, YES, outShouldRetry);
	
	} failureHandler: ^ (NSDictionary *inResponseOrNil, NSDictionary *inResponseContext, BOOL *outNotifyDelegate, BOOL *outShouldRetry) {
	
		*outShouldRetry = NO;

		if (failureHandler)
		failureHandler(self, NO, outShouldRetry);
			
	}];

}

@end
