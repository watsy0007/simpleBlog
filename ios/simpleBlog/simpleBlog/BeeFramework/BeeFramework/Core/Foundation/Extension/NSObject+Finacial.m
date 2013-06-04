//
//  NSObject+Finacial.m
//  lciMyBags
//
//  Created by  王 岩 on 13-5-14.
//  Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "NSObject+Finacial.h"

@implementation NSObject (Finacial)

- (NSString *) asCurrency
{
    double fCurrency = 0.0;
    if ( [self isKindOfClass:[NSNumber class]] )
	{
        fCurrency = [(NSNumber *)self doubleValue];
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
        fCurrency = [(NSString *)self doubleValue];
	}
    else if ( [self isKindOfClass:[NSData class]])
    {
        NSString *sCurrency = [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
        fCurrency = [sCurrency doubleValue];
        [sCurrency autorelease];
    }
    
    NSNumberFormatter *numberformatter = [[NSNumberFormatter alloc] init];
    [numberformatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *sCurrency = [numberformatter stringFromNumber:__DOUBLE(fCurrency)];
    [numberformatter autorelease];
    
    return sCurrency;
}

@end
