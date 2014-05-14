//
//  FailedBankInfo.h
//  CoreData
//
//  Created by Pablo on 05/05/14.
//  Copyright (c) 2014 Pablo Rueda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString *initials;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *accounts;

@end
