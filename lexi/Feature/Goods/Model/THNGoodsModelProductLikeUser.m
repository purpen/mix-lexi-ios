//
//	THNGoodsModelProductLikeUser.m
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelProductLikeUser.h"

NSString *const kTHNGoodsModelProductLikeUserAboutMe = @"about_me";
NSString *const kTHNGoodsModelProductLikeUserArea = @"area";
NSString *const kTHNGoodsModelProductLikeUserAreaId = @"area_id";
NSString *const kTHNGoodsModelProductLikeUserAreacode = @"areacode";
NSString *const kTHNGoodsModelProductLikeUserAvatar = @"avatar";
NSString *const kTHNGoodsModelProductLikeUserAvatarId = @"avatar_id";
NSString *const kTHNGoodsModelProductLikeUserCity = @"city";
NSString *const kTHNGoodsModelProductLikeUserCityId = @"city_id";
NSString *const kTHNGoodsModelProductLikeUserCountry = @"country";
NSString *const kTHNGoodsModelProductLikeUserCountryId = @"country_id";
NSString *const kTHNGoodsModelProductLikeUserCreatedAt = @"created_at";
NSString *const kTHNGoodsModelProductLikeUserDate = @"date";
NSString *const kTHNGoodsModelProductLikeUserDescriptionField = @"description";
NSString *const kTHNGoodsModelProductLikeUserEmail = @"email";
NSString *const kTHNGoodsModelProductLikeUserGender = @"gender";
NSString *const kTHNGoodsModelProductLikeUserIsDistributor = @"is_distributor";
NSString *const kTHNGoodsModelProductLikeUserLastSeen = @"last_seen";
NSString *const kTHNGoodsModelProductLikeUserLastStoreRid = @"last_store_rid";
NSString *const kTHNGoodsModelProductLikeUserMail = @"mail";
NSString *const kTHNGoodsModelProductLikeUserMasterUid = @"master_uid";
NSString *const kTHNGoodsModelProductLikeUserMobile = @"mobile";
NSString *const kTHNGoodsModelProductLikeUserPhone = @"phone";
NSString *const kTHNGoodsModelProductLikeUserProvince = @"province";
NSString *const kTHNGoodsModelProductLikeUserProvinceId = @"province_id";
NSString *const kTHNGoodsModelProductLikeUserStreetAddress = @"street_address";
NSString *const kTHNGoodsModelProductLikeUserTown = @"town";
NSString *const kTHNGoodsModelProductLikeUserTownId = @"town_id";
NSString *const kTHNGoodsModelProductLikeUserUid = @"uid";
NSString *const kTHNGoodsModelProductLikeUserUserAreacode = @"user_areacode";
NSString *const kTHNGoodsModelProductLikeUserUsername = @"username";

@interface THNGoodsModelProductLikeUser ()
@end
@implementation THNGoodsModelProductLikeUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelProductLikeUserAboutMe] isKindOfClass:[NSNull class]]){
		self.aboutMe = dictionary[kTHNGoodsModelProductLikeUserAboutMe];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserArea] isKindOfClass:[NSNull class]]){
		self.area = dictionary[kTHNGoodsModelProductLikeUserArea];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserAreaId] isKindOfClass:[NSNull class]]){
		self.areaId = [dictionary[kTHNGoodsModelProductLikeUserAreaId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserAreacode] isKindOfClass:[NSNull class]]){
		self.areacode = dictionary[kTHNGoodsModelProductLikeUserAreacode];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserAvatar] isKindOfClass:[NSNull class]]){
		self.avatar = dictionary[kTHNGoodsModelProductLikeUserAvatar];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserAvatarId] isKindOfClass:[NSNull class]]){
		self.avatarId = [dictionary[kTHNGoodsModelProductLikeUserAvatarId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNGoodsModelProductLikeUserCity];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserCityId] isKindOfClass:[NSNull class]]){
		self.cityId = [dictionary[kTHNGoodsModelProductLikeUserCityId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserCountry] isKindOfClass:[NSNull class]]){
		self.country = dictionary[kTHNGoodsModelProductLikeUserCountry];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserCountryId] isKindOfClass:[NSNull class]]){
		self.countryId = [dictionary[kTHNGoodsModelProductLikeUserCountryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = [dictionary[kTHNGoodsModelProductLikeUserCreatedAt] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserDate] isKindOfClass:[NSNull class]]){
		self.date = dictionary[kTHNGoodsModelProductLikeUserDate];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserDescriptionField] isKindOfClass:[NSNull class]]){
		self.descriptionField = dictionary[kTHNGoodsModelProductLikeUserDescriptionField];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserEmail] isKindOfClass:[NSNull class]]){
		self.email = dictionary[kTHNGoodsModelProductLikeUserEmail];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserGender] isKindOfClass:[NSNull class]]){
		self.gender = [dictionary[kTHNGoodsModelProductLikeUserGender] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserIsDistributor] isKindOfClass:[NSNull class]]){
		self.isDistributor = [dictionary[kTHNGoodsModelProductLikeUserIsDistributor] boolValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserLastSeen] isKindOfClass:[NSNull class]]){
		self.lastSeen = [dictionary[kTHNGoodsModelProductLikeUserLastSeen] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserLastStoreRid] isKindOfClass:[NSNull class]]){
		self.lastStoreRid = dictionary[kTHNGoodsModelProductLikeUserLastStoreRid];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserMail] isKindOfClass:[NSNull class]]){
		self.mail = dictionary[kTHNGoodsModelProductLikeUserMail];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserMasterUid] isKindOfClass:[NSNull class]]){
		self.masterUid = [dictionary[kTHNGoodsModelProductLikeUserMasterUid] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserMobile] isKindOfClass:[NSNull class]]){
		self.mobile = dictionary[kTHNGoodsModelProductLikeUserMobile];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserPhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[kTHNGoodsModelProductLikeUserPhone];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kTHNGoodsModelProductLikeUserProvince];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserProvinceId] isKindOfClass:[NSNull class]]){
		self.provinceId = [dictionary[kTHNGoodsModelProductLikeUserProvinceId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelProductLikeUserStreetAddress] isKindOfClass:[NSNull class]]){
		self.streetAddress = dictionary[kTHNGoodsModelProductLikeUserStreetAddress];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserTown] isKindOfClass:[NSNull class]]){
		self.town = dictionary[kTHNGoodsModelProductLikeUserTown];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserTownId] isKindOfClass:[NSNull class]]){
		self.townId = dictionary[kTHNGoodsModelProductLikeUserTownId];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kTHNGoodsModelProductLikeUserUid];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserUserAreacode] isKindOfClass:[NSNull class]]){
		self.userAreacode = dictionary[kTHNGoodsModelProductLikeUserUserAreacode];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUserUsername] isKindOfClass:[NSNull class]]){
		self.username = dictionary[kTHNGoodsModelProductLikeUserUsername];
	}	
	return self;
}
@end
