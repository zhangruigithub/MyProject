#_author_:张三香 2016.09.06

Feature:更新商品
	"""
		1.商品的每个字段信息都允许修改
		2.待售商品管理列表修改商品，待售商品列表商品信息修改成功
		3.在售商品管理列表修改商品，在售商品列表商品信息修改成功，同时手机端商品列表显示修改后的商品信息
		4.在售商品管理列表修改团购商品，只允许修改商品名称、商品价格、商品库存、商品图片、配送时间及商品描述
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
	#添加邮费配置
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
				"name": "圆通",
				"first_weight":1,
				"first_weight_price":10.00
			}
			"""
		When jobs选择'顺丰'运费配置
	#无规格商品1（运费模板-顺丰）
	When jobs添加商品
		"""
		{
			"name": "无规格商品1",
			"promotion_title": "无规格商品",
			"categroy":[],
			"bar_code":"1234",
			"min_limit":1,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"url": "/standard_static/test_resource_img/hangzhou2.jpg"
			}],
			"is_enable_model":false,
			"user_code":"1111",
			"price": 11.12,
			"weight": 5.0,
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
			"detail": "商品描述信息1",
			"create_time":"2016-09-05 10:00"
		}
		"""
	#多规格商品2（统一运费-2.00）
	When jobs添加商品
		"""
		{
			"name": "多规格商品2",
			"promotion_title": "多规格商品",
			"category":["分组2"],
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
	When bill关注jobs的公众号::apiserver

@product @toSaleProduct
Scenario:1 待售商品列表更新商品
	Given jobs登录系统
	#更新无规格商品-无规格商品1
		#更新后仍为无规格商品-无规格商品01+分组1
			When jobs更新商品'无规格商品1'
				"""
				{
					"name": "无规格商品01",
					"promotion_title": "",
					"category": ["分组1"],
					"bar_code":"1134",
					"min_limit":2,
					"is_member_product":true,
					"swipe_images": [{
						"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					},{
						"url": "/standard_static/test_resource_img/hangzhou2.jpg"
					}],
					"is_enable_model":false,
					"user_code":"2222",
					"price": 10.00,
					"weight": 1.0,
					"stock_type": "有限",
					"stocks": 10,
					"postage":1.00,
					"pay_interfaces":
						[{
							"type": "在线支付"
						}],
					"invoice":true,
					"distribution_time":true,
					"properties": [{
							"name": "CPU",
							"description": "CPU描述"
						}],
					"detail": "商品描述信息01"
				}
				"""
			Then jobs能获取商品'无规格商品01'
				"""
				{
					"name": "无规格商品01",
					"promotion_title": "",
					"category": ["分组1"],
					"bar_code":"1134",
					"min_limit":2,
					"is_member_product":true,
					"swipe_images": [{
						"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					},{
						"url": "/standard_static/test_resource_img/hangzhou2.jpg"
					}],
					"is_enable_model":false,
					"user_code":"2222",
					"price": 10.00,
					"weight": 1.0,
					"stock_type": "有限",
					"stocks": 10,
					"postage":1.00,
					"pay_interfaces":
						[{
							"type": "在线支付"
						}],
					"invoice":true,
					"distribution_time":true,
					"properties": [{
							"name": "CPU",
							"description": "CPU描述"
						}],
					"detail": "商品描述信息01"
				}
				"""
			And jobs能获得'待售'商品列表
				"""
				[{
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
					"bar_code":"2234",
					"category": ["分组2"],
					"is_enable_model": true,
					"price":"9.10-10.00",
					"stock": "",
					"sales":0,
					"create_time":"2016-09-05 10:05",
					"actions":["修改","上架","彻底删除"]
				},{
					"product_info":
						{
							"name": "无规格商品01",
							"swipe_images": [{
								"url": "/standard_static/test_resource_img/hangzhou1.jpg"
							}],
							"user_code":"2222"
						},
					"bar_code":"1134",
					"category": ["分组1"],
					"is_enable_model":false,
					"price":"10.00",
					"stock": "10",
					"sales":0,
					"create_time":"2016-09-05 10:00",
					"actions":["修改","上架","彻底删除"]
				}]
				"""
			And jobs能获取商品分组列表
				"""
				[{
					"name":"分组1",
					"products":[{
						"name":"无规格商品01",
						"price":10.00,
						"status":"待售"
					}]
				},{
					"name":"分组2",
					"products":[{
						"name":"多规格商品2",
						"price":9.10,
						"status":"待售"
					}]
				},{
					"name":"分组3",
					"products":[]
				}]
				"""
		#更新成多规格商品-多规格商品001
			When jobs更新商品'无规格商品01'
				"""
				{
					"name": "多规格商品001",
					"promotion_title": "",
					"category": ["分组1"],
					"bar_code":"1134",
					"min_limit":2,
					"is_member_product":true,
					"swipe_images": [{
						"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					},{
						"url": "/standard_static/test_resource_img/hangzhou2.jpg"
					}],
					"is_enable_model":true,
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
					"postage":1.00,
					"pay_interfaces":
						[{
							"type": "在线支付"
						}],
					"invoice":true,
					"distribution_time":true,
					"properties": [{
							"name": "CPU",
							"description": "CPU描述"
						}],
					"detail": "商品描述信息01"
				}
				"""
			Then jobs能获取商品'多规格商品001'
				"""
				{
					"name": "多规格商品001",
					"promotion_title": "",
					"category": ["分组1"],
					"bar_code":"1134",
					"min_limit":2,
					"is_member_product":true,
					"swipe_images": [{
						"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					},{
						"url": "/standard_static/test_resource_img/hangzhou2.jpg"
					}],
					"is_enable_model":true,
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
					"postage":1.00,
					"pay_interfaces":
						[{
							"type": "在线支付"
						}],
					"invoice":true,
					"distribution_time":true,
					"properties": [{
							"name": "CPU",
							"description": "CPU描述"
						}],
					"detail": "商品描述信息01"
				}
				"""
			And jobs能获得'待售'商品列表
				"""
				[{
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
					"bar_code":"2234",
					"category": ["分组2"],
					"is_enable_model": true,
					"price":"9.10-10.00",
					"stock": "",
					"sales":0,
					"create_time":"2016-09-05 10:05",
					"actions":["修改","上架","彻底删除"]
				},{
					"product_info":
						{
							"name": "多规格商品001",
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
					"bar_code":"1134",
					"category": ["分组1"],
					"is_enable_model":true,
					"price":"9.10-10.00",
					"stock": "",
					"sales":0,
					"create_time":"2016-09-05 10:00",
					"actions":["修改","上架","彻底删除"]
				}]
				"""
			And jobs能获取商品分组列表
				"""
				[{
					"name":"分组1",
					"products":[{
						"name":"多规格商品001",
						"price":9.10,
						"status":"待售"
					}]
				},{
					"name":"分组2",
					"products":[{
						"name":"多规格商品2",
						"price":9.10,
						"status":"待售"
					}]
				},{
					"name":"分组3",
					"products":[]
				}]
				"""
	#更新多规格商品
		#更新后仍为多规格商品-多规格商品02+分组1、分组2
			When jobs更新商品'多规格商品2'
				"""
				{
					"name": "多规格商品02",
					"promotion_title": "多规格商品",
					"category":["分组1","分组2"],
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
								"price": 20.01,
								"weight": 3.1,
								"stock_type": "有限",
								"stocks": 3
							},
							"白色 S": {
								"user_code":"",
								"price": 20.02,
								"weight": 1.0,
								"stock_type": "无限"
							}
						}
					},
					"postage":"顺丰",
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
					"detail": "商品描述信息2"
				}
				"""
			Then jobs能获取商品'多规格商品02'
				"""
				{
					"name": "多规格商品02",
					"promotion_title": "多规格商品",
					"category":["分组1","分组2"],
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
								"price": 20.01,
								"weight": 3.1,
								"stock_type": "有限",
								"stocks": 3
							},
							"白色 S": {
								"user_code":"",
								"price": 20.02,
								"weight": 1.0,
								"stock_type": "无限"
							}
						}
					},
					"postage":"顺丰",
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
					"detail": "商品描述信息2"
				}
				"""
			And jobs能获得'待售'商品列表
				"""
				[{
					"product_info":
						{
							"name": "多规格商品02",
							"swipe_images": [{
								"url": "/standard_static/test_resource_img/hangzhou1.jpg"
							}],
						"model": {
							"models": {
								"黑色 S": {
									"user_code":"2111",
									"price": 20.01,
									"stock_type": "有限",
									"stocks": 3
								},
								"白色 S": {
									"user_code":"",
									"price": 20.02
									"stock_type": "无限"
									}
								}
							}
						},
					"bar_code":"2234",
					"category": ["分组1","分组2"],
					"is_enable_model": true,
					"price":"20.01-20.02",
					"stock": "",
					"sales":0,
					"create_time":"2016-09-05 10:05",
					"actions":["修改","上架","彻底删除"]
				},{
					"product_info":
						{
							"name": "多规格商品001",
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
					"bar_code":"1134",
					"category": ["分组1"],
					"is_enable_model":true,
					"price":"9.10-10.00",
					"stock": "",
					"sales":0,
					"create_time":"2016-09-05 10:00",
					"actions":["修改","上架","彻底删除"]
				}]
				"""
			And jobs能获取商品分组列表
				"""
				[{
					"name":"分组1",
					"products":[{
						"name":"多规格商品02",
						"price":20.01,
						"status":"待售"
					},{
						"name":"多规格商品001",
						"price":9.10,
						"status":"待售"
					}]
				},{
					"name":"分组2",
					"products":[{
						"name":"多规格商品02",
						"price":20.01,
						"status":"待售"
					}]
				},{
					"name":"分组3",
					"products":[]
				}]
				"""
		#更新后为无规格商品-无规格商品002
			When jobs更新商品'多规格商品02'
				"""
				{
					"name": "无规格商品002",
					"promotion_title": "无规格商品",
					"categroy":[],
					"bar_code":"2234",
					"min_limit":2,
					"is_member_product":false,
					"swipe_images": [{
						"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					}],
					"is_enable_model": false,
					"user_code":"2111",
					"price": 20.01,
					"weight": 3.1,
					"stock_type": "有限",
					"stocks": 3,
					"postage":"顺丰",
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
					"detail": "商品描述信息2"
				}
				"""
			Then jobs能获取商品'无规格商品002'
				"""
				{
					"name": "无规格商品002",
					"promotion_title": "无规格商品",
					"categroy":[],
					"bar_code":"2234",
					"min_limit":2,
					"is_member_product":false,
					"swipe_images": [{
						"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					}],
					"is_enable_model": false,
					"user_code":"2111",
					"price": 20.01,
					"weight": 3.1,
					"stock_type": "有限",
					"stocks": 3,
					"postage":"顺丰",
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
					"detail": "商品描述信息2"
				}
				"""
			And jobs能获得'待售'商品列表
				"""
				[{
					"product_info":
						{
							"name": "无规格商品002",
							"swipe_images": [{
								"url": "/standard_static/test_resource_img/hangzhou1.jpg"
							}]
						},
					"bar_code":"2234",
					"categroy":[],
					"is_enable_model":false,
					"price":"20.01",
					"stock": "3",
					"sales":0,
					"create_time":"2016-09-05 10:05",
					"actions":["修改","上架","彻底删除"]
				},{
					"product_info":
						{
							"name": "多规格商品001",
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
					"bar_code":"1134",
					"category": ["分组1"],
					"is_enable_model":true,
					"price":"9.10-10.00",
					"stock": "",
					"sales":0,
					"create_time":"2016-09-05 10:00",
					"actions":["修改","上架","彻底删除"]
				}]
				"""
			And jobs能获取商品分组列表
				"""
				[{
					"name":"分组1",
					"products":[{
						"name":"多规格商品001",
						"price":9.10,
						"status":"待售"
					}]
				},{
					"name":"分组2",
					"products":[]
				},{
					"name":"分组3",
					"products":[]
				}]
				"""

@product @saleingProduct
Scenario:2 在售商品列表更新商品
	Given jobs登录系统
	When jobs批量上架商品
		"""
		["无规格商品1","多规格商品2"]
		"""
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'全部'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		"""
		[{
			"name": "多规格商品2",
			"price":9.10
		},{
			"name": "无规格商品1",
			"price":11.12
		}]
		"""
	When bill浏览jobs的webapp的'分组1'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
			"""
			[]
			"""
	When bill浏览jobs的webapp的'分组2'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		"""
		[{
			"name": "多规格商品2",
			"price":9.10
		}]
		"""
	#修改商品名称、价格、分组后，手机端商品列表的校验
		Given jobs登录系统
		When jobs更新商品'无规格商品1'
			"""
			{
				"name": "无规格商品01",
				"promotion_title": "无规格商品",
				"category":["分组1"],
				"bar_code":"1234",
				"min_limit":1,
				"is_member_product":false,
				"swipe_images": [{
					"url": "/standard_static/test_resource_img/hangzhou1.jpg"
				},{
					"url": "/standard_static/test_resource_img/hangzhou2.jpg"
				}],
				"is_enable_model":false,
				"user_code":"1111",
				"price": 10.00,
				"weight": 5.0,
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
				"detail": "商品描述信息1"
			}
			"""
		When jobs更新商品'多规格商品2'
			"""
			{
				"name": "多规格商品02",
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
							"price": 20.00,
							"weight": 3.1,
							"stock_type": "有限",
							"stocks": 3
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
				"detail": "商品描述信息2"
			}
			"""
		When bill访问jobs的webapp::apiserver
		And bill浏览jobs的webapp的'全部'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			"""
			[{
				"name":"多规格商品02",
				"price":20.00
			},{
				"name":"无规格商品01",
				"price":10.00
			}]
			"""
		When bill浏览jobs的webapp的'分组1'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			"""
			[{
				"name":"无规格商品01",
				"price":10.00
			}]
			"""
		When bill浏览jobs的webapp的'分组2'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			"""
			[]
			"""
	#修改商品的促销标题，手机端商品详情页的校验
		Given jobs登录系统
		When jobs更新商品'无规格商品01'
			"""
			{
				"name": "无规格商品01",
				"promotion_title": "无规格商品促销修改",
				"category":["分组1"],
				"bar_code":"1234",
				"min_limit":1,
				"is_member_product":false,
				"swipe_images": [{
					"url": "/standard_static/test_resource_img/hangzhou1.jpg"
				},{
					"url": "/standard_static/test_resource_img/hangzhou2.jpg"
				}],
				"is_enable_model":false,
				"user_code":"1111",
				"price": 10.00,
				"weight": 5.0,
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
				"detail": "商品描述信息1"
			}
			"""
		When bill访问jobs的webapp::apiserver
		Then bill能获取手机端商品'无规格商品01'::apiserver
			"""
			{
				"name": "无规格商品01",
				"promotion_title": "无规格商品促销修改",
				"is_enable_model":false,
				"price": 10.00
			}
			"""

@product @saleingProduct @group
Scenario:3 在售商品列表更新参与团购的商品
	#参与团购活动的商品只允许修改以下字段:
		#商品名称、商品价格、商品库存、商品图片、配送时间、商品描述

	Given jobs登录系统
	When jobs批量上架商品
		"""
		["无规格商品1"]
		"""
	When jobs添加微信证书
	When jobs新建团购活动
		"""
		[{
			"group_name":"团购活动1",
			"start_date":"今天",
			"end_date":"2天后",
			"product_name":"无规格商品1",
			"group_dict":{
				"0":{
					"group_type":"3",
					"group_days":"1",
					"group_price":"5.00"
					}
			},
			"ship_date":"20",
			"product_counts":"100",
			"material_image":"1.jpg",
			"share_description":"团购分享描述"
		}]
		"""
	When jobs开启团购活动'团购活动1'
	When jobs更新商品'无规格商品1'
		"""
		{
			"name": "无规格商品1修改",
			"promotion_title": "无规格商品",
			"categroy":[],
			"bar_code":"1234",
			"min_limit":1,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			}],
			"is_enable_model":false,
			"user_code":"1111",
			"price": 20.00,
			"weight": 5.0,
			"stock_type": "有限",
			"stocks": 100,
			"postage":"顺丰",
			"pay_interfaces":
				[{
					"type": "在线支付"
				},{
					"type": "货到付款"
				}],
			"invoice":false,
			"distribution_time":true,
			"properties": [{
					"name": "CPU",
					"description": "CPU描述"
				},{
					"name": "内存",
					"description": "内存描述"
				}],
			"detail": "商品描述信息1修改"
		}
		"""
	Then jobs能获取商品'无规格商品1修改'
		"""
		{
			"name": "无规格商品1修改",
			"promotion_title": "无规格商品",
			"categroy":[],
			"bar_code":"1234",
			"min_limit":1,
			"is_member_product":false,
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			}],
			"is_enable_model":false,
			"user_code":"1111",
			"price": 20.00,
			"weight": 5.0,
			"stock_type": "有限",
			"stocks": 100,
			"postage":"顺丰",
			"pay_interfaces":
				[{
					"type": "在线支付"
				},{
					"type": "货到付款"
				}],
			"invoice":false,
			"distribution_time":true,
			"properties": [{
					"name": "CPU",
					"description": "CPU描述"
				},{
					"name": "内存",
					"description": "内存描述"
				}],
			"detail": "商品描述信息1修改"
		}
		"""