//
//	THNInviteAmountModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNInviteAmountModel.h"

NSString *const kTHNInviteAmountModelCashAmount = @"cash_amount";
NSString *const kTHNInviteAmountModelCumulativeCashAmount = @"cumulative_cash_amount";
NSString *const kTHNInviteAmountModelPendingPrice = @"pending_price";
NSString *const kTHNInviteAmountModelRewardPrice = @"reward_price";

@interface THNInviteAmountModel ()
@end
@implementation THNInviteAmountModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNInviteAmountModelCashAmount] isKindOfClass:[NSNull class]]){
		self.cashAmount = [dictionary[kTHNInviteAmountModelCashAmount] floatValue];
	}

	if(![dictionary[kTHNInviteAmountModelCumulativeCashAmount] isKindOfClass:[NSNull class]]){
		self.cumulativeCashAmount = [dictionary[kTHNInviteAmountModelCumulativeCashAmount] floatValue];
	}

	if(![dictionary[kTHNInviteAmountModelPendingPrice] isKindOfClass:[NSNull class]]){
		self.pendingPrice = [dictionary[kTHNInviteAmountModelPendingPrice] floatValue];
	}

	if(![dictionary[kTHNInviteAmountModelRewardPrice] isKindOfClass:[NSNull class]]){
		self.rewardPrice = [dictionary[kTHNInviteAmountModelRewardPrice] floatValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNInviteAmountModelCashAmount] = @(self.cashAmount);
	dictionary[kTHNInviteAmountModelCumulativeCashAmount] = @(self.cumulativeCashAmount);
	dictionary[kTHNInviteAmountModelPendingPrice] = @(self.pendingPrice);
	dictionary[kTHNInviteAmountModelRewardPrice] = @(self.rewardPrice);
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
	[aCoder encodeObject:@(self.cashAmount) forKey:kTHNInviteAmountModelCashAmount];	[aCoder encodeObject:@(self.cumulativeCashAmount) forKey:kTHNInviteAmountModelCumulativeCashAmount];	[aCoder encodeObject:@(self.pendingPrice) forKey:kTHNInviteAmountModelPendingPrice];	[aCoder encodeObject:@(self.rewardPrice) forKey:kTHNInviteAmountModelRewardPrice];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.cashAmount = [[aDecoder decodeObjectForKey:kTHNInviteAmountModelCashAmount] integerValue];
	self.cumulativeCashAmount = [[aDecoder decodeObjectForKey:kTHNInviteAmountModelCumulativeCashAmount] integerValue];
	self.pendingPrice = [[aDecoder decodeObjectForKey:kTHNInviteAmountModelPendingPrice] integerValue];
	self.rewardPrice = [[aDecoder decodeObjectForKey:kTHNInviteAmountModelRewardPrice] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNInviteAmountModel *copy = [THNInviteAmountModel new];

	copy.cashAmount = self.cashAmount;
	copy.cumulativeCashAmount = self.cumulativeCashAmount;
	copy.pendingPrice = self.pendingPrice;
	copy.rewardPrice = self.rewardPrice;

	return copy;
}
@end
