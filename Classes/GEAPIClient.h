//
//  GEAPIClient.h
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GEAPIRequest;

@interface GEAPIClient : NSObject {

}
-(void) getLocationsForRequestInBackground:(GEAPIRequest*)request;
@end
