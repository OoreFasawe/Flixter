//
//  Movie.h
//  Flixter
//
//  Created by Oore Fasawe on 6/21/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL * posterURL;
@property (nonatomic, strong) NSString * synopsis;
@property (nonatomic, strong) NSURL * backdropURL;


- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
