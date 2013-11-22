//
//  GEAPIRequest.h
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GEAPIRequest : NSObject {

}
@property (nonatomic,assign) SEL selector;
@property (nonatomic,retain) id target;
@property (nonatomic,retain) NSString* query;

-(id)initWithQuery:(NSString*)query target:(id)target selector:(SEL)selector;
@end
