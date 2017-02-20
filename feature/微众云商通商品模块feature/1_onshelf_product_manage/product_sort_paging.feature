# _author_: "新新"
#editor:王丽 2015.10.13

Feature: 商品排序及分页
	"""
		Jobs能通过排序管理商品,已上架的商品
		1.商品没有排序时,默认排序显示0,按创建时间的倒序显示
		2.设置排序为1时,在手机端置顶
		3.商品列表与手机端商品列表排序展示不同
		4.修改排序重复时,更新为最后排序的商品,被重复的商品显示0
		5.初始化排序分页,分页时修改不是当前页的排序,刷新页面后,更新排序
		6.分页时,修改不是当前页的排序,重复排序时,更新为最后排序的商品,刷新页面后,更新排序
	"""

Background:
	Given 重置'apiserver'的bdd环境
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name":"商品1",
			"create_time":"2015-06-01 08:00"
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品2",
			"create_time":"2015-07-01 08:00"
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品3",
			"create_time":"2015-08-01 08:00"
		}
		"""
	When jobs批量上架商品
		"""
		["商品1","商品2","商品3"]
		"""
	When bill关注jobs的公众号::apiserver

@product @saleingProduct
Scenario: 1商品排序初始化
	Jobs商品没有排序时,按创建时间的倒序显示
	Given jobs登录系统
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":0
		},{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":0
		},{
			"product_info":{"name":"商品1"},
			"create_time":"2015-06-01 08:00",
			"display_index":0
		}]
		"""

	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'全部'商品列表页::apiserver
	#手机端不显示 sort, time等字段，不需要验证，只验证商品顺序即可
	Then bill获得webapp商品列表::apiserver
		| name   |
		| 商品3  |
		| 商品2  |
		| 商品1  |

@product @saleingProduct
Scenario: 2修改商品排序
	Jobs从初始化编辑商品排序

	Given jobs登录系统
	When jobs更新'商品2'商品排序1
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":1
		},{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":0
		},{
			"product_info":{"name":"商品1"},
			"create_time":"2015-06-01 08:00",
			"display_index":0
		}]
		"""

	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'全部'商品列表页::apiserver
	###设置排序为1时,在手机端置顶
	Then bill获得webapp商品列表::apiserver
		| name    |
		| 商品2   |
		| 商品3   |
		| 商品1   |

	Given jobs登录系统
	When jobs更新'商品1'商品排序2
	When jobs更新'商品2'商品排序1
	#有排序时,按排序的倒序显示
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":1
		},{
			"product_info":{"name":"商品1"},
			"create_time":"2015-06-01 08:00",
			"display_index":2
		},{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":0
		}]
		"""

	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'全部'商品列表页::apiserver
	#商品列表与手机端商品列表排序展示不同
	Then bill获得webapp商品列表::apiserver
		| name    |
		| 商品2   |
		| 商品1   |
		| 商品3   |

	#修改排序重复时,更新为最后排序的商品,被重复的商品显示0
	Given jobs登录系统
	#位置2已存在商品2，直接替换掉了商品2
	When jobs更新'商品2'商品排序2
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":2
		},{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":0
		},{
			"product_info":{"name":"商品1"},
			"create_time":"2015-06-01 08:00",
			"display_index":0
		}]
		"""

	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'全部'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		| name    |
		| 商品2   |
		| 商品3   |
		| 商品1   |

@product @saleingProduct
Scenario:3分页
	#没有排序时,按照创建时间倒序排列
	#初始化分页
	Given jobs登录系统
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":0
		},{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":0
		},{
			"product_info":{"name":"商品1"},
			"create_time":"2015-06-01 08:00",
			"display_index":0
		}]
		"""

	When jobs设置查询条件
		"""
		{
			"count_per_page":1
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":0
		}]
		"""
	And jobs获取分页信息
		"""
		{
			"max_page": 3
		}
		"""
	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 2
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":0
		}]
		"""

	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 3
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品1"},
			"create_time":"2015-06-01 08:00",
			"display_index":0
		}]
		"""
	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 2
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":0
		}]
		"""

	#修改不是当前页的排序,刷新后按照排序显示列表
	When jobs更新'商品2'商品排序2
	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 1
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":2
		}]
		"""

	#修改不是当前页重复的排序,更新为最后设置排序的商品
	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 2
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":0
		}]
		"""

	#位置2已存在商品2，直接替换掉了商品2
	When jobs更新'商品3'商品排序2
	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 1
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":2
		}]
		"""

	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 2
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":0
		}]
		"""

	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 3
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品1"},
			"create_time":"2015-06-01 08:00",
			"display_index":0
		}]
		"""

	When jobs更新'商品1'商品排序5
	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 1
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品3"},
			"create_time":"2015-08-01 08:00",
			"display_index":2
		}]
		"""

	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 2
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品1"},
			"create_time":"2015-06-01 08:00",
			"display_index":5
		}]
		"""

	When jobs设置查询条件
		"""
		{
			"count_per_page":1,
			"page": 3
		}
		"""
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name":"商品2"},
			"create_time":"2015-07-01 08:00",
			"display_index":0
		}]
		"""

