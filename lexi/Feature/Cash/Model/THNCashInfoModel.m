//
//	THNCashInfoModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCashInfoModel.h"

NSString *const kTHNCashInfoModelActualAmount = @"actual_amount";
NSString *const kTHNCashInfoModelArrivalTime = @"arrival_time";
NSString *const kTHNCashInfoModelCreatedAt = @"created_at";
NSString *const kTHNCashInfoModelReceiveTarget = @"receive_target";
NSString *const kTHNCashInfoModelRid = @"rid";
NSString *const kTHNCashInfoModelStatus = @"status";
NSString *const kTHNCashInfoModelUserAccount = @"user_account";

@interface THNCashInfoModel ()
@end
@implementation THNCashInfoModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCashInfoModelActualAmount] isKindOfClass:[NSNull class]]){
		self.actualAmount = [dictionary[kTHNCashInfoModelActualAmount] floatValue];
	}

	if(![dictionary[kTHNCashInfoModelArrivalTime] isKindOfClass:[NSNull class]]){
		self.arrivalTime = [dictionary[kTHNCashInfoModelArrivalTime] integerValue];
	}

	if(![dictionary[kTHNCashInfoModelCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = [dictionary[kTHNCashInfoModelCreatedAt] integerValue];
	}

	if(![dictionary[kTHNCashInfoModelReceiveTarget] isKindOfClass:[NSNull class]]){
		self.receiveTarget = [dictionary[kTHNCashInfoModelReceiveTarget] integerValue];
	}

	if(![dictionary[kTHNCashInfoModelRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNCashInfoModelRid];
	}	
	if(![dictionary[kTHNCashInfoModelStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNCashInfoModelStatus] integerValue];
	}

	if(![dictionary[kTHNCashInfoModelUserAccount] isKindOfClass:[NSNull class]]){
		self.userAccount = dictionary[kTHNCashInfoModelUserAccount];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNCashInfoModelActualAmount] = @(self.actualAmount);
	dictionary[kTHNCashInfoModelArrivalTime] = @(self.arrivalTime);
	dictionary[kTHNCashInfoModelCreatedAt] = @(self.createdAt);
	dictionary[kTHNCashInfoModelReceiveTarget] = @(self.receiveTarget);
	if(self.rid != nil){
		dictionary[kTHNCashInfoModelRid] = self.rid;
	}
	dictionary[kTHNCashInfoModelStatus] = @(self.status);
	if(self.userAccount != nil){
		dictionary[kTHNCashInfoModelUserAccount] = self.userAccount;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:@(self.actualAmount) forKey:kTHNCashInfoModelActualAmount];	[aCoder encodeObject:@(self.arrivalTime) forKey:kTHNCashInfoModelArrivalTime];	[aCoder encodeObject:@(self.createdAt) forKey:kTHNCashInfoModelCreatedAt];	[aCoder encodeObject:@(self.receiveTarget) forKey:kTHNCashInfoModelReceiveTarget];	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNCashInfoModelRid];
	}
	[aCoder encodeObject:@(self.status) forKey:kTHNCashInfoModelStatus];	if(self.userAccount != nil){
		[aCoder encodeObject:self.userAccount forKey:kTHNCashInfoModelUserAccount];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.actualAmount = [[aDecoder decodeObjectForKey:kTHNCashInfoModelActualAmount] integerValue];
	self.arrivalTime = [[aDecoder decodeObjectForKey:kTHNCashInfoModelArrivalTime] integerValue];
	self.createdAt = [[aDecoder decodeObjectForKey:kTHNCashInfoModelCreatedAt] integerValue];
	self.receiveTarget = [[aDecoder decodeObjectForKey:kTHNCashInfoModelReceiveTarget] integerValue];
	self.rid = [aDecoder decodeObjectForKey:kTHNCashInfoModelRid];
	self.status = [[aDecoder decodeObjectForKey:kTHNCashInfoModelStatus] integerValue];
	self.userAccount = [aDecoder decodeObjectForKey:kTHNCashInfoModelUserAccount];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCashInfoModel *copy = [THNCashInfoModel new];

	copy.actualAmount = self.actualAmount;
	copy.arrivalTime = self.arrivalTime;
	copy.createdAt = self.createdAt;
	copy.receiveTarget = self.receiveTarget;
	copy.rid = [self.rid copy];
	copy.status = self.status;
	copy.userAccount = [self.userAccount copy];

	return copy;
}
@end
