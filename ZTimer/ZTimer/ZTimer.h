//
//  ZTimer.h
//  ZTimer
//
//  Created by zhang zhengbin on 2019/7/5.
//  Copyright © 2019 zhang zhengbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTimer : NSObject



/**
 启动定时器任务
 
 @param task 任务
 @param start 开始时间（几秒后开始执行）
 @param interval 间隔时间
 @param repeats 是否重复
 @param async 是否异步执行（否的话在主线程执行）
 @return 任务唯一标识 用于取消任务
 */
+ (NSString *)execTask:(void (^)(void))task
           start:(NSTimeInterval)start
        interval:(NSTimeInterval)interval
         repeats:(BOOL)repeats
           async:(BOOL)async;


/**
 启动定时器任务

 @param target 目标
 @param selector 方法
 @param start 开始时间（几秒后开始执行）
 @param interval 间隔时间
 @param repeats 是否重复
 @param async 是否异步执行（否的话在主线程执行）
 @return 任务唯一标识 用于取消任务
 */
+ (NSString *)execTask:(id)target
             selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;




/**
 取消任务

 @param taskName 任务名称（创建时返回）
 */
+ (void)cancelTask:(NSString *)taskName;

@end

