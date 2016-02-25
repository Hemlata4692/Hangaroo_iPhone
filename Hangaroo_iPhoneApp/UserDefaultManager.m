//
//  UserDefaultManager.m
//  Digibi_ecommerce
//
//  Created by Sumit on 08/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

+(void)setValue : (id)value key :(NSString *)key
{

    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

+(id)getValue : (NSString *)key
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

+(void)removeValue : (NSString *)key
{

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];

}
@end
