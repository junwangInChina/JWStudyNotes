//
//  JWLoginController.h
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/18.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWBaseViewController.h"

typedef void(^LoginComplete)(BOOL success);

@interface JWLoginController : JWBaseViewController

@property (nonatomic, copy) LoginComplete complete;

@end
