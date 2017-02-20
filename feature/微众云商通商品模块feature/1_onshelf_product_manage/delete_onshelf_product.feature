#_author_:张三香 2016.08.16

Feature:彻底删除在售商品
	"""
		1.在售商品列表，可以彻底删除商品
		2.商品彻底删除后，在售商品列表中该商品消失,手机端商品列表该商品消失
		3.商品（属于某商品分组）彻底删除后，该商品分组的商品列表中不存在该商品，手机端商品分组列表中该商品消失
		4.勾选一个或多个商品进行批量彻底删除商品，商品删除成功
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
	#添加商品
		When jobs添加商品
			"""
			{
				"name": "商品1",
				"category":["分组1","分组3"]
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "商品2",
				"category":["分组1","分组2"]
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "商品3",
				"category":["分组3"]
			}
			"""
	#上架商品
		When jobs批量上架商品
			"""
			["商品1","商品2","商品3"]
			"""
	When bill关注jobs的公众号::apiserver

@product @saleingProduct
Scenario:1 在售商品列表单个'彻底删除'商品
	Given jobs登录系统
	When jobs批量彻底删除商品
		"""
		["商品3"]
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
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
				"name": "商品2"
			}]
		},{
			"name":"分组3",
			"products": [{
				"name": "商品1"
			}]
		}]
		"""
	#手机端商品列表的校验
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'全部'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		| name |
		| 商品2|
		| 商品1|
	When bill浏览jobs的webapp的'分组3'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		| name |
		| 商品1|

@product @saleingProduct
Scenario:2 在售商品列表批量'彻底删除'商品
	#勾选多个商品点击批量'彻底删除'
	Given jobs登录系统
	When jobs批量永久删除商品
		"""
		["商品1","商品2"]
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品3"}
		}]
		"""
	And jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products":[]
		},{
			"name":"分组2",
			"products": []
		},{
			"name":"分组3",
			"products": [{
				"name": "商品3"
			}]
		}]
		"""
	#手机端商品列表的校验
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'全部'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		| name |
		| 商品3|

	When bill浏览jobs的webapp的'分组3'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		| name |
		| 商品3|

	When bill浏览jobs的webapp的'分组2'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		| name |

	When bill浏览jobs的webapp的'分组1'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		| name |
