//
//  TableViewController.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "StoreTableViewController.h"
#import "Notifications.h"
#include "Store.h"
#import "StoreTableViewCell.h"
#import "ImageFetcher.h"
#import "AppDelegate.h"
#import "StoreDetailsViewController.h"
#import "LocalizedStrings.h"

#define TABLE_VIEW_NIB @"StoreTableViewController"
#define CELL_IDENTIFIER @"Store Cell"
#define CELL_VIEW_NIB @"StoreTableViewCell"

@interface StoreTableViewController () <NSFetchedResultsControllerDelegate>

@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL beganUpdates;
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@end


@implementation StoreTableViewController

-(instancetype)initFromNib
{
    self = [super initWithNibName:TABLE_VIEW_NIB bundle:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDatabaseAvailabilitiyNotification
                                                      object:nil
                                                       queue:nil usingBlock:^(NSNotification *note) {
                                                           self.managedObjectContext = [note.userInfo valueForKey:StoreDatabaseAvailabilitiyContext];
                                                       }];
    

    [self.tableView registerNib:[UINib nibWithNibName:CELL_VIEW_NIB bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.title = STORE_TAB_TITLE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] initWithEntityName:@"Store"] autorelease];
    request.predicate = nil;
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreTableViewCell *cell = (StoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    Store *store =  [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell prepareCelltoDisplayWithStore:store];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *store =  [self.fetchedResultsController objectAtIndexPath:indexPath];
    StoreDetailsViewController *detailsViewController = [[[StoreDetailsViewController alloc] initWithStore:store] autorelease];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController) {
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        if (error) {
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        }
    }
    [self.tableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = [newfrc retain];
        [oldfrc release];
        newfrc.delegate = self;

        if (newfrc) {
            [self performFetch];
        } else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            default:
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableView endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

-(void)dealloc
{
    [_fetchedResultsController release];
    [super dealloc];
}

@end
