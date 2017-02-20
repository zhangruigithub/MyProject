#_author_:张三香 2016.08.16

Feature:彻底删除待售商品
	"""
		1.待售商品管理列表，可以对单个商品进行'彻底删除'
		2.商品彻底删除后，待售商品列表中该商品消失
		3.商品（属于某商品分组）彻底删除后，商品分组列表中该商品消失
		4.勾选一个或多个商品进行批量彻底删除商品，商品删除成功
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
	#添加商品
		When jobs添加商品
			"""
			{
				"name": "商品1",
				"category":["分组1","分组2"]
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "商品2",
				"category": ["分组1","分组2"]
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "商品3",
				"category":["分组1"]
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "商品4",
				"category":["分组2"]
			}
			"""

@product @toSaleProduct
Scenario:1 待售商品列表'彻底删除'商品
	Given jobs登录系统
	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name":"商品4"}
		},{
			"product_info":{"name":"商品3"}
		},{
			"product_info":{"name":"商品2"}
		},{
			"product_info":{"name":"商品1"}
		}]
		"""
	And jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products":[{
				"name": "商品3"
			},{
				"name": "商品2"
			},{
				"name": "商品1"
			}]
		},{
			"name":"分组2",
			"products": [{
				"name": "商品4"
			},{
				"name": "商品2"
			},{
				"name": "商品1"
			}]
		},{
			"name":"分组3",
			"products":[]
		}]
		"""
	When jobs批量彻底删除商品
		"""
		["商品3"]
		"""
	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name":"商品4"}
		},{
			"product_info":{"name":"商品2"}
		},{
			"product_info":{"name":"商品1"}
		}]
		"""
	And jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products":[{
				"name": "商品2"
			},{
				"name": "商品1"
			}]
		},{
			"name":"分组2",
			"products": [{
				"name": "商品4"
			},{
				"name": "商品2"
			},{
				"name": "商品1"
			}]
		},{
			"name":"分组3",
			"products": []
		}]
		"""
	When jobs批量彻底删除商品
		"""
		["商品2"]
		"""
	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name":"商品4"}
		},{
			"product_info":{"name":"商品1"}
		}]
		"""
	And jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products":[{
				"name": "商品1"
			}]
		},{
			"name":"分组2",
			"products": [{
				"name": "商品4"
			},{
				"name": "商品1"
			}]
		},{
			"name":"分组3",
			"products": []
		}]
		"""
	When jobs批量彻底删除商品
		"""
		["商品1"]
		"""
	When jobs批量彻底删除商品
		"""
		["商品4"]
		"""
	Then jobs能获得'待售'商品列表
		"""
		[]
		"""
	And jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products": []
		},{
			"name":"分组2",
			"products": []
		},{
			"name":"分组3",
			"products": []
		}]
		"""

@product @toSaleProduct
Scenario:2 待售商品列表批量'彻底删除'商品
	#勾选一个商品点击批量'彻底删除'
	When jobs批量彻底删除商品
		"""
		["商品1"]
		"""
	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name":"商品4"}
		},{
			"product_info":{"name":"商品3"}
		},{
			"product_info":{"name":"商品2"}
		}]
		"""
	#勾选多个商品点击批量'彻底删除'
	When jobs批量彻底删除商品
		"""
		["商品4","商品2"]
		"""
	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name":"商品3"}
		}]
		"""