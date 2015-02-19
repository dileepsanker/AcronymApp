//
//  ACCommon.h
//  ACAcronym
//
//  Created by Dileep on 18/02/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SERVICE_URL @"http://www.nactem.ac.uk/software/acromine/dictionary.py"
// For String localizations
#define ACString(key)					[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"Localizable"]

@interface ACCommon : NSObject

+ (NSString *)trimWhiteSpaces:(NSString *)text;
+ (BOOL)validateForNumbers:(NSString *)stringValue;
+ (UIAlertController*) applicationAlertWithMessage: (NSString*) message delegate: (id) delegate;
@end
