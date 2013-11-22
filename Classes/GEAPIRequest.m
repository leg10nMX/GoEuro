//
//  GEAPIRequest.m
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GEAPIRequest.h"

@implementation GEAPIRequest
-(void)dealloc
{
	[_target release];
	[_query release];
	[super dealloc];
}
-(id)initWithQuery:(NSString*)query target:(id)target selector:(SEL)selector
{
	if (self=[super init])
	{
		self.selector = selector;
		self.query = query;
		self.target = target;
	}
	return self;
}
@end
