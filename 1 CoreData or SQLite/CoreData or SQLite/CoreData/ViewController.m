//
//  ViewController.m
//  CoreData
//
//  Created by Pablo on 05/05/14.
//  Copyright (c) 2014 Pablo Rueda. All rights reserved.
//

#import "ViewController.h"
#import "Employee.h"
#import "Account.h"
#import "AppDelegate.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self firstQuery];
    
    [self secondQuery];
    
    [self thirdQuery];
}

//Employee with initials ‘PR’
//SELECT * FROM employees WHERE initials = ’PR’
- (void)firstQuery {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"initials == 'PR'"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
    NSLog(@"%@", results);
}

//Employees that have the account with id ‘MNS002’
//SELECT employees.* FROM employees JOIN employees_accounts ON employees_accounts.employee_id = employees.initials WHERE account_id = ‘118_00’
- (void)secondQuery {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accounts.code CONTAINS 'MNS002'"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
    NSLog(@"%@", results);
}

//Number of accounts where there is the employee with initials ‘PR’
//SELECT COUNT (*) FROM employees_accounts WHERE employee_id = 'PR'
- (void)thirdQuery {
    
    NSExpression *ex = [NSExpression expressionForFunction:@"count:" arguments:@[[NSExpression expressionForKeyPath:@"accounts.code"]]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"result"];
    [expressionDescription setExpression:ex];
    [expressionDescription setExpressionResultType:NSInteger64AttributeType];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"initials == 'PR'"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPropertiesToFetch:@[expressionDescription]];
    [request setResultType:NSDictionaryResultType];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
    NSDictionary *resultsDictionary = [results objectAtIndex:0];
    NSNumber *resultValue = [resultsDictionary objectForKey:@"result"];
    
    NSLog(@"%@", resultValue);
}

@end
