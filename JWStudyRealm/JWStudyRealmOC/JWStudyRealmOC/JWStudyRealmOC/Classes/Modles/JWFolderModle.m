
//
//  JWFolderModle.m
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWFolderModle.h"

@implementation JWFolderModle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.folderCreateDate = [NSDate date];
        self.folderUpdateDate = [NSDate date];
    }
    return self;
}

@end
