//
//  ZTimer.m
//  ZTimer
//
//  Created by zhang zhengbin on 2019/7/5.
//  Copyright © 2019 zhang zhengbin. All rights reserved.
//

#import "ZTimer.h"

static NSMutableDictionary *timers_;
static dispatch_semaphore_t semaphore_;
@implementation ZTimer

+ (void)initialize
{
    if (self == [ZTimer class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            timers_ = [NSMutableDictionary dictionary];
            semaphore_  = dispatch_semaphore_create(1);
        });
    }
    
    
}

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
           async:(BOOL)async {
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        NSLog(@"Rrror arg");
        return nil;
    }
    
  
    //创建队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) :dispatch_get_main_queue();
    //创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置时间
    dispatch_source_set_timer(timer, start, interval, 0);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    //定时器唯一标示
    NSString *name = [NSString stringWithFormat:@"%zd",timers_.count];
    
    //存储任务
    [timers_ setValue:timer forKey:name];
    
    dispatch_semaphore_signal(semaphore_);
    
    
    dispatch_source_set_event_handler(timer, ^{
        //处理回调
        task();
        //判断是否重复
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    
    //开启定时器
    dispatch_resume(timer);

    return name;
    
}


+ (NSString *)execTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    if (!target || !selector) {
        return nil;
    }
    
    return [self execTask:^{
        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
           
        }
    } start:start interval:interval repeats:repeats async:async];
    
    
}


/**
 取消任务
 
 @param taskName 任务名称（创建时返回）
 */
+ (void)cancelTask:(NSString *)taskName {
    if (taskName.length == 0) {
        NSLog(@"Can not  found task");
        return;
    }
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[taskName];
    if (!timer) {
        NSLog(@"Can not  found task");
        return;
    }
    dispatch_source_cancel(timer);
    
    [timers_ removeObjectForKey:taskName];
    NSLog(@"Task canceled!");
    dispatch_semaphore_signal(semaphore_);
}

@end
