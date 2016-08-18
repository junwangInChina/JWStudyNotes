//
//  JWDefine.h
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/17.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#ifndef JWDefine_h
#define JWDefine_h

// WeakSelf，Block循环引用
#define JW_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#endif /* JWDefine_h */
