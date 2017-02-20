# watcher: benchi@weizoom.com, zhangsanxiang@weizoom.com
#_author_:张三香 2016.03.10

Feature:在售商品列表-团购活动
	"""
		1、团购进行中的商品,不能进行下架和永久删除操作,点击【下架】或【永久删除】时，红框提示"该商品正在进行团购活动"
		2、团购进行中的商品，在进行 全选-批量删除 和 全选-批量下架时时，不被选取
	"""

Background:
	Given jobs登录系统
	When jobs添加微信证书
	When jobs添加支付方式
		"""
		{
			"type": "微信支付",
			"is_active": "启用"
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品1",
			"price": 100.00,
			"stock_type": "有限",
			"stocks": 100,
			"postage":10.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品2",
			"price": 200.00,
			"stock_type": "无限"
		}
		"""
	When jobs新建团购活动
		"""
		[{
			"group_name":"团购活动1",
			"start_date":"今天",
			"end_date":"2天后",
			"product_name":"商品1",
			"group_dict":
				[{
					"group_type":5,
					"group_days":1,
					"group_price":90.00
				}],
				"ship_date":20,
				"product_counts":100,
				"material_image":"1.jpg",
				"share_description":"团购活动1分享描述"
		},{
			"group_name":"团购活动2",
			"start_date":"今天",
			"end_date":"2天后",
			"product_name":"商品2",
			"group_dict":
				[{
					"group_type":5,
					"group_days":1,
					"group_price":190.00
				},{
					"group_type":10,
					"group_days":2,
					"group_price":188.00
				}],
				"ship_date":20,
				"product_counts":100,
				"material_image":"1.jpg",
				"share_description":"团购活动2分享描述"
		}]
		"""
	When jobs开启团购活动'团购活动1'
	When jobs开启团购活动'团购活动2'

@product @saleingProduct @group
Scenario:1 对团购活动中的商品进行下架或删除操作
	Given jobs登录系统
	#团购活动中的商品,不能进行下架和删除操作
	When jobs批量下架商品
		"""
		["商品2"]
		"""
	Then jobs获得提示信息'该商品正在进行团购活动'
	When jobs批量彻底删除商品
		"""
		["商品1"]
		"""
	Then jobs获得提示信息'该商品正在进行团购活动'

	#团购活动结束后,可以对商品进行下架和删除操作
	When jobs关闭团购活动'团购活动2'
	When jobs批量下架商品
		"""
		["商品2"]
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name": "商品1"}
		}]
		"""
	And jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name": "商品2"}
		}]
		"""
	When jobs关闭团购活动'团购活动1'
	When jobs批量彻底删除商品
		"""
		["商品1"]
		"""
	Then jobs能获得'在售'商品列表
		"""
		[]
		"""
	And jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name": "商品2"}
		}]
		"""


