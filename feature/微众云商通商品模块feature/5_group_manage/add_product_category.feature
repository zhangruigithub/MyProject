#editor:张三香 2016.08.15

Feature: 添加商品分组
	"""
		1.商品分组名称不允许为空，最多输入18个字符，为空时提示'请输入商品分组名称'
		2.商品分组列表按照分组创建时间'正序'显示
		3.允许添加空的商品分组
		4.点击【新建分组】按钮，会显示弹框,弹框中显示以下信息
			a.'请输入商品分组名称'文本输入框
			b.商品搜索框+【搜索】按钮，搜索按钮后文字提示'分组中已有的商品不会显示在列表中'
			c.可选商品列表
				列表字段：商品名称、商品价格（元）、状态、销量、编辑时间
				每条商品前显示复现框按钮
				列表中显示所有在售和待售商品（分组中已有的商品不显示在列表中）
				列表下方显示【确认添加】按钮
		5.添加商品时选择分组，则商品分组中显示该商品
		6.商品分组中商品列表显示顺序:
			优先显示'在售'商品，其次显示'待售'商品
			'在售'商品可以在分组中设置排序，'待售'商品不能设置排序
			'在售'商品的分组排序默认为0
			'在售'商品若设置了分组排序则优先按分组排序显示，否则按'加入分组时间'倒序显示
		7.商品分组中商品列表显示以下字段：
			商品名称、商品价格（元）、状态、排序、销量、加入分组时间、操作
			排序：'在售'商品显示排序输入框，'待售'商品不显示
			操作：【删除】
	"""

@product @group
Scenario:1 添加空的商品分组

	Given jobs登录系统
	When jobs添加商品分组
		"""
		{
			"name": "分组1",
			"products":[]
		}
		"""
	When jobs添加商品分组
		"""
		{
			"name": "分组2",
			"products":[]
		}
		"""
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1",
			"products":[]
		},{
			"name": "分组2",
			"products":[]
		}]
		"""

	#手机端校验商品分组下拉框及商品分组列表页面
	When bill关注jobs的公众号::apiserver
	When bill访问jobs的webapp::apiserver
	#该句steps是新补充的，之前apiserver中没有实现过
	Then bill获得webapp分组下拉框信息::apiserver
		"""
		[{
			"name":"分组1"
		},{
			"name":"分组2"
		}]
		"""
	When bill浏览jobs的webapp的'分组1'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |

	Given nokia登录系统
	Then nokia能获取商品分组列表
		"""
		[]
		"""

@product @group
Scenario:2 添加非空商品分组
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name":"商品1",
			"categroy":[],
			"price":10.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品2",
			"categroy":[],
			"price":20.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品3",
			"categroy":[],
			"price":30.00
		}
		"""
	When jobs批量上架商品
		"""
		["商品2"]
		"""
	When jobs添加商品分组
		"""
		{
			"name":"分组1",
			"products":[{
				"name":"商品2"
			},{
				"name":"商品1"
			},{
				"name":"商品3"
			}]
		}
		"""
	Then jobs能获取商品分组列表
		"""
		[{
			"name":"分组1",
			"products":[{
				"name":"商品2",
				"price":20.00,
				"status":"在售",
				"display_index":0,
				"sales":0,
				"join_time":"今天",
				"actions":["删除"]
			},{
				"name":"商品3",
				"price":30.00,
				"status":"待售",
				"display_index":0,
				"sales":0,
				"join_time":"今天",
				"actions":["删除"]
			},{
				"name":"商品1",
				"price":10.00,
				"status":"待售",
				"display_index":0,
				"sales":0,
				"join_time":"今天",
				"actions":["删除"]
			}]
		}]
		"""
	And jobs能获取商品'商品2'
		"""
		{
			"name":"商品2",
			"categroy":["分组1"]
		}
		"""
	#手机端校验分组中的商品
	When bill关注jobs的公众号::apiserver
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'分组1'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |
		|  商品2   |

@product @group
Scenario:3 添加商品时选择分组，能在分组中看到该商品
	Given jobs登录系统
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
	When jobs添加商品
		"""
		{
			"name": "东坡肘子",
			"category":["分组1","分组2"],
			"price": 11.12
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "叫花鸡",
			"category": ["分组1"],
			"price": 12.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "水晶虾仁",
			"categroy":[],
			"price": 12.00
		}
		"""
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1",
			"products": [{
				"name": "叫花鸡"
			},{
				"name": "东坡肘子"
			}]
		},{
			"name": "分组2",
			"products": [{
				"name": "东坡肘子"
			}]
		}]
		"""
