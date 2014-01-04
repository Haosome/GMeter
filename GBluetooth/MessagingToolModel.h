//
//  MessagingToolModel.h
//  GBluetooth
//
//  Created by Hao Guo on 2012-10-20.
//
//

#import <Foundation/Foundation.h>

@interface MessagingToolModel : NSObject
+(NSString* )getFileContent: (NSString *)filename;
+(void)writeToFile:(NSString *)fileName contentToWrite:(NSString *)content;
+(NSArray *)requireList;
+(void)deleteAllFiles;
+(NSString *)getDirectory;
+(void)appendToFile:(NSString *)fileName contentToAppend:(NSString *)content;
@end
