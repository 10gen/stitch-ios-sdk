#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)

#if defined(PERF_IOS_API_KEY)
#define __PERF_IOS_API_KEY @ STRINGIZE2(PERF_IOS_API_KEY)
#else
#define __PERF_IOS_API_KEY NULL
#endif

#if defined(PERF_IOS_NUM_ITERS)
#define __PERF_IOS_NUM_ITERS @ STRINGIZE2(PERF_IOS_NUM_ITERS)
#else
#define __PERF_IOS_NUM_ITERS NULL
#endif

#if defined(PERF_IOS_STITCH_HOST)
#define __PERF_IOS_STITCH_HOST @ STRINGIZE2(PERF_IOS_STITCH_HOST)
#else
#define __PERF_IOS_STITCH_HOST NULL
#endif

#if defined(PERF_IOS_HOSTNAME)
#define __PERF_IOS_HOSTNAME @ STRINGIZE2(PERF_IOS_HOSTNAME)
#else
#define __PERF_IOS_HOSTNAME NULL
#endif

#if defined(PERF_IOS_DOC_SIZES)
#define __PERF_IOS_DOC_SIZES @ STRINGIZE2(PERF_IOS_DOC_SIZES)
#else
#define __PERF_IOS_DOC_SIZES NULL
#endif

#if defined(PERF_IOS_NUM_DOCS)
#define __PERF_IOS_NUM_DOCS @ STRINGIZE2(PERF_IOS_NUM_DOCS)
#else
#define __PERF_IOS_NUM_DOCS NULL
#endif

#if defined(PERF_IOS_DATA_GRANULARITY)
#define __PERF_IOS_DATA_GRANULARITY @ STRINGIZE2(PERF_IOS_DATA_GRANULARITY)
#else
#define __PERF_IOS_DATA_GRANULARITY NULL
#endif

#if defined(PERF_IOS_NUM_OUTLIERS)
#define __PERF_IOS_NUM_OUTLIERS @ STRINGIZE2(PERF_IOS_NUM_OUTLIERS)
#else
#define __PERF_IOS_NUM_OUTLIERS NULL
#endif

#if defined(PERF_IOS_OUTPUT_STDOUT)
#define __PERF_IOS_OUTPUT_STDOUT @ STRINGIZE2(PERF_IOS_OUTPUT_STDOUT)
#else
#define __PERF_IOS_OUTPUT_STDOUT NULL
#endif

#if defined(PERF_IOS_OUTPUT_STITCH)
#define __PERF_IOS_OUTPUT_STITCH @ STRINGIZE2(PERF_IOS_OUTPUT_STITCH)
#else
#define __PERF_IOS_OUTPUT_STITCH NULL
#endif

#if defined(PERF_IOS_OUTPUT_RAW)
#define __PERF_IOS_OUTPUT_RAW @ STRINGIZE2((PERF_IOS_OUTPUT_RAW))
#else
#define __PERF_IOS_OUTPUT_RAW NULL
#endif

#if defined(PERF_IOS_CHANGE_EVENT_PERCENTAGES)
#define __PERF_IOS_CHANGE_EVENT_PERCENTAGES @ STRINGIZE2((PERF_IOS_CHANGE_EVENT_PERCENTAGES))
#else
#define __PERF_IOS_CHANGE_EVENT_PERCENTAGES NULL
#endif

#if defined(PERF_IOS_CONFLICT_PERCENTAGES)
#define __PERF_IOS_CONFLICT_PERCENTAGES @ STRINGIZE2((PERF_IOS_CONFLICT_PERCENTAGES))
#else
#define __PERF_IOS_CONFLICT_PERCENTAGES NULL
#endif

#import <Foundation/Foundation.h>

static NSString* __nullable const TEST_PERF_IOS_API_KEY = __PERF_IOS_API_KEY;
static NSString* __nullable const TEST_PERF_IOS_STITCH_HOST = __PERF_IOS_STITCH_HOST;
static NSString* __nullable const TEST_PERF_IOS_NUM_ITERS = __PERF_IOS_NUM_ITERS;
static NSString* __nullable const TEST_PERF_IOS_HOSTNAME = __PERF_IOS_HOSTNAME;
static NSString* __nullable const TEST_PERF_IOS_DOC_SIZES = __PERF_IOS_DOC_SIZES;
static NSString* __nullable const TEST_PERF_IOS_NUM_DOCS = __PERF_IOS_NUM_DOCS;
static NSString* __nullable const TEST_PERF_IOS_DATA_GRANULARITY = __PERF_IOS_DATA_GRANULARITY;
static NSString* __nullable const TEST_PERF_IOS_NUM_OUTLIERS = __PERF_IOS_NUM_OUTLIERS;
static NSString* __nullable const TEST_PERF_IOS_OUTPUT_STDOUT = __PERF_IOS_OUTPUT_STDOUT;
static NSString* __nullable const TEST_PERF_IOS_OUTPUT_STITCH = __PERF_IOS_OUTPUT_STITCH;
static NSString* __nullable const TEST_PERF_IOS_OUTPUT_RAW = __PERF_IOS_OUTPUT_RAW;
static NSString* __nullable const TEST_PERF_IOS_CHANGE_EVENT_PERCENTAGES = __PERF_IOS_CHANGE_EVENT_PERCENTAGES;
static NSString* __nullable const TEST_PERF_IOS_CONFLICT_PERCENTAGES = __PERF_IOS_CONFLICT_PERCENTAGES;
