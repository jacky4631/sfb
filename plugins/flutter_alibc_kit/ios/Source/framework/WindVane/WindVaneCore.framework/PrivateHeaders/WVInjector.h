/*
 * WVInjector.h
 *  
 * Created by WindVane.
 * Copyright (c) 2014年 阿里巴巴-无线事业部. All rights reserved.
 */

#import <WindVaneCore/WVAssert.h>
#import <pthread.h>

#pragma mark - STATIC_SYNC_PROP

/**
 * 定义静态同步属性。
 *
 * @param NAME 属性的名称。
 */
#define WV_DEFINE_STATIC_SYNC_PROP(NAME, TYPE)                        \
	static pthread_mutex_t _mutex_##NAME = PTHREAD_MUTEX_INITIALIZER; \
	static TYPE _##NAME;

/**
 * 设置静态同步属性。
 *
 * @param NAME  属性的名称。
 * @param VALUE 属性的值。
 */
#define WV_SET_SYNC_PROP(NAME, VALUE)         \
	do {                                      \
		pthread_mutex_lock(&_mutex_##NAME);   \
		_##NAME = VALUE;                      \
		pthread_mutex_unlock(&_mutex_##NAME); \
	} while (false)

#define WV_ADD_SYNC_PROP_IMPL(NAME, MUTABLE_TYPE, FACTORY, VALUE, L) ({          \
	BOOL __NSX_PASTE__(__r, L) = NO;                                             \
	__typeof__(VALUE) __NSX_PASTE__(__value, L) = (VALUE);                       \
	pthread_mutex_lock(&_mutex_##NAME);                                          \
	if (![_##NAME containsObject:__NSX_PASTE__(__value, L)]) {                   \
		MUTABLE_TYPE * __NSX_PASTE__(__arr, L) = [MUTABLE_TYPE FACTORY:_##NAME]; \
		__NSX_PASTE__(__r, L) = YES;                                             \
		[__NSX_PASTE__(__arr, L) addObject:__NSX_PASTE__(__value, L)];           \
		_##NAME = __NSX_PASTE__(__arr, L);                                       \
	}                                                                            \
	pthread_mutex_unlock(&_mutex_##NAME);                                        \
	__NSX_PASTE__(__r, L);                                                       \
})

/**
 * 向静态同步数组添加值。
 *
 * @param NAME  属性的名称。
 * @param VALUE 要添加的值。
 */
#define WV_ADD_SYNC_ARRAY(NAME, VALUE) WV_ADD_SYNC_PROP_IMPL(NAME, NSMutableArray, arrayWithArray, VALUE, __COUNTER__)

/**
 * 向静态同步集合添加值。
 *
 * @param NAME  属性的名称。
 * @param VALUE 要添加的值。
 */
#define WV_ADD_SYNC_SET(NAME, VALUE) WV_ADD_SYNC_PROP_IMPL(NAME, NSMutableSet, setWithSet, VALUE, __COUNTER__)

#define WV_REMOVE_SYNC_PROP_IMPL(NAME, MUTABLE_TYPE, FACTORY, VALUE, L) ({       \
	__typeof__(VALUE) __NSX_PASTE__(__value, L) = (VALUE);                       \
	pthread_mutex_lock(&_mutex_##NAME);                                          \
	if ([_##NAME containsObject:__NSX_PASTE__(__value, L)]) {                    \
		MUTABLE_TYPE * __NSX_PASTE__(__arr, L) = [MUTABLE_TYPE FACTORY:_##NAME]; \
		[__NSX_PASTE__(__arr, L) removeObject:__NSX_PASTE__(__value, L)];        \
		_##NAME = __NSX_PASTE__(__arr, L);                                       \
	}                                                                            \
	pthread_mutex_unlock(&_mutex_##NAME);                                        \
})

/**
 * 从静态同步数组移除值。
 *
 * @param NAME  属性的名称。
 * @param VALUE 要移除的值。
 */
#define WV_REMOVE_SYNC_ARRAY(NAME, VALUE) WV_REMOVE_SYNC_PROP_IMPL(NAME, NSMutableArray, arrayWithArray, VALUE, __COUNTER__)

#define WV_GET_SYNC_PROP_IMPL(NAME, L) ({      \
	__typeof__(_##NAME) __NSX_PASTE__(__x, L); \
	pthread_mutex_lock(&_mutex_##NAME);        \
	__NSX_PASTE__(__x, L) = _##NAME;           \
	pthread_mutex_unlock(&_mutex_##NAME);      \
	__NSX_PASTE__(__x, L);                     \
})

/**
 * 获取静态同步属性。
 *
 * @param NAME 属性的名称。
 */
#define WV_GET_SYNC_PROP(NAME) WV_GET_SYNC_PROP_IMPL(NAME, __COUNTER__)

/**
 * 定义一对实例注入方法。
 *
 * @param NAME     实例注入方法的名称，会自动添加 register/registered 前缀。
 * @param PROTOCOL 实例要实现的协议。
 */
#define WV_INJECTION_DEFINE(NAME, PROTOCOL)         \
	WV_DEFINE_STATIC_SYNC_PROP(NAME, id<PROTOCOL>)  \
	+(void)register##NAME : (id<PROTOCOL>)handler { \
		if (!handler) {                             \
			return;                                 \
		}                                           \
		WVAssertProtocol(handler, PROTOCOL);        \
		WV_SET_SYNC_PROP(NAME, handler);            \
	}                                               \
	+(id<PROTOCOL>)registered##NAME {               \
		return WV_GET_SYNC_PROP(NAME);              \
	}
