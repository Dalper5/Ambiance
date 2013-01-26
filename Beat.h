//
//  Beat.h
//  Ambiance
//
//  Created by dalperovich on 1/23/13.
//  Copyright (c) 2013 Ambiance. All rights reserved.
//

@interface Beat : NSObject
    @property (nonatomic, copy) NSNumber *BeatId;
    @property (nonatomic, copy) NSString *PlaceName;
    @property (nonatomic, copy) NSString *GPS;
    @property (nonatomic, copy) NSString *City;
    @property (nonatomic, copy) NSString *State;
    @property (nonatomic, copy) NSString *Zip;
    @property (nonatomic, copy) NSString *Self;
@end
