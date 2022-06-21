//
//  Movie.m
//  Flixter
//
//  Created by Oore Fasawe on 6/21/22.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullbackdropURLString = [baseURLString stringByAppendingString:backdropURLString];

    
    self.posterURL = [NSURL URLWithString:fullPosterURLString];
    self.backdropURL= [NSURL URLWithString:fullbackdropURLString];
    
    
    return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries{
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc]initWithDictionary:dictionary];
        [movies addObject:movie];
//                   NSLog(@"%@", self.movies[0].title);
    }
    NSArray *moviesArray = [movies copy];
    
    return moviesArray;
}

@end
