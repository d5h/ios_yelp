//
//  Business.m
//  Yelp
//
//  Created by Dan Hipschman on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"
#import "Constants.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
        
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        NSArray *addresses = [dictionary valueForKeyPath:@"location.address"];
        NSString *street = @"No address";
        if (addresses.count > 0) {
            street = addresses[0];
        }
        NSString *neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
        self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood];
        
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        self.distance = [dictionary[@"distance"] integerValue] * MilesPerMeter;
    }
    
    return self;
}

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        
        [businesses addObject:business];
    }
    
    return businesses;
}

@end
