//
//  IRWebAPITwitterInterface+Friendships.h
//  IRWebAPIKit
//
//  Created by Evadne Wu on 4/3/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRWebAPITwitterInterface.h"

@interface IRWebAPITwitterInterface (Friendships)

//	Actually unsure whether concatenated invocation (big, single-shot) or repeated invocation works better
//	So, wrote both to try them out separately

//	Note that the response is seldom written to a file in real world cases; instead it is mostly used to work other backing stores
//	I believe that many callbacks + a exhaustion check might (read: can, but possibly as in quadruple-alpha) work a lot more better in this case for most use cases

+ (BOOL) repeatedlyCalledSuccessHandlerResponseExhausted:(NSDictionary *)response;

//	returns YES if the engine agrees that the success handler is not going to be called any more in the same context


- (void) retrieveFriendsOfUser:(IRWebAPITwitterUserID)userID withConcatenatedSuccessHandler:(IRWebAPIInterfaceCallback)inSuccessCallback failureHandler:(IRWebAPIInterfaceCallback)inFailureCallback;

//	Stitches everything in memory and return a large chunk


- (void) retrieveFriendsOfUser:(IRWebAPITwitterUserID)userID withRepeatedlyCalledSuccessHandler:(IRWebAPIInterfaceCallback)inSuccessCallback failureHandler:(IRWebAPIInterfaceCallback)inFailureCallback;

//	Thought of integrating response, and found that way is not sustainable on mobile devices, and generally just bad
//	A nil-response success callback is fired again when things are really done





// Primitives

- (void) retrieveFriendsOfUser:(IRWebAPITwitterUserID)userID withCallbackStyle:(IRWebAPIInterfaceCallbackStyle)style successHandler:(IRWebAPIInterfaceCallback)inSuccessCallback failureHandler:(IRWebAPIInterfaceCallback)inFailureCallback;

- (void) retrieveFriendsOfUser:(IRWebAPITwitterUserID)userID withCursor:(unsigned long long)cursorID successHandler:(IRWebAPIInterfaceCallback)inSuccessCallback failureHandler:(IRWebAPIInterfaceCallback)inFailureCallback; // the primitive one

@end
