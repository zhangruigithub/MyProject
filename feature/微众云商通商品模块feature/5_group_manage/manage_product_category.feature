#author:冯雪静
#editor:王丽 2015.10.14
#editor:三香 2016.08.05
#editor:李娜 2016.09.05

Feature: 管理商品分组列表
	"""
		1.修改商品分组名称
		2.删除空和非空的商品分组
		3.从商品分组中删除商品
		4.向商品分组中添加商品
		5.设置商品分组中在售商品的排序，商品分组列表和手机端均按照排序显示商品
		6.查看商品分组中商品的变化（上架、下架或彻底删除商品）
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
	#添加商品
		When jobs添加商品
			"""
			{
				"name": "东坡肘子",
				"category":["分组1","分组2"],
				"price": 11.12,
				"stock_type": "无限",
				"pay_interfaces":
					[{
						"type": "在线支付"
					},{
						"type": "货到付款"
					}]
			}
			"""
		When jobs添加商品
			"""
			{
				"name": "叫花鸡",
				"category": ["分组1"],
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
	When jobs批量上架商品
		"""
		["东坡肘子","叫花鸡","水晶虾仁"]
		"""

@product @group
Scenario:1 更新商品分组的名称
	Given jobs登录系统
	When jobs更新商品分组'分组2'为
		"""
		{
			"name": "分组2s"
		}
		"""
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1"
		},{
			"name": "分组2s"
		},{
			"name": "分组3"
		}]
		"""
	#李娜补充-商品详情中对应的分组也随之改变
	And jobs能获取商品'东坡肘子'
		"""
		{
			"name":"东坡肘子",
			"categroy":["分组1","分组2s"]
		}
		"""
	#手机端分组下拉框中验证分组名称的变化（下面的steps语句之前apiserver中没有实现过）
	When bill关注jobs的公众号::apiserver
	When bill访问jobs的webapp::apiserver
	Then bill获得webapp分组下拉框信息::apiserver
		"""
		[{
			"name":"分组1"
		},{
			"name":"分组2s"
		},{
			"name":"分组3"
		}]
		"""

@product @group
Scenario:2 删除商品分组
	#删除空的商品分组-分组3
		Given jobs登录系统
		When jobs删除商品分组'分组3'
		Then jobs能获取商品分组列表
			"""
			[{
				"name": "分组1"
			},{
				"name": "分组2"
			}]
			"""
	#删除非空商品分组-分组2、分组1
		When jobs删除商品分组'分组2'
		Then jobs能获取商品分组列表
			"""
			[{
				"name": "分组1"
			}]
			"""
		And jobs能获取商品'东坡肘子'
			"""
			{
				"name": "东坡肘子",
				"category": ["分组1"]
			}
			"""
		When jobs删除商品分组'分组1'
		Then jobs能获取商品分组列表
			"""
			[]
			"""
		And jobs能获取商品'东坡肘子'
			"""
			{
				"name": "东坡肘子",
				"categroy":[],
				"price": 11.12,
				"stock_type": "无限"
			}
			"""
	#删除分组后手机端分组下拉列表的变化（下面的steps语句之前apiserver中没有实现过）
		When bill关注jobs的公众号::apiserver
		When bill访问jobs的webapp::apiserver
		Then bill获得webapp分组下拉框信息::apiserver
			"""
			[]
			"""

@product @group 
Scenario:3 从商品分组中删除商品
	#从商品分组中删除商品，则商品分组中不再显示该商品，同时查看该商品详情的店内分组的变化

	Given jobs登录系统
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
		},{
			"name": "分组3",
			"products": []
		}]
		"""
	When jobs从商品分组'分组1'中删除商品'东坡肘子'
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1",
			"products": [{
				"name": "叫花鸡"
			}]
		},{
			"name": "分组2",
			"products": [{
				"name": "东坡肘子"
			}]
		},{
			"name": "分组3",
			"products": []
		}]
		"""
	And jobs能获取商品'东坡肘子'
		"""
		{
			"name": "东坡肘子",
			"category": ["分组2"],
			"price": 11.12,
			"stock_type": "无限"
		}
		"""
	#手机端校验分组中商品的变化
		When bill关注jobs的公众号::apiserver
		When bill访问jobs的webapp::apiserver
		And bill浏览jobs的webapp的'分组1'商品列表页::apiserver
		Then bill获得webapp商品列表::apiserver
			|   name   |
			|  叫花鸡  |

@product @group 
Scenario:4 向商品分组中添加商品
	#商品分组弹框的商品列表中不显示分组中已存在的商品

	Given jobs登录系统
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
		},{
			"name": "分组3",
			"products": []
		}]
		"""
	Then jobs能获得商品分组'分组3'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁",
			"price": 3.00,
			"status": "待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "叫花鸡",
			"price": 12.00,
			"status": "待售",
			"sales":0,
			"edite_time":"今天"
		},{
			"name": "东坡肘子",
			"price": 11.12,
			"status": "待售",
			"sales":0,
			"edite_time":"今天"
		}]
		"""
	And jobs能获得商品分组'分组2'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁",
			"price": 3.00,
			"status": "待售"
		},{
			"name": "叫花鸡",
			"price": 12.00,
			"status": "待售"
		}]
		"""
	And jobs能获得商品分组'分组1'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁",
			"price": 3.00,
			"status": "待售"
		}]
		"""
	When bill关注jobs的公众号::apiserver
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'分组3'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |
	#向分组中添加商品，查看分组列表、该分组可选商品集合、手机端该分组商品
	Given jobs登录系统
	When jobs向商品分组'分组3'中添加商品
		"""
		[
			"东坡肘子",
			"叫花鸡",
			"水晶虾仁"
		]
		"""
	When jobs向商品分组'分组2'中添加商品
		"""
		[
			"水晶虾仁"
		]
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
				"name": "水晶虾仁"
			},{
				"name": "东坡肘子"
			}]
		},{
			"name": "分组3",
			"products": [{
				"name": "水晶虾仁"
			},{
				"name": "叫花鸡"
			},{
				"name": "东坡肘子"
			}]
		}]
		"""
	And jobs能获得商品分组'分组3'的可选商品集合为
		"""
		[]
		"""
	And jobs能获得商品分组'分组2'的可选商品集合为
		"""
		[{
			"name": "叫花鸡",
			"price": 12.00,
			"status": "待售"
		}]
		"""
	And jobs能获得商品分组'分组1'的可选商品集合为
		"""
		[{
			"name": "水晶虾仁",
			"price": 3.00,
			"status": "待售"
		}]
		"""
	#手机端分组3中的商品变化
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'分组2'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |
		| 水晶虾仁 |
		| 东坡肘子 |
	When bill浏览jobs的webapp的'分组3'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |
		| 水晶虾仁 |
		| 叫花鸡   |
		| 东坡肘子 |

@product @group 
Scenario:5 更新商品分组中商品的排序
	jobs向分组中添加商品，可以进行排序
	1.在分组里，将待售商品放在最下面，只给在售商品排序，待售商品在排序列里没有输入框

	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name":"商品1",
			"price":9.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品2",
			"price":9.90
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品3",
			"price":9.90
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品4",
			"price":11.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name":"商品5",
			"price":13.00
		}
		"""
	when jobs批量上架商品
		"""
		["商品1","商品2","商品3","商品4","商品5"]
		"""
	When jobs向商品分组'分组3'中添加商品
		"""
		[
			"东坡肘子",
			"叫花鸡",
			"水晶虾仁"
		]
		"""
	And jobs向商品分组'分组3'中添加商品
		"""
		[
			"商品1",
			"商品2",
			"商品3",
			"商品4",
			"商品5"
		]
		"""
	#分组中商品默认排序显示为0
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1"
		},{
			"name": "分组2"
		},{
			"name": "分组3",
			"products": [{
				"name": "商品5",
				"price": 13.00,
				"status": "在售",
				"display_index": 0
			},{
				"name": "商品4",
				"price": 11.00,
				"status": "在售",
				"display_index": 0
			},{
				"name": "商品3",
				"price": 9.99,
				"status": "在售",
				"display_index": 0
			},{
				"name": "商品2",
				"price": 9.90,
				"status": "在售",
				"display_index": 0
			},{
				"name": "商品1",
				"price": 9.00,
				"status": "在售",
				"display_index": 0
			},{
				"name": "水晶虾仁",
				"price": 3.00,
				"status": "待售",
				"display_index": 0
			},{
				"name": "叫花鸡",
				"price": 12.00,
				"status": "待售",
				"display_index": 0
			},{
				"name": "东坡肘子",
				"price": 11.12,
				"status": "待售",
				"display_index": 0
			}]
		}]
		"""
	#手机端只验证商品顺序
	When bill关注jobs的公众号::apiserver
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'分组3'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |
		|  商品5   |
		|  商品4   |
		|  商品3   |
		|  商品2   |
		|  商品1   |
		| 水晶虾仁 |
		|  叫花鸡  |
		| 东坡肘子 |

	#修改分组中的商品排序，排序大于0，按照正序排列如：1,2,3,排序等于0按照加入分类时间排序
	Given jobs登录系统
	When jobs更新商品分组'分组3'中商品'商品3'商品排序2
	And jobs更新商品分组'分组3'中商品'商品2'商品排序3
	And jobs更新商品分组'分组3'中商品'商品1'商品排序1
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1"
		},{
			"name": "分组2"
		},{
			"name": "分组3",
			"products": [{
				"name": "商品1",
				"price": 9.00,
				"status": "在售",
				"display_index": 1
			},{
				"name": "商品3",
				"price": 9.99,
				"status": "在售",
				"display_index": 2
			},{
				"name": "商品2",
				"price": 9.90,
				"status": "在售",
				"display_index": 3
			},{
				"name": "商品5",
				"price": 13.00,
				"status": "在售",
				"display_index": 0
			},{
				"name": "商品4",
				"price": 11.00,
				"status": "在售",
				"display_index": 0
			},{
				"name": "水晶虾仁",
				"price": 3.00,
				"status": "待售",
				"display_index": 0
			},{
				"name": "叫花鸡",
				"price": 12.00,
				"status": "待售",
				"display_index": 0
			},{
				"name": "东坡肘子",
				"price": 11.12,
				"status": "待售",
				"display_index": 0
			}]
		}]
		"""
	#手机端只验证商品顺序
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'分组3'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |
		|  商品1   |
		|  商品3   |
		|  商品2   |
		|  商品5   |
		|  商品4   |
		| 水晶虾仁 |
		|  叫花鸡  |
		| 东坡肘子 |

	#已存在商品顺序x的情况下更新其他商品的顺序为x
	Given jobs登录系统
	When jobs更新商品分组'分组3'中商品'商品4'商品排序1
	#Then jobs获得提示'位置1已存在商品，是否替换'
	When jobs更新商品分组'分组3'中商品'商品2'商品排序2
	#Then jobs获得提示'位置2已存在商品，是否替换'
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1"
		},{
			"name": "分组2"
		},{
			"name": "分组3",
			"products": [{
				"name": "商品4",
				"price": 11.00,
				"status": "在售",
				"display_index": 1
			},{
				"name": "商品2",
				"price": 9.99,
				"status": "在售",
				"display_index": 2
			},{
				"name": "商品5",
				"price": 13.00,
				"status": "在售",
				"display_index": 0
			},{
				"name": "商品3",
				"price": 9.90,
				"status": "在售",
				"display_index": 0
			},{
				"name": "商品1",
				"price": 9.00,
				"status": "在售",
				"display_index": 0
			},{
				"name": "水晶虾仁",
				"price": 3.00,
				"status": "待售",
				"display_index": 0
			},{
				"name": "叫花鸡",
				"price": 12.00,
				"status": "待售",
				"display_index": 0
			},{
				"name": "东坡肘子",
				"price": 11.12,
				"status": "待售",
				"display_index": 0
			}]
		}]
		"""
	#手机端只验证商品顺序
	When bill访问jobs的webapp::apiserver
	And bill浏览jobs的webapp的'分组3'商品列表页::apiserver
	Then bill获得webapp商品列表::apiserver
		|   name   |
		|  商品4   |
		|  商品2   |
		|  商品5   |
		|  商品3   |
		|  商品1   |
		| 水晶虾仁 |
		|  叫花鸡  |
		| 东坡肘子 |

#补充：张三香 2016.08.05
@product @group
Scenario:6 查看商品分组中商品的变化（上架、下架或彻底删除商品）
	Given jobs登录系统
	When jobs添加商品分组
		"""
		{
			"name": "分组a"
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品a",
			"category":["分组a"],
			"price": 11.00,
			"stock_type": "无限"
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品b",
			"category":["分组a"],
			"price": 12.00,
			"stock_type": "有限",
			"stocks": 3
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品c",
			"category":["分组a"],
			"price":13.00
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品d",
			"category":["分组a"],
			"price": 14.00
		}
		"""
	When jobs批量上架商品
		"""
		["商品a","商品b"]
		"""
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组a",
			"products": [{
				"name": "商品b",
				"price": 12.00,
				"status": "在售"
			},{
				"name": "商品a",
				"price": 11.00,
				"status": "在售"
			},{
				"name": "商品d",
				"price": 14.00,
				"status": "待售"
			},{
				"name": "商品c",
				"price": 13.00,
				"status": "待售"
			}]
		}]
		"""
	When jobs批量下架商品
		"""
		["商品a"]
		"""
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组a",
			"products": [{
				"name": "商品b",
				"price": 12.00,
				"status": "在售"
			},{
				"name": "商品d",
				"price": 14.00,
				"status": "待售"
			},{
				"name": "商品c",
				"price": 13.00,
				"status": "待售"
			},{
				"name": "商品a",
				"price": 11.00,
				"status": "待售"
			}]
		}]
		"""
	When jobs批量上架商品
		"""
		["商品c"]
		"""
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组a",
			"products": [{
				"name": "商品c",
				"price": 13.00,
				"status": "在售"
			},{
				"name": "商品b",
				"price": 12.00,
				"status": "在售"
			},{
				"name": "商品d",
				"price": 14.00,
				"status": "待售"
			},{
				"name": "商品a",
				"price": 11.00,
				"status": "待售"
			}]
		}]
		"""
	When jobs彻底删除商品
		"""
		["商品b","商品d"]
		"""
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组a",
			"products": [{
				"name": "商品c",
				"price": 13.00,
				"status": "在售"
			},{
				"name": "商品a",
				"price": 11.00,
				"status": "待售"
			}]
		}]
		"""

#补充：张三香 2016.09.12
@product @group
Scenario:7 商品分组列表中商品销量的校验
	Given jobs登录系统
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1",
			"products": [{
				"name": "叫花鸡",
				"sales":0
			},{
				"name": "东坡肘子",
				"sales":0
			}]
		},{
			"name": "分组2",
			"products": [{
				"name": "东坡肘子",
				"sales":0
			}]
		},{
			"name": "分组3",
			"products": []
		}]
		"""
	When bill关注jobs的公众号::apiserver
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"001",
			"ship_name": "bill",
			"ship_tel": "13811223344",
			"ship_area": "北京市 北京市 海淀区",
			"ship_address": "泰兴大厦",
			"pay_type":"货到付款",
			"products": [{
				"name": "东坡肘子",
				"count": 1
			}]
		}
		"""
	Given jobs登录系统
	Then jobs能获取商品分组列表
		"""
		[{
			"name": "分组1",
			"products": [{
				"name": "叫花鸡",
				"sales":0
			},{
				"name": "东坡肘子",
				"sales":1
			}]
		},{
			"name": "分组2",
			"products": [{
				"name": "东坡肘子",
				"sales":1
			}]
		},{
			"name": "分组3",
			"products": []
		}]
		"""