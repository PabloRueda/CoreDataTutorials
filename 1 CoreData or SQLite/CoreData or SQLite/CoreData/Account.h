//
//  FailedBankDetails.h
//  CoreData
//
//  Created by Pablo on 05/05/14.
//  Copyright (c) 2014 Pablo Rueda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *employees;

@end
