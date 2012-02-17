//
//  C4Foundation.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

@interface C4Foundation : NSObject {
    NSComparator floatSortComparator;
}

+(C4Foundation *)sharedManager;
void C4Log(NSString *logString,...);

+(NSComparator)floatComparator;
-(NSComparator)floatComparator;

#pragma mark Foundation 
NSInteger   basicSort(id obj1, id obj2, void *context);
void        free_data(void *info, const void *data, size_t size);
void        CheckError(OSStatus error, const char *operation);

@end
