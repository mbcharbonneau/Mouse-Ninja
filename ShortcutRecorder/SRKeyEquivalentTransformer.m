//
//  SRKeyEquivalentTransformer.m
//  ShortcutRecorder
//
//  Copyright 2012 Contributors. All rights reserved.
//
//  License: BSD
//
//  Contributors:
//      Ilya Kulakov

#import "SRKeyEquivalentTransformer.h"
#import "SRKeyCodeTransformer.h"
#import "SRRecorderControl.h"


@implementation SRKeyEquivalentTransformer

#pragma mark NSValueTransformer

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

+ (Class)transformedValueClass
{
    return [NSString class];
}

- (NSString *)transformedValue:(NSDictionary *)aValue
{
    if (![aValue isKindOfClass:[NSDictionary class]])
        return @"";

    NSNumber *keyCode = aValue[SRShortcutKeyCode];

    if (![keyCode isKindOfClass:[NSNumber class]])
        return @"";

    SRKeyCodeTransformer *t = [SRKeyCodeTransformer sharedASCIITransformer];
    unsigned short keyCodeValue = [keyCode unsignedShortValue];

    if (keyCodeValue == kVK_ANSI_KeypadEnter)
        return [NSString stringWithFormat:@"%C", (unichar)NSEnterCharacter];
    else
        return [t transformedValue:keyCode];
}

@end
