#_author_：张三香 2016.09.05

Feature: 添加新商品
	"""
		1、添加商品保存成后，页面跳转到待售商品列表
		2、添加商品的steps中增加了字段"create_time"（页面没有该字段，但是待售商品列表需要显示该字段）
		3、获取商品详情的steps中增加了"status"字段（来区分是从"待售/在售"商品列表去查看商品的详情）
	"""

Background:
	Given jobs登录系统
	#添加商品分组
		When jobs添加商品分组
			"""
			{
				"name": "分组1"
			}
			"""
		When jobs添加商品分组
			"""
			{
				"name": "分组2"
			}
			"""
		When jobs添加商品分组
			"""
			{
				"name": "分组3"
			}
			"""
	#添加商品规格
		When jobs添加商品规格
			"""
			{
				"name": "颜色",
				"type": "图片",
				"values": [{
					"name": "黑色",
					"image": "/standard_static/test_resource_img/hangzhou1.jpg"
				},{
					"name": "白色",
					"image": "/standard_static/test_resource_img/hangzhou2.jpg"
				}]
			}
			"""
		When jobs添加商品规格
			"""
			{
				"name": "尺寸",
				"type": "文本",
				"values": [{
					"name": "M"
				},{
					"name": "S"
				}]
			}
			"""
	#添加支付方式
		When jobs添加支付方式
			"""
			{
				"type": "微信支付",
				"is_active": "启用"
			}
			"""
		When jobs添加支付方式
			"""
			{
				"type": "支付宝",
				"is_active": "启用"
			}
			"""
		When jobs添加支付方式
			"""
			{
				"type": "货到付款",
				"is_active": "启用"
			}
			"""
	#添加运费配置
		When jobs添加邮费配置
			"""
			{
				"name":"顺丰",
				"first_weight":1,
				"first_weight_price":15.00,
				"added_weight":1,
				"added_weight_price":5.00
			}
			"""
		When jobs添加邮费配置
			"""
			{
				"name" : "圆通",
				"first_weight":1,
				"first_weight_price":10.00
			}
			"""
		When jobs选择'顺丰'运费配置

@product @addProduct
Scenario:1 添加新商品
	Given jobs登录系统
	#无规格商品1（统一运费0.00）
	When jobs添加商品
		"""
		{
			"name": "无规格商品1",
			"promotion_title": "无规格商品",
			"category": ["分组1","分组2","分组3"],
			"bar_code":"1234",
			"min_limit":1,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"url": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"url": "/standard_static/test_resource_img/hangzhou3.jpg"
			}],
			"is_enable_model":false,
			"user_code":"1111",
			"price": 11.12,
			"weight": 5.0,
			"stock_type": "无限",
			"postage":0.00,
			"pay_interfaces":
				[{
					"type": "在线支付"
				},{
					"type": "货到付款"
				}],
			"invoice":false,
			"distribution_time":false,
			"properties": [{
					"name": "CPU",
					"description": "CPU描述"
				},{
					"name": "内存",
					"description": "内存描述"
				}],
			"detail": "商品描述信息1",
			"create_time":"2016-09-05 10:00"
		}
		"""
	#多规格商品2（统一运费2.00）
	When jobs添加商品
		"""
		{
			"name": "多规格商品2",
			"promotion_title": "多规格商品",
			"categroy":[],
			"bar_code":"2234",
			"min_limit":2,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			}],
			"is_enable_model": true,
			"model": {
				"models": {
					"黑色 S": {
						"user_code":"2111",
						"price": 10.00,
						"weight": 3.1,
						"stock_type": "有限",
						"stocks": 3
					},
					"白色 S": {
						"user_code":"",
						"price": 9.10,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			},
			"postage":2.00,
			"pay_interfaces":
				[{
					"type": "在线支付"
				}],
			"invoice":false,
			"distribution_time":false,
			"properties": [{
					"name": "CPU",
					"description": "CPU描述"
				},{
					"name": "内存",
					"description": "内存描述"
				}],
			"detail": "商品描述信息2",
			"create_time":"2016-09-05 10:05"
		}
		"""
	#无规格商品3（运费模板-顺丰）
	When jobs添加商品
		"""
		{
			"name": "无规格商品3",
			"promotion_title": "无规格商品3",
			"category": ["分组1"],
			"bar_code":"3234",
			"min_limit":1,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			}],
			"is_enable_model":false,
			"user_code":"3111",
			"price": 30.00,
			"weight": 1.0,
			"stock_type": "无限",
			"postage":"顺丰",
			"pay_interfaces":
				[{
					"type": "在线支付"
				},{
					"type": "货到付款"
				}],
			"invoice":false,
			"distribution_time":false,
			"properties": [{
					"name": "CPU",
					"description": "CPU描述"
				},{
					"name": "内存",
					"description": "内存描述"
				}],
			"detail": "商品描述信息3",
			"create_time":"2016-09-05 10:10"
		}
		"""
	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{
					"name": "无规格商品3",
					"swipe_images": [{
						"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					}],
					"user_code":"3111"
				},
			"bar_code":"3234",
			"category": ["分组1"],
			"is_enable_model":false,
			"price":"30.00",
			"stock": "无限",
			"sales":0,
			"create_time":"2016-09-05 10:10",
			"actions":["修改","上架","彻底删除"]
		},{
			"product_info":{
				"name": "多规格商品2",
				"swipe_images": [{
					"url": "/standard_static/test_resource_img/hangzhou1.jpg"
				}],
				"model": {
					"models": {
						"黑色 S": {
							"user_code":"2111",
							"price": 10.00,
							"stock_type": "有限",
							"stocks": 3
						},
						"白色 S": {
							"user_code":"",
							"price": 9.10,
							"stock_type": "无限"
							}
						}
					}
				},
			"is_enable_model": true,
			"bar_code":"2234",
			"categroy":[],
			"price":"9.10-10.00",
			"stock":"",
			"sales":0,
			"create_time":"2016-09-05 10:05",
			"actions":["修改","上架","彻底删除"]
		},{
			"product_info":{
					"name": "无规格商品1",
					"swipe_images": [{
						"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					}],
					"user_code":"1111"
				},
			"bar_code":"1234",
			"category": ["分组1","分组2","分组3"],
			"is_enable_model":false,
			"price":"11.12",
			"stock": "无限",
			"sales":0,
			"create_time":"2016-09-05 10:00",
			"actions":["修改","上架","彻底删除"]
		}]
		"""
	Then jobs能获取商品'无规格商品1'
		"""
		{
			"name": "无规格商品1",
			"promotion_title": "无规格商品",
			"category": ["分组1","分组2","分组3"],
			"bar_code":"1234",
			"min_limit":1,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"url": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"url": "/standard_static/test_resource_img/hangzhou3.jpg"
			}],
			"is_enable_model":false,
			"user_code":"1111",
			"price": 11.12,
			"weight": 5.0,
			"stock_type": "无限",
			"postage":0.00,
			"pay_interfaces":
				[{
					"type": "在线支付"
				},{
					"type": "货到付款"
				}],
			"invoice":false,
			"distribution_time":false,
			"detail": "商品描述信息1",
			"properties": [{
					"name": "CPU",
					"description": "CPU描述"
				},{
					"name": "内存",
					"description": "内存描述"
				}],
			"status": "待售"
		}
		"""
	And jobs能获取商品'多规格商品2'
		"""
		{
			"name": "多规格商品2",
			"promotion_title": "多规格商品",
			"categroy":[],
			"bar_code":"2234",
			"min_limit":2,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			}],
			"is_enable_model": true,
			"model": {
				"models": {
					"黑色 S": {
						"price": 10.00,
						"weight": 3.1,
						"stock_type": "有限",
						"stocks": 3
						},
					"白色 S": {
						"price": 9.10,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			},
			"postage":2.00,
			"pay_interfaces":
				[{
					"type": "在线支付"
				}],
			"invoice":false,
			"distribution_time":false,
			"detail": "商品描述信息2",
			"properties": [{
					"name": "CPU",
					"description": "CPU描述"
				},{
					"name": "内存",
					"description": "内存描述"
				}],
			"status": "待售"
		}
		"""
	And jobs能获取商品'无规格商品3'
		"""
		{
			"name": "无规格商品3",
			"promotion_title": "无规格商品3",
			"category": ["分组1"],
			"bar_code":"3234",
			"min_limit":1,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			}],
			"is_enable_model":false,
			"user_code":"3111",
			"price": 30.00,
			"weight": 1.0,
			"stock_type": "无限",
			"postage":"顺丰",
			"pay_interfaces":
				[{
					"type": "在线支付"
				},{
					"type": "货到付款"
				}],
			"invoice":false,
			"distribution_time":false,
			"properties": [{
					"name": "CPU",
					"description": "CPU描述"
				},{
					"name": "内存",
					"description": "内存描述"
				}],
			"detail": "商品描述信息3",
			"status":"待售"
		}
		"""

#_author_:冯雪静
@product @addProduct
Scenario:2 添加有会员折扣的商品
	jobs添加会员折扣的商品后，能获取他添加的商品

	#系统默认一个会员等级"普通会员"、"自动升级"、
	#"所有关注过您的公众号的用户"、"购物折扣：10.0"
	When jobs添加会员等级
		"""
		[{
			"name": "铜牌会员",
			"upgrade": "手动升级",
			"discount": "9"
		}, {
			"name": "银牌会员",
			"upgrade": "手动升级",
			"discount": "8"
		}, {
			"name": "金牌会员",
			"upgrade": "手动升级",
			"discount": "7"
		}]
		"""

	#添加的商品使用了会员等级折扣
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name": "商品1",
			"is_member_product":true,
			"price": 100.00,
			"stock_type": "有限",
			"stocks": 2
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品2",
			"is_member_product":true,
			"is_enable_model":true,
			"model": {
				"models":{
					"M": {
						"price": 300.00,
						"stock_type": "无限"
					},
					"S": {
						"price": 300.00,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	Then jobs能获取商品'商品1'
		"""
		{
			"name": "商品1",
			"is_member_product":true,
			"status":"待售"
		}
		"""
	Then jobs能获取商品'商品2'
		"""
		{
			"name": "商品2",
			"is_member_product":true,
			"status":"待售"
		}
		"""

#_author_:王丽 2016.01.20
@product @addProduct
Scenario:3 添加'配送时间'配置的商品
	Jobs添加商品后，能获取他添加的商品
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name": "红烧肉",
			"price": 12.00,
			"stock_type": "有限",
			"stocks": 3,
			"distribution_time":true
		}
		"""
	Then jobs能获取商品'红烧肉'
		"""
		{
			"name": "红烧肉",
			"distribution_time":true,
			"status": "待售"
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "红烧肉-无配送时间",
			"price": 12.00,
			"stock_type": "有限",
			"stocks": 3,
			"distribution_time":false
		}
		"""
	Then jobs能获取商品'红烧肉-无配送时间'
		"""
		{
			"name": "红烧肉-无配送时间",
			"distribution_time":false,
			"status": "待售"
		}
		"""

#_author_:张三香 2016.01.20
@product @addProduct
Scenario:4 添加无规格新商品,支持开票
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name": "支持开票商品",
			"invoice":true,
			"price": 12.00,
			"stock_type": "有限",
			"stocks": 3
		}
		"""
	Then jobs能获取商品'支持开票商品'
		"""
		{
			"name": "支持开票商品",
			"invoice":true,
			"status":"待售"
		}
		"""

@product @addProduct 
Scenario:5 添加多规格新商品,支持开票
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name": "多规格支持开票",
			"is_enable_model":true,
			"invoice":true,
			"model": {
				"models": {
					"黑色 S": {
						"price": 10.00,
						"weight": 3.1,
						"stock_type": "有限",
						"stocks": 3
					},
					"白色 S": {
						"price": 9.10,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	Then jobs能获取商品'多规格支持开票'
		"""
		{
			"name":"多规格支持开票",
			"invoice":true,
			"status":"待售"
		}
		"""

@product @addProduct 
Scenario:6 添加新商品,不支持开票
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name": "不支持开票商品",
			"invoice":false,
			"price": 12.00,
			"stock_type": "有限",
			"stocks": 3
		}
		"""
	Then jobs能获取商品'不支持开票商品'
		"""
		{
			"name": "不支持开票商品",
			"invoice":false,
			"status":"待售"
		}
		"""
