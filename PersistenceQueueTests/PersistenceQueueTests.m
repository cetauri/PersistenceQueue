//
//  PersistenceQueueTests.m
//  PersistenceQueueTests
//
//  Created by cetauri on 12. 8. 2..
//  Copyright (c) 2012년 cetauri. All rights reserved.
//

#import "PersistenceQueueTests.h"
#import "PersistenceQueue.h"
@implementation PersistenceQueueTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    
    PersistenceQueue *queue = [PersistenceQueue getSharedInstance];
    
    NSLog(@"queue count : %i", [queue count]);
    STAssertTrue([queue count] == 0, nil);
    
    [queue push:@"aaaa"];
    [queue push:@"bbb"];
    [queue push:@"ccc"];
    
    STAssertTrue([queue count] == 3, nil);
    
    int count = queue.count;
    for (int i = 0;i<count;i++){
        NSLog(@"queue : %@", [queue pop]);
        [queue deleteOldest];
    }

    
    NSLog(@"queue count : %i", [queue count]);
}

@end
