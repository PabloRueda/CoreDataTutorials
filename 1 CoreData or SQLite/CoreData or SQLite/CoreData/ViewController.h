//
//  ViewController.h
//  CoreData
//
//  Created by Pablo on 05/05/14.
//  Copyright (c) 2014 Pablo Rueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
