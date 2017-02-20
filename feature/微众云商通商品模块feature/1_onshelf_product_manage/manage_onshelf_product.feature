#editor:王丽 2015.10.13

Feature: 管理在售商品
	"""
		1、商品排序均为0时，在售商品列表按照创建时间倒序显示；排序不为0则按照排序从小到大显示
		2、每页最多显示30条数据，多了则分页展示
		3、在售商品列表可对商品价格和商品库存进行修改
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
				"category":["分组1","分组2","分组3"],
				"bar_code":"0101",
				"swipe_images": [{
					"url": "/standard_static/test_resource_img/hangzhou1.jpg"
					}],
				"is_enable_model":false,
				"user_code": "101",
				"weight": 1.0,
				"price": 10.00,
				"stock_type": "无限",
				"create_time":"2016-09-05 10:01"
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "多规格商品2",
				"categroy":[],
				"bar_code":"0202",
				"swipe_images": [{
					"url": "/standard_static/test_resource_img/hangzhou2.jpg"
					}],
				"is_enable_model":true,
				"model": {
					"models": {
						"黑色 M": {
							"user_code": "201",
							"price": 20.01,
							"stock_type": "无限"
						},
						"白色 M": {
							"user_code": "202",
							"price": 20.02,
							"stock_type": "有限",
							"stocks": 20
						}
					}
				},
				"create_time":"2016-09-05 10:02"
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "多规格商品3",
				"category":["分组3"],
				"bar_code":"",
				"swipe_images":
					[{
						"url": "/standard_static/test_resource_img/hangzhou3.jpg"
					},{
						"url": "/standard_static/test_resource_img/hangzhou33.jpg"
					}],
				"is_enable_model":true,
				"model": {
					"models": {
						"白色 M": {
							"user_code": "301",
							"price": 30.00,
							"stock_type": "无限"
						}
					}
				},
				"create_time":"2016-09-05 10:03"
			}
			"""
	When bill关注jobs的公众号::apiserver

@product @saleingProduct
Scenario:1 浏览在售商品管理列表
	#在售商品列表为空
		Given jobs登录系统
		Then jobs能获得'在售'商品列表
			"""
			[]
			"""
	#在售商品列表非空
		When jobs批量上架商品
			"""
			["无规格商品1","多规格商品2","多规格商品3"]
			"""
		Then jobs能获得'在售'商品列表
			"""
			[{
				"product_info":
					{
						"name": "多规格商品3",
						"swipe_images": [{
								"url": "/standard_static/test_resource_img/hangzhou3.jpg"
							}],
						"model": {
							"models": {
								"白色 M": {
									"user_code": "301",
									"price": 30.00,
									"stock_type": "无限"
										}
									}
								}
					},
				"bar_code":"",
				"category": ["分组3"],
				"is_enable_model":true,
				"price":"30.00",
				"stock": "",
				"sales":0,
				"create_time":"2016-09-05 10:03",
				"display_index":0,
				"actions":["修改","下架","彻底删除"]
			},{
				"product_info":
					{
						"name": "多规格商品2",
						"swipe_images": [{
							"url": "/standard_static/test_resource_img/hangzhou2.jpg"
						}],
					"model": {
						"models": {
							"黑色 M": {
								"user_code": "201",
								"price": 20.01,
								"stock_type": "无限"
								},
							"白色 M": {
								"user_code": "202",
								"price": 20.02,
								"stock_type": "有限",
								"stocks": 20
									}
								}
							}
					},
				"is_enable_model":true,
				"bar_code":"0202",
				"categroy":[],
				"price":"20.01-20.02",
				"stock":"",
				"sales":0,
				"create_time":"2016-09-05 10:02",
				"display_index":0,
				"actions":["修改","下架","彻底删除"]
			},{
				"product_info":
					{
						"name": "无规格商品1",
						"swipe_images": [{
							"url": "/standard_static/test_resource_img/hangzhou1.jpg"
							}],
						"user_code":"101"
					},
				"bar_code":"0101",
				"category": ["分组1","分组2","分组3"],
				"is_enable_model":false,
				"price":"10.00",
				"stock":"无限",
				"sales":0,
				"create_time":"2016-09-05 10:01",
				"display_index":0,
				"actions":["修改","下架","彻底删除"]
			}]
			"""
		#手机端商品列表的校验
		When bill访问jobs的webapp::apiserver
		And bill浏览jobs的webapp的'全部'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			| name        |
			| 多规格商品3 |
			| 多规格商品2 |
			| 无规格商品1 |

@product @saleingProduct
Scenario:2 下架商品
	jobs进行'批量下架'或'单个下架'后
	1.jobs的待售商品列表发生变化
	2.jobs的在售商品列表发生变化
	3.手机端商品列表发生变化

	Given jobs登录系统
	When jobs批量上架商品
		"""
		["无规格商品1","多规格商品2","多规格商品3"]
		"""
	#下架单个商品
		When jobs批量下架商品
			"""
			["无规格商品1"]
			"""
		Then jobs能获得'在售'商品列表
			"""
			[{
				"product_info":{"name":"多规格商品3"}
			},{
				"product_info":{"name":"多规格商品2"}
			}]
			"""
		And jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name":"无规格商品1"}
			}]
			"""
		And jobs能获取商品分组列表
			"""
			[{
				"name": "分组1",
				"products": [{
					"name": "无规格商品1",
					"status": "待售"
				}]
			},{
				"name": "分组2",
				"products": [{
					"name": "无规格商品1",
					"status": "待售"
				}]
			},{
				"name": "分组3",
				"products": [{
					"name": "多规格商品3",
					"status": "在售"
				},{
					"name": "无规格商品1",
					"status": "待售"
				}]
			}]
			"""
		When bill访问jobs的webapp::apiserver
		And bill浏览jobs的webapp的'全部'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			| name        |
			| 多规格商品3 |
			| 多规格商品2 |

	#下架多个商品
		Given jobs登录系统
		When jobs批量下架商品
			"""
			["多规格商品2", "多规格商品3"]
			"""
		Then jobs能获得'在售'商品列表
			"""
			[]
			"""
		And jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name":"多规格商品3"}
			},{
				"product_info":{"name":"多规格商品2"}
			},{
				"product_info":{"name":"无规格商品1"}
			}]
			"""
		And jobs能获取商品分组列表
			"""
			[{
				"name": "分组1",
				"products": [{
					"name": "无规格商品1",
					"status": "待售"
				}]
			},{
				"name": "分组2",
				"products": [{
					"name": "无规格商品1",
					"status": "待售"
				}]
			},{
				"name": "分组3",
				"products": [{
					"name": "多规格商品3",
					"status": "待售"
				},{
					"name": "无规格商品1",
					"status": "待售"
				}]
			}]
			"""
		When bill访问jobs的webapp::apiserver
		And bill浏览jobs的webapp的'全部'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			| name        |

@product @saleingProduct
Scenario:3 在售商品列表-修改商品价格
	jobs在在售商品列表修改商品价格后：
		1.在售商品列中价格变化
		2.商品详情页中价格变化
		3.商品分组中该商品价格变化
		4.手机端该商品价格变化

	Given jobs登录系统
	When jobs批量上架商品
		"""
		["无规格商品1","多规格商品2","多规格商品3"]
		"""
	#修改无规格商品的价格
	When jobs在'在售'商品列表修改商品'无规格商品1'的价格为
		"""
		{
			"price": 10.01
		}
		"""
	#修改多规格商品的价格
	When jobs在'在售'商品列表修改商品'多规格商品2'的价格为
			"""
			{
				"model": {
					"models": {
						"黑色 M": {"price":20.00},
						"白色 M": {"price":20.00}
					}
				}
			}
			"""
	Then jobs能获得'在售'商品列表
			"""
			[{
				"product_info":{"name": "多规格商品3"}
			},{
				"product_info":
					{
						"name": "多规格商品2",
						"model": {
							"models": {
								"黑色 M": {"price": 20.00},
								"白色 M": {"price": 20.00}
							}
						}
					},
				"is_enable_model":true,
				"price":"20.00"
			},{
				"product_info":{"name":"无规格商品1"},
				"is_enable_model":false,
				"price":"10.01"
			}]
			"""
	And jobs能获取商品'无规格商品1'
		"""
		{
			"name": "无规格商品1",
			"is_enable_model":false,
			"price": 10.01,
			"status": "在售"
		}
		"""
	And jobs能获取商品'多规格商品2'
		"""
		{
			"name": "多规格商品2",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色 M": {"price": 20.00},
					"白色 M": {"price": 20.00}
					}
				},
			"status": "在售"
		}
		"""
	And jobs能获取商品分组列表
		"""
		[{
			"name": "分组1",
			"products": [{
				"name": "无规格商品1",
				"price":10.01
			}]
		},{
			"name": "分组2",
			"products": [{
				"name": "无规格商品1",
				"price":10.01
			}]
		},{
			"name": "分组3",
			"products": [{
				"name": "多规格商品3",
				"price":30.00
			},{
				"name": "无规格商品1",
				"price":10.01
			}]
		}]
		"""
	#手机端商品列表的校验
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'全部'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		| name        | price |
		| 多规格商品3 | 30.00 |
		| 多规格商品2 | 20.00 |
		| 无规格商品1 | 10.01 |

@product @saleingProduct
Scenario:4 在售商品列表-修改商品库存
	jobs在在售商品列表修改商品库存后：
		1.在售商品列中库存变化
		2.商品详情页中库存变化

	Given jobs登录系统
	When jobs批量上架商品
		"""
		["无规格商品1","多规格商品2","多规格商品3"]
		"""
	#修改无规格商品的库存
	When jobs在'在售'商品列表修改商品'无规格商品1'的库存为
		"""
		{
			"stock_type": "有限",
			"stocks": 100
		}
		"""
	#修改多规格商品的库存
	When jobs在'在售'商品列表修改商品'多规格商品2'的库存为
		"""
		{
			"model": {
				"models": {
					"黑色 M": {
						"stock_type": "有限",
						"stocks": 200
						},
					"白色 M": {
						"stock_type": "有限",
						"stocks": 200
					}
				}
			}
		}
		"""
	Then jobs能获得'在售'商品列表
			"""
			[{
				"product_info":
					{
						"name": "多规格商品3",
						"model": {
							"models": {
								"白色 M": {"stock_type": "无限"}
									}
								}
					},
				"is_enable_model":true,
				"stock": ""
			},{
				"product_info":
					{
						"name": "多规格商品2",
						"model": {
							"models": {
								"黑色 M": {
									"stock_type": "有限",
									"stocks": 200
									},
								"白色 M": {
									"stock_type": "有限",
									"stocks": 200
									}
								}
							}
					},
				"is_enable_model":true,
				"stock":""
			},{
				"product_info":{"name": "无规格商品1"},
				"is_enable_model":false,
				"stock":"100",
			}]
			"""
	And jobs能获取商品'无规格商品1'
		"""
		{
			"name": "无规格商品1",
			"is_enable_model":false,
			"stock_type": "有限",
			"stocks": 100,
			"status": "在售"
		}
		"""
	And jobs能获取商品'多规格商品2'
		"""
		{
			"name": "多规格商品2",
			"is_enable_model": true,
			"model": {
				"models": {
					"黑色 M": {
						"stock_type": "有限",
						"stocks": 200
					},
					"白色 M": {
						"stock_type": "有限",
						"stocks": 200
					}
				}
			},
			"status": "在售"
		}
		"""

