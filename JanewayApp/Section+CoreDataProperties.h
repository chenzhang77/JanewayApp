//
//  Section+CoreDataProperties.h
//  JanewayApp
//
//  Created by cz5670 on 2016-05-09.
//  Copyright © 2016 winemocol. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Section.h"

NS_ASSUME_NONNULL_BEGIN

@interface Section (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *lastSectionIndicator;
@property (nullable, nonatomic, retain) NSString *sectionDescription;
@property (nullable, nonatomic, retain) NSNumber *sectionID;
@property (nullable, nonatomic, retain) NSString *sectionImage;
@property (nullable, nonatomic, retain) NSString *sectionTitle;
@property (nullable, nonatomic, retain) NSString *sectionURL;
@property (nullable, nonatomic, retain) NSSet<Section *> *subSection;

@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addSubSectionObject:(Section *)value;
- (void)removeSubSectionObject:(Section *)value;
- (void)addSubSection:(NSSet<Section *> *)values;
- (void)removeSubSection:(NSSet<Section *> *)values;

@end

NS_ASSUME_NONNULL_END
