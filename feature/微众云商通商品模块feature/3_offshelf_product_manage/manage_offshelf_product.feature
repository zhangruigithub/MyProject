#editor:王丽 2015.10.13

Feature: 管理待售商品管理列表
	"""
		1、待售商品列表默认按照创建时间倒序显示，若商品上架后再下架则优先显示最后进入待售商品列表中的商品
		2、每页最多显示30条数据，多了则分页展示
		3、待售商品列表可对商品价格和商品库存进行修改
	"""

Background:
	Given 重置'apiserver'的bdd环境
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
	#添加商品
		When jobs添加商品
			"""
			{
				"name": "无规格商品1",
				"promotion_title": "无规格商品",
				"category": ["分组1","分组3"],
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
		When jobs添加商品
			"""
			{
				"name": "无规格商品3",
				"promotion_title": "无规格商品3",
				"category": ["分组3"],
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

@product @toSaleProduct
Scenario:1 浏览待售商品管理列表
	#待售商品列表为空
		Given nokia登录系统
		Then nokia能获得'待售'商品列表
			"""
			[]
			"""
	#待售商品列表非空
		Given jobs登录系统
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":
					{
						"name": "无规格商品3",
						"swipe_images": [{
							"url": "/standard_static/test_resource_img/hangzhou1.jpg"
						}],
						"user_code":"3111"
					},
				"bar_code":"3234",
				"category": ["分组3"],
				"is_enable_model":false,
				"price":"30.00",
				"stock": "无限",
				"sales":0,
				"create_time":"2016-09-05 10:10",
				"actions":["修改","上架","彻底删除"]
			},{
				"product_info":
					{
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
				"product_info":
					{
						"name": "无规格商品1",
						"swipe_images": [{
							"url": "/standard_static/test_resource_img/hangzhou1.jpg"
							}],
						"user_code":"1111"
					},
				"bar_code":"1234",
				"category": ["分组1","分组3"],
				"is_enable_model":false,
				"price":"11.12",
				"stock":"无限",
				"sales":0,
				"create_time":"2016-09-05 10:00",
				"actions":["修改","上架","彻底删除"]
			}]
			"""

@product @toSaleProduct
Scenario:2 上架商品
	jobs进行'批量上架'或'单个上架'后
	1. jobs的待售商品列表发生变化
	2. jobs的在售商品列表发生变化
	3. 手机端商品列表的变化
	4. 上架后再下架商品，查看待售商品列表

	Given jobs登录系统
	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name": "无规格商品3"}
		},{
			"product_info":{"name": "多规格商品2"}
		},{
			"product_info":{"name": "无规格商品1"}
		}]
		"""
	#单个上架商品
		When jobs批量上架商品
			"""
			["无规格商品1"]
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "无规格商品3"}
			},{
				"product_info":{"name": "多规格商品2"}
			}]
			"""
		And jobs能获得'在售'商品列表
			"""
			[{
				"product_info":{"name": "无规格商品1"}
			}]
			"""
		#手机端商品列表的校验
		When bill关注jobs的公众号::apiserver
		When bill访问jobs的webapp::apiserver
		And bill浏览jobs的webapp的'全部'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			| name        |
			| 无规格商品1 |
	#批量上架商品
		Given jobs登录系统
		When jobs批量上架商品
			"""
			["多规格商品2","无规格商品3"]
			"""
		Then jobs能获得'待售'商品列表
			"""
			[]
			"""
		Then jobs能获得'在售'商品列表
			"""
			[{
				"product_info":{"name": "无规格商品3"}
			},{
				"product_info":{"name": "多规格商品2"}
			},{
				"product_info":{"name": "无规格商品1"}
			}]
			"""
		#手机端商品列表的校验
		When bill访问jobs的webapp::apiserver
		And bill浏览jobs的webapp的'全部'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			| name        |
			| 无规格商品3 |
			| 多规格商品2 |
			| 无规格商品1 |
	#上架后再下架商品，查看待售商品列表商品排序
		Given jobs登录系统
		When jobs批量下架商品
			"""
			["无规格商品3"]
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "无规格商品3"}
			}]
			"""
		When jobs批量下架商品
			"""
			["多规格商品2"]
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "多规格商品2"}
			},{
				"product_info":{"name": "无规格商品3"}
			}]
			"""

@product @toSaleProduct
Scenario:3 待售商品列表-修改商品价格
	Given jobs登录系统
	When jobs在'待售'商品列表修改商品'无规格商品1'的价格为
		"""
		{
			"price": 10.00
		}
		"""
	When jobs在'待售'商品列表修改商品'多规格商品2'的价格为
		"""
		{
			"model": {
				"models": {
					"黑色 S": {"price": 20.01},
					"白色 S": {"price":20.02}
						}
					}
		}
		"""
	Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "无规格商品3"},
				"is_enable_model":false,
				"price":"30.00"
			},{
				"product_info":
					{
					"name": "多规格商品2",
					"model": {
						"models": {
							"黑色 S": {"price": 20.01},
							"白色 S": {"price": 20.02}
							}
						}
					},
				"is_enable_model": true,
				"price":"20.01-20.02"
			},{
				"product_info":{"name": "无规格商品1"},
				"is_enable_model":false,
				"price":"10.00"
			}]
			"""
	And jobs能获取商品'无规格商品1'
		"""
		{
			"name": "无规格商品1",
			"is_enable_model":false,
			"price": 10.00,
			"status": "待售"
		}
		"""
	And jobs能获取商品'多规格商品2'
		"""
		{
			"name": "多规格商品2",
			"is_enable_model": true,
			"model": {
				"models": {
					"黑色 S": {"price": 20.01},
					"白色 S": {"price": 20.02}
					}
			},
			"status": "待售"
		}
		"""
	And jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products":[{
				"name":"无规格商品1",
				"price":10.00
			}]
		},{
			"name":"分组2",
			"products":[]
		},{
			"name":"分组3",
			"products":[{
				"name":"无规格商品3",
				"price":30.00
			},{
				"name":"无规格商品1",
				"price":10.00
			}]
		}]
		"""

@product @toSaleProduct
Scenario:4 待售商品列表-修改商品库存
	Given jobs登录系统
	When jobs在'待售'商品列表修改商品'无规格商品1'的库存为
		"""
		{
			"stock_type": "有限",
			"stocks": 100
		}
		"""
	When jobs在'待售'商品列表修改商品'多规格商品1'的库存为
		"""
		{
			"model": {
				"models": {
					"黑色 S": {
						"stock_type": "有限",
						"stocks": 20
						},
					"白色 S": {
						"stock_type": "有限",
						"stocks": 20
					}
				}
			}
		}
		"""
	Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "无规格商品3"},
				"is_enable_model": false,
				"stock":"100"
			},{
				"product_info":
					{
						"name": "多规格商品2",
						"model": {
							"models": {
								"黑色 S": {
									"stock_type": "有限",
									"stocks": 20
								},
								"白色 S": {
									"stock_type": "有限",
									"stocks": 20
									}
								}
							}
					},
				"is_enable_model": true,
				"stock":""
			},{
				"product_info":{"name":"无规格商品1"},
				"is_enable_model":false,
				"stock":"100"
			}]
			"""
	And jobs能获取商品'无规格商品1'
		"""
		{
			"name": "无规格商品1",
			"is_enable_model":false,
			"stock_type": "有限",
			"stocks": 100,
			"status": "待售"
		}
		"""
	And jobs能获取商品'多规格商品2'
		"""
		{
			"name": "多规格商品2",
			"is_enable_model": true,
			"model": {
				"models": {
					"黑色 S": {
						"stock_type": "有限",
						"stocks": 20
					},
					"白色 S": {
						"stock_type": "有限",
						"stocks": 20
					}
				}
			},
			"status": "待售"
		}
		"""