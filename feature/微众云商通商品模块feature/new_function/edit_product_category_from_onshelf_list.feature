#_author_:张三香 2016.10.11

Feature: 管理在售商品列表
	"""
		1、在售商品列表操作列增加【编辑分组】按钮
		2、点击【编辑分组】按钮，显示分组弹框：
			弹框中显示分组管理列表中的所有分组，按照分组的添加时间正序显示
			弹框下方显示【确认】、【取消】按钮
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
				"category":["分组1"],
				"is_enable_model":false,
				"price": 10.00
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "多规格商品2",
				"categroy":[],
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
				}
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "多规格商品3",
				"category":["分组1","分组3"],
				"is_enable_model":true,
				"model": {
					"models": {
						"白色 M": {
							"user_code": "301",
							"price": 30.00,
							"stock_type": "无限"
						}
					}
				}
			}
			"""
	When bill关注jobs的公众号::apiserver


@mall2 @product @group @ProductList  @mall.product_category @mall
Scenario:1 在售商品管理列表-编辑分组
	Given jobs登录系统
	When jobs批量上架商品
		"""
		["无规格商品1","多规格商品2","多规格商品3"]
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"name":"多规格商品3",
			"category":["分组1","分组3"]
		},{
			"name":"多规格商品2",
			"category":[]
		},{
			"name":"无规格商品1",
			"category":["分组1"]
		}]
		"""
	And jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products":
				[{
					"name":"多规格商品3"
				},{
					"name":"无规格商品1"
				}]
		},{
			"name":"分组2",
			"products":[]
		},{
			"name":"分组3",
			"products":
				[{
					"name":"多规格商品3"
				}]
		}]
		"""

	#从在售商品管理列表对商品【编辑分组】
	When jobs给商品'无规格商品1'编辑分组
		"""
		["分组3"]
		"""
	When jobs给商品'多规格商品2'编辑分组
		"""
		["分组2","分组3"]
		"""
	When jobs给商品'多规格商品3'编辑分组
		"""
		[]
		"""
	#后台在售商品列表分组的校验
	Then jobs能获得'在售'商品列表
		"""
		[{
			"name": "多规格商品3",
			"category":[]
		},{
			"name": "多规格商品2",
			"category":["分组2","分组3"]
		},{
			"name": "无规格商品1",
			"category":["分组3"]
		}]
		"""
	#后台商品详情页的校验
	And jobs能获取商品'无规格商品1'
		"""
		{
			"name":"无规格商品1",
			"category": ["分组3"]
		}
		"""
	And jobs能获取商品'多规格商品2'
		"""
		{
			"name":"多规格商品2",
			"category":["分组2","分组3"]
		}
		"""
	And jobs能获取商品'多规格商品3'
		"""
		{
			"name":"多规格商品3",
			"category":[]
		}
		"""
	#分组管理列表的校验
	And jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products":[]
		},{
			"name":"分组2",
			"products":
				[{
					"name":"多规格商品2"
				}]
		},{
			"name":"分组3",
			"products":
				[{
					"name":"多规格商品2"
				},{
					"name":"无规格商品1"
				}]
		}]
		"""
	#手机端商品分组列表的校验
	When bill访问jobs的webapp::apiserver
	When bill浏览jobs的webapp的'分组1'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |
	When bill浏览jobs的webapp的'分组2'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name    |
		|多规格商品2|
	When bill浏览jobs的webapp的'分组3'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name    |
		|多规格商品2|
		|无规格商品1|