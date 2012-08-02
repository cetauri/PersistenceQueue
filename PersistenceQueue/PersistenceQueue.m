//
// Created by cetauri on 12. 8. 2..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PersistenceQueue.h"
#include <sys/xattr.h>

static PersistenceQueue *_queue;
@interface PersistenceQueue (){
    __block NSMutableArray *queue;
    NSObject *lock;
}
- (void)restore;
- (NSString *)filePath ;
@end

@implementation PersistenceQueue {

}

+ (PersistenceQueue *)getSharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _queue = [[PersistenceQueue alloc] init];
    });
    return _queue;
}

-(id)init {
    self = [super init];
    if (self){
        queue = [[NSMutableArray alloc] init];
    }

    [self restore];

    return self;
}

- (void)removeOldest{
    @synchronized (lock) {
        [queue removeObjectAtIndex:0];
    }
    [self save];
}
- (void)removeAll{
    @synchronized (lock) {
        [queue removeAllObjects];
    }
    [self save];
}
- (id)pop{
    @synchronized (lock) {
        return [queue objectAtIndex:0];
    }
}
- (void)push:(id)obj{
    @synchronized (lock) {
        [queue addObject:obj];
    }
    [self save];
}
- (int)count{
    return queue.count;
}

- (NSString *)description{
    return queue.description;
}

- (void)restore{
    @synchronized (lock) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
        if ([object isKindOfClass:[NSObject class]]) {
            queue = object;
        }
    }
}

- (void)save{
    @synchronized (lock) {
        NSString *path = [self filePath];
        [NSKeyedArchiver archiveRootObject:queue toFile:path];

        //skip iCloud backup
        const char* filePath = [path fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;

        setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        
    }
}


- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@".persistenceQueue"];
    return filePath;
}
@end