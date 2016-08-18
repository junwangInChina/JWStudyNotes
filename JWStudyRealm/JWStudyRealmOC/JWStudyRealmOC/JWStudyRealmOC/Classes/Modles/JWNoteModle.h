//
//  JWNoteModle.h
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <Realm/Realm.h>

@interface JWNoteModle : RLMObject

@property NSString *noteTitle;
@property NSString *noteContent;
@property NSDate *noteCreateDate;
@property NSDate *noteUpdateDate;

@end
