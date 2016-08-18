//
//  JWFolderModle.h
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <Realm/Realm.h>

RLM_ARRAY_TYPE(JWNoteModle)

@interface JWFolderModle : RLMObject

@property NSString *folderTitle;
@property RLMArray<JWNoteModle> *notes;
@property NSDate *folderCreateDate;
@property NSDate *folderUpdateDate;

@end
