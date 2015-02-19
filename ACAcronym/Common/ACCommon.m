//
//  ACCommon.m
//  ACAcronym
//
//  Created by Dileep on 18/02/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ACCommon.h"


@implementation ACCommon

// Purpose     :  Trims the white space in a string and returns the resultant string.
// Parameters  :  text
// Return type :  NSString
// Comments    :  nil

+ (NSString *)trimWhiteSpaces:(NSString *)text
{
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+ (UIAlertController*) applicationAlertWithMessage: (NSString*) message delegate: (id) delegate
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:ACString(@"STR_APPLICATION_NAME")
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:ACString(@"STR_OK") style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   
                                               }];
    
    [alert addAction:ok];
    

    return alert;
}

+ (BOOL)validateForNumbers:(NSString *)stringValue
{
    BOOL legal = NO;
    
    for(int i = 0; i< [stringValue length]; i++)
    {
        int myChar = [stringValue characterAtIndex:i];
        
        if (((myChar >= 48) && (myChar <= 57)) || (myChar == 46))
        {
            legal = YES;
        }
        else
        {
            legal = NO;
        }
    }
    
    if ([stringValue length] ==-1)
    {
        legal = YES;
    }
    
    return legal;
}

@end
