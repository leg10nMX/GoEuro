//
//  GEAPIClient.m
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GEAPIClient.h"
#import "GEAPIRequest.h"

@implementation GEAPIClient

-(NSArray*) parseLocationsFromJSONString:(NSData*)jsonData
{
    NSError* error = nil;
    NSArray* results = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error != nil)
        NSLog(@"%@",[error description]);
    return results;
}
-(void) getLocationsForRequestInBackground:(GEAPIRequest*)request
{
	[self performSelectorInBackground:@selector(getLocationsForRequest:) withObject:request];
}
-(void) getLocationsForRequest:(GEAPIRequest*)request 
{
	NSError* error=nil;
	NSData* results = [NSData
                       dataWithContentsOfURL:[NSURL URLWithString:[NSString
                                                                   stringWithFormat:@"http://pre.dev.goeuro.de:12345/api/v1/suggest/position/en/name/%@",
                                                                   [request.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]
                       options:0
                       error:&error];
    NSLog(@"%@", [[[NSString alloc] initWithData:results encoding:NSUTF8StringEncoding] autorelease]);
	if (error!=nil)
	{
		NSLog(@"%@",[error description]);
	}
	[request.target performSelectorOnMainThread:request.selector
									 withObject:[self parseLocationsFromJSONString:results] 
								  waitUntilDone:NO];
}
@end
