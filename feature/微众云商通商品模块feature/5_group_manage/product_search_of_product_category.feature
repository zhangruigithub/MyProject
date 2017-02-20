#_author_:李娜 2016.08.16

Feature: 分组管理查看及搜索商品列表
	"""
		1.新建分组或管理分组时，弹窗中可对商品名称进行搜索
		2.分组中已有的商品不显示在商品列表中
	"""

Background:
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
	When jobs添加商品分组
		"""
		{
			"name": "分组3"
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "东坡肘子",
			"category":["分组1","分组2"],
			"price": 11.12,
			"stock_type": "无限"
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "叫花鸡",
			"category":["分组1"],
			"price": 12.00,
			"stock_type": "有限",
			"stocks": 3
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "水晶虾仁",
			"categroy":[],
			"price": 3.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "水晶虾仁1",
			"categroy":[],
			"price": 3.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "水晶虾仁2",
			"categroy":[],
			"price": 3.00
		}
		"""

@product @group
Scenario:1 新建分组，搜索商品
	Given jobs登录系统
	When jobs新建商品分组时设置商品列表搜索条件
		"""
		{
			"name":""
		}
		"""
	Then jobs能获得商品分组''的可选商品集合为
		"""
		[{
			"name": "水晶虾仁2",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "水晶虾仁1",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "水晶虾仁",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "叫花鸡",
			"price":12.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "东坡肘子",
			"price":11.12,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		}]
		"""
	When jobs新建商品分组时设置商品列表搜索条件
		"""
		{
			"name": "水晶虾仁1"
		}
		"""
	Then jobs能获得商品分组''的可选商品集合为
		"""
		[{
			"name": "水晶虾仁1"
		}]
		"""
	When jobs新建商品分组时设置商品列表搜索条件
		"""
		{
			"name": "水晶虾仁"
		}
		"""
	Then jobs能获得商品分组''的可选商品集合为
		"""
		[{
			"name": "水晶虾仁2"
		},{
			"name": "水晶虾仁1"
		},{
			"name": "水晶虾仁"
		}]
		"""
	When jobs新建商品分组时设置商品列表搜索条件
		"""
		{
			"name": "鱼香肉丝"
		}
		"""
	Then jobs能获得商品分组''的可选商品集合为
		"""
		[]
		"""

@product @group
Scenario:2 对空商品分组'分组3'进行管理，搜索商品
	Given jobs登录系统
	When jobs对商品分组'分组3'设置商品列表搜索条件
		"""
		{
			"name":""
		}
		"""
	Then jobs能获得商品分组'分组3'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁2",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "水晶虾仁1",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "水晶虾仁",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "叫花鸡",
			"price":12.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "东坡肘子",
			"price":11.12,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		}]
		"""
	When jobs对商品分组'分组3'设置商品列表搜索条件
		"""
		{
			"name": "水晶虾仁1"
		}
		"""
	Then jobs能获得商品分组'分组3'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁1"
		}]
		"""
	When jobs对商品分组'分组3'设置商品列表搜索条件
		"""
		{
			"name": "水晶虾仁"
		}
		"""
	Then jobs能获得商品分组'分组3'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁2"
		},{
			"name": "水晶虾仁1"
		},{
			"name": "水晶虾仁"
		}]
		"""
	When jobs对商品分组'分组3'设置商品列表搜索条件
		"""
		{
			"name": "鱼香肉丝"
		}
		"""
	Then jobs能获得商品分组'分组3'的可选商品集合为
		"""
		[]
		"""

@product @group
Scenario:3 对非空'分组1'进行管理，搜索商品
	Given jobs登录系统
	#查询条件为空（已在分组中的商品，不显示在商品列表中）
	When jobs对商品分组'分组1'设置商品列表搜索条件
		"""
		{
			"name":""
		}
		"""
	Then jobs能获得商品分组'分组1'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁2",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "水晶虾仁1",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "水晶虾仁",
			"price":3.00,
			"status":"待售",
			"sales":0,
			"edite_time":"今天"
		}]
		"""
	#完全匹配
	When jobs对商品分组'分组1'设置商品列表搜索条件
		"""
		{
			"name": "水晶虾仁1"
		}
		"""
	Then jobs能获得商品分组'分组1'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁1"
		}]
		"""
	#模糊查询
	When jobs对商品分组'分组1'设置商品列表搜索条件
		"""
		{
			"name": "水晶虾仁"
		}
		"""
	Then jobs能获得商品分组'分组1'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁2"
		},{
			"name": "水晶虾仁1"
		},{
			"name": "水晶虾仁"
		}]
		"""
	#查询结果为空
	When jobs对商品分组'分组1'设置商品列表搜索条件
		"""
		{
			"name": "东坡肘子"
		}
		"""
	Then jobs能获得商品分组'分组1'的可选商品集合为
		"""
		[]
		"""
	When jobs对商品分组'分组1'设置商品列表搜索条件
		"""
		{
			"name": "鱼香肉丝"
		}
		"""
	Then jobs能获得商品分组'分组1'的可选商品集合为
		"""
		[]
		"""
