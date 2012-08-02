//
// Created by cetauri on 12. 8. 2..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PersistenceQueue : NSObject

+ (PersistenceQueue *)getSharedInstance;
- (void)removeOldest;
- (void)removeAll;
- (id)pop;
- (void)push:(id)obj;
- (int)count;
- (NSString *)description;
- (void)save;
@end