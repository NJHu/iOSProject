
/**
 需要加载的数据类型
 */
typedef enum : NSUInteger {
    
    BSJTopicViewControllerTypeAll = 1,
    BSJTopicViewControllerTypePicture = 10,
    
    BSJTopicViewControllerTypeWord = 29,
    BSJTopicViewControllerTypeVoice = 31,
    
    BSJTopicViewControllerTypeVideo = 41,
} BSJTopicViewControllerType;



typedef enum : NSUInteger {
    BSJUserSexFemale = 1,
    BSJUserSexMale = 0,
} BSJUserSex;





/**
 *  百思不得姐的api
 */
UIKIT_EXTERN NSString *const BSJBaiSiJieHTTPAPI;



/**
 *  用户的性别, 服务器返回字段
 */
UIKIT_EXTERN NSString *const BSJUserSexFemaleStr;

/**
 *  用户的性别, 服务器返回字段
 */
UIKIT_EXTERN NSString *const BSJUserSexMaleStr;












