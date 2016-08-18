//
//  JWNoteModle.m
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWNoteModle.h"

@implementation JWNoteModle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.noteCreateDate = [NSDate date];
        self.noteUpdateDate = [NSDate date];
    }
    return self;
}

@end
