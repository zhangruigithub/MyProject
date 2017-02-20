#_author_:李娜 2016.08.16

Feature: 待售商品管理列表查询
	"""
		（1）库存查询，任何查询条件下查询都会查询出来库存为”无限“的商品
		（2）库存查询，多规格商品只要有一个规格的库存满足查询条件，就可以查询出来此商品
		（3）销量查询，多规格商品按照各规格商品销量的和去匹配查询条件，进行查询
		（4）商品价格、商品库存和商品销量的查询支持只输入最低值或只输入最高值
			 商品库存只输入库存最低值时，能把库存为无限的商品查询出来
		 (5)数据准备：
			|  name        |  barcode  |   category       | price         |  stocks  |  sales  |  created_at       |
			|  商品复合规格|           |                  |  10.5 ~ 40.0  |  100-400 |    4    |  2015-07-02 10:20 |
			|  商品单规格  |           |                  |  10.0 ~ 20.0  |  3/无限  |    2    |  2015-07-02 10:20 |
			|  商品4       |  1234562  |                  |   0           |  100000  |    0    |  2015-08-01 05:36 |
			|  商品3       |  1234562  | 分组1,分组2,分组3|   1           |   98     |    1    |  2015-07-02 10:20 |
			|  商品2       |  1234561  | 分组1,分组2      |   10          |    0     |    0    |  2015-04-03 00:00 |
			|  商品1       |           | 分组1            |  0.01         |   无限   |    5    |  2015-04-02 23:59 |
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
		When jobs添加商品分组
			"""
			{
				"name": "分组4"
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
		When jobs添加商品
			"""
			{
				"name":"商品1",
				"bar_code":"",
				"category":["分组1"],
				"price":0.01,
				"stock_type":"无限",
				"create_time":"2015-04-02 23:59"
			}
			"""
		When jobs添加商品
			"""
			{
				"name":"商品2",
				"bar_code":"1234561",
				"category":["分组1","分组2"],
				"price":10.00,
				"stock_type":"有限",
				"stocks":0,
				"create_time":"2015-04-03 00:00"
			}
			"""
		When jobs添加商品
			"""
			{
				"name":"商品3",
				"bar_code":"1234562",
				"category":["分组1","分组2","分组3"],
				"price":1.00,
				"stock_type":"有限",
				"stocks":100,
				"create_time":"2015-07-02 10:20"
			}
			"""
		When jobs添加商品
			"""
			{
				"name":"商品4",
				"bar_code":"1234562",
				"categroy":[],
				"price":0.00,
				"stock_type":"有限",
				"stocks":100000,
				"create_time":"2015-08-01 05:36"
			}
			"""
		And jobs添加商品
			"""
			{
				"name": "商品单规格",
				"is_enable_model": true,
				"create_time": "2015-07-02 10:20",
				"model": {
					"models": {
						"黑色": {
							"price": 10.00,
							"weight": 3,
							"stock_type": "有限",
							"stocks": 3
						},
						"白色": {
							"price": 20.00,
							"weight": 4,
							"stock_type": "无限"
						}
					}
				}
			}
			"""
		And jobs添加商品
			"""
			{
				"name": "商品复合规格",
				"is_enable_model":true,
				"create_time": "2015-07-02 10:20",
				"model": {
					"models": {
						"黑色 S": {
							"price": 10.50,
							"weight": 1,
							"stock_type": "有限",
							"stocks": 100
						},
						"白色 S": {
							"price": 20.00,
							"weight": 2,
							"stock_type": "有限",
							"stocks": 200
						},
						"黑色 M": {
							"price": 30.00,
							"weight": 3,
							"stock_type": "有限",
							"stocks": 300
						},
						"白色 M": {
							"price": 40.00,
							"weight": 4,
							"stock_type": "有限",
							"stocks": 400
						}
					}
				}
			}
			"""
	#上架商品
		When jobs批量上架商品
			"""
			["商品1","商品2","商品3","商品4","商品单规格","商品复合规格"]
			"""

	When bill关注jobs的公众号::apiserver
	And tom关注jobs的公众号::apiserver

	When 微信用户批量消费jobs的商品
		|order_id| date       | consumer |   product | payment | pay_type |   price*    | paid_amount*   |  alipay*   | wechat*   | cash*    |     action    |  order_status*  |delivery_time|payment_time  |
		|0001    | 2015-04-05 | bill     | 商品1,1   | 支付    | 支付宝   |   0.01      |    0.01        |  0.01      | 0.00      | 0.00     | jobs,完成     |  已完成         | 2015-04-05  |  2015-04-05  |
		|0002    | 2015-04-06 | bill     | 商品1,1   | 支付    | 微信支付 |   0.01      |    0.01        |  0.00      | 0.01      | 0.00     | jobs,发货     |  已发货         | 2015-04-06  |  2015-04-06  |
		|0003    | 2015-04-07 | bill     | 商品1,1   | 支付    | 微信支付 |   0.01      |    0.01        |  0.00      | 0.01      | 0.00     | jobs,退款     |  退款中         | 2015-04-06  |  2015-04-06  |
		|0004    | 2015-04-07 | bill     | 商品1,1   | 支付    | 货到付款 |   0.01      |    0.01        |  0.00      | 0.00      | 0.01     |               |  待发货         |             |  2015-04-07  |
		|0005    | 2015-07-03 | tom      | 商品3,1   | 支付    | 货到付款 |   1.00      |    1.00        |  0.00      | 0.00      | 0.00     | jobs,取消     |  已取消         |             |  2015-07-03  |
		|0006    | 2015-07-04 | tom      | 商品3,1   | 支付    | 支付宝   |   1.00      |    1.00        |  1.00      | 0.00      | 0.00     | jobs,发货     |  已发货         |  2015-07-03 |  2015-07-03  |
		|0007    | 2015-07-01 | tom2     | 商品1,1   | 支付    | 支付宝   |   0.01      |    0.01        |  0.01      | 0.00      | 0.00     | jobs,发货     |  已发货         |  2015-07-01 |  2015-07-01  |
		|0008    | 2015-07-10 | tom      | 商品3,1   |         | 微信支付 |   1.00      |    1.00        |  0.00      | 1.00      | 0.00     |               |  待支付         |             |              |
		|0009    | 2015-07-02 | tom      | 商品3,1   |         | 微信支付 |   1.00      |    1.00        |  0.00      | 0.00      | 0.00     | jobs,完成退款 |  退款成功       |  2015-07-02 |  2015-07-02  |

	#购买多规格商品
		When bill访问jobs的webapp::apiserver
		And bill购买jobs的商品::apiserver
			"""
			{
				"products": [{
					"name": "商品单规格",
					"count": 2,
					"model": "黑色"
				}]
			}
			"""
		And bill使用支付方式'货到付款'进行支付::apiserver
		When bill购买jobs的商品::apiserver
			"""
			{
				"products": [{
					"name": "商品复合规格",
					"count": 1,
					"model": "白色 S"
				},{
					"name": "商品复合规格",
					"count": 3,
					"model": "黑色 M"
				}]
			}
			"""
		And bill使用支付方式'货到付款'进行支付::apiserver

	#下架商品
		Given jobs登录系统
		When jobs批量下架商品
			"""
			["商品1","商品2","商品3","商品4","商品单规格","商品复合规格"]
			"""

@product @toSaleProduct
Scenario:1 待售商品管理列表'默认'（空）查询
	Given jobs登录系统
	When jobs设置待售商品管理列表查询条件
		"""
		{}
		"""
	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name": "商品复合规格"}
		},{
			"product_info":{"name": "商品单规格"}
		},{
			"product_info":{"name": "商品4"}
		},{
			"product_info":{"name": "商品3"}
		},{
			"product_info":{"name": "商品2"}
		},{
			"product_info":{"name": "商品1"}
		}]
		"""

@product @toSaleProduct
Scenario:2 待售商品管理列表'商品名称'查询
	#完全匹配
		Given jobs登录系统
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"name":"商品2"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品2"}
			}]
			"""
	#部分匹配
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"name":"商品"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品复合规格"}
			},{
				"product_info":{"name": "商品单规格"}
			},{
				"product_info":{"name": "商品4"}
			},{
				"product_info":{"name": "商品3"}
			},{
				"product_info":{"name": "商品2"}
			},{
				"product_info":{"name": "商品1"}
			}]
			"""
	#查询结果为空
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"name":"商  2"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[]
			"""

@product @toSaleProduct
Scenario:3 待售商品管理列表'商品条码'查询
	#完全匹配
		Given jobs登录系统
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"barcode":"1234562"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品4"},
				"bar_code":"1234562"
			},{
				"product_info":{"name": "商品3"},
				"bar_code":"1234562"
			}]
			"""
	#查询结果为空
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"barcode":"123456"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[]
			"""

@product @toSaleProduct
Scenario:4 待售商品管理列表'商品价格'查询
	#只填写'最低价格'0，能查询出价格'大于等于0'的所有商品
		Given jobs登录系统
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowPrice":"0.00",
				"highPrice":""
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品复合规格"},
				"price":"10.50-40.00"
			},{
				"product_info":{"name": "商品单规格"},
				"price":"10.00-20.00"
			},{
				"product_info":{"name": "商品4"},
				"price":"0.00"
			},{
				"product_info":{"name": "商品3"},
				"price":"1.00"
			},{
				"product_info":{"name": "商品2"},
				"price":"10.00"
			},{
				"product_info":{"name": "商品1"},
				"price":"0.01"
			}]
			"""
	#只填写'最高价格'1，能查询出价格'小于等于1'的所有商品
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowPrice":"",
				"highPrice":"1.00"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品4"},
				"price":"0.00"
			},{
				"product_info":{"name": "商品3"},
				"price":"1.00"
			},{
				"product_info":{"name": "商品1"},
				"price":"0.01"
			}]
			"""
	#价格区间查询
		#填写价格最低值和最高值，有一个规格的价格在查询区间
			When jobs设置待售商品管理列表查询条件
				"""
				{
					"lowPrice":"0.01",
					"highPrice":"10.00"
				}
				"""
			Then jobs能获得'待售'商品列表
				"""
				[{
					"product_info":{"name": "商品单规格"},
					"price":"10.00-20.00"
				},{
					"product_info":{"name": "商品3"},
					"price":"1.00"
				},{
					"product_info":{"name": "商品2"},
					"price":"10.00"
				},{
					"product_info":{"name": "商品1"},
					"price":"0.01"
				}]
				"""
		#填写价格最低值和最高值，没有任何一个价格在查询区间
			When jobs设置待售商品管理列表查询条件
				"""
				{
					"lowPrice":"60.00",
					"highPrice":"70.00"
				}
				"""
			Then jobs能获得'待售'商品列表
				"""
				[]
				"""
		#填写价格最低值和最高值，最低值和最高值相等
			Given jobs登录系统
			When jobs设置待售商品管理列表查询条件
				"""
				{
					"lowPrice":"10.00",
					"highPrice":"10.00"
				}
				"""
			Then jobs能获得'待售'商品列表
				"""
				[{
					"product_info":{"name": "商品单规格"},
					"price":"10.00-20.00"
				},{
					"product_info":{"name": "商品2"},
					"price":"10.00"
				}]
				"""
		#目前系统允许输入'最低价格'大于'最高价格'，查询结果为空
			When jobs设置待售商品管理列表查询条件
					"""
					{
						"lowPrice":"100.00",
						"highPrice":"10.00"
					}
					"""
				Then jobs能获得'待售'商品列表
					"""
					[]
					"""
	#查询结果为空
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowPrice":"10.01",
				"highPrice":"100.00"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[]
			"""

@product @toSaleProduct
Scenario:5 待售商品管理列表'商品库存'查询
	#只填写库存最低值,能查询出库存为无限的商品（存在一个规格的库存为'无限'的商品也能查询出来）
		Given jobs登录系统
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowStocks":"1",
				"highStocks":""
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":
					{
						"name": "商品复合规格",
						"model": {
							"models": {
								"黑色 S": {
									"stock_type": "有限",
									"stocks": 100
									},
								"白色 S": {
									"stock_type": "有限",
									"stocks": 200
									},
								"黑色 M": {
									"stock_type": "有限",
									"stocks": 300
									},
								"白色 M": {
									"stock_type": "有限",
									"stocks": 400
									}
							}
						}
					},
				"stock":""
			},{
				"product_info":
					{
						"name": "商品单规格",
						"model": {
							"models": {
								"黑色": {
									"stock_type": "有限",
									"stocks": 3
									},
								"白色": {
									"stock_type": "无限"
									}
								}
							}
					},
				"stock":""
			},{
				"product_info":{"name": "商品4"},
				"stock":"100000"
			},{
				"product_info":{"name": "商品3"},
				"stock":"98"
			},{
				"product_info":{"name": "商品1"},
				"stock":"无限"
			}]
			"""
	#只填写最高库存,不能查询出库存均为'无限'的商品(存在无限、有限的多规格商品，若有限的库存在查询区间内也能查询出来)
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowStocks":"",
				"highStocks":"100000"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":
					{
						"name": "商品复合规格",
						"model": {
							"models": {
								"黑色 S": {
									"stock_type": "有限",
									"stocks": 100
									},
								"白色 S": {
									"stock_type": "有限",
									"stocks": 200
									},
								"黑色 M": {
									"stock_type": "有限",
									"stocks": 300
									},
								"白色 M": {
									"stock_type": "有限",
									"stocks": 400
									}
							}
						}
					},
				"stock":""
			},{
				"product_info":
					{
						"name": "商品单规格",
						"model": {
							"models": {
								"黑色": {
									"stock_type": "有限",
									"stocks": 3
									},
								"白色": {
									"stock_type": "无限"
									}
								}
							}
					},
				"stock":""
			},{
				"product_info":{"name": "商品4"},
				"stock":"100000"
			},{
				"product_info":{"name": "商品3"},
				"stock":"98"
			},{
				"product_info":{"name": "商品2"},
				"stock":"0"
			}]
			"""
	#库存区间查询（多规格中一个库存有限，一个无限，查有限（或无限）时都能将该商品查出来）
		#'库存最低值'小于'库存最高值'
			When jobs设置待售商品管理列表查询条件
				"""
				{
					"lowStocks":"0",
					"highStocks":"98"
				}
				"""
			Then jobs能获得'待售'商品列表
				"""
				[{
					"product_info":
						{
							"name": "商品单规格",
							"model": {
								"models": {
									"黑色": {
										"stock_type": "有限",
										"stocks": 3
										},
									"白色": {
										"stock_type": "无限"
										}
									}
								}
						},
					"stock":""
				},{
					"product_info":{"name": "商品3"},
					"stock":"98"
				},{
					"product_info":{"name": "商品2"},
					"stock":"0"
				}]
				"""
		#'库存最低值'等于'库存最高值'
			When jobs设置待售商品管理列表查询条件
				"""
				{
					"lowStocks":"98",
					"highStocks":"98"
				}
				"""
			Then jobs能获得'待售'商品列表
				"""
				[{
					"product_info":{"name": "商品3"},
					"stock":"98"
				}]
				"""
		#'库存最低值'大于'库存最高值'（目前系统允许输入，查询结果为空）
			When jobs设置待售商品管理列表查询条件
					"""
					{
						"lowStocks":"100",
						"highStocks":"20"
					}
					"""
				Then jobs能获得'待售'商品列表
					"""
					[]
					"""
	#查询结果为空
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowStocks":"10",
				"highStocks":"20"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[]
			"""

@product @toSaleProduct
Scenario:6 待售商品管理列表'商品销量'查询
	商品销量查询（多规格商品是每个规格的销量之和计算）

	#只填写销量最低值
		Given jobs登录系统
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowSales":"0",
				"highSales":""
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品复合规格"},
				"sales":4
			},{
				"product_info":{"name": "商品单规格"},
				"sales":2
			},{
				"product_info":{"name": "商品4"},
				"sales":0
			},{
				"product_info":{"name": "商品3"},
				"sales":1
			},{
				"product_info":{"name": "商品2"},
				"sales":0
			},{
				"product_info":{"name": "商品1"},
				"sales":5
			}]
			"""
	#只填写销量最高值
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowSales":"",
				"highSales":"2"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品单规格"},
				"sales":2
			},{
				"product_info":{"name": "商品4"},
				"sales":0
			},{
				"product_info":{"name": "商品3"},
				"sales":1
			},{
				"product_info":{"name": "商品2"},
				"sales":0
			}]
			"""
	#销量区间查询
		#销量最低值小于销量最高值
			When jobs设置待售商品管理列表查询条件
				"""
				{
					"lowSales":"0",
					"highSales":"4"
				}
				"""
			Then jobs能获得'待售'商品列表
				"""
				[{
					"product_info":{"name": "商品复合规格"},
					"sales":4
				},{
					"product_info":{"name": "商品单规格"},
					"sales":2
				},{
					"product_info":{"name": "商品4"},
					"sales":0
				},{
					"product_info":{"name": "商品3"},
					"sales":1
				},{
					"product_info":{"name": "商品2"},
					"sales":0
				}]
				"""
		#销量最低值等于销量最高值
			When jobs设置待售商品管理列表查询条件
				"""
				{
					"lowSales":"1",
					"highSales":"1"
				}
				"""
			Then jobs能获得'待售'商品列表
				"""
				[{
					"product_info":{"name": "商品3"},
					"sales":1
				}]
				"""
		#销量最低值大于销量最高值（目前系统允许输入，查询结果为空）
			When jobs设置待售商品管理列表查询条件
					"""
					{
						"lowSales":"100",
						"highSales":"2"
					}
					"""
				Then jobs能获得'待售'商品列表
					"""
					[]
					"""
	#查询结果为空
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"lowSales":"6",
				"highSales":"10"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[]
			"""

@product @toSaleProduct
Scenario:7 待售商品管理列表'店内分组'查询
	#查询结果非空
		Given jobs登录系统
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"category":"分组1"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品3"},
				"category": ["分组1","分组2","分组3"]
			},{
				"product_info":{"name": "商品2"},
				"category": ["分组1","分组2"]
			},{
				"product_info":{"name": "商品1"},
				"category": ["分组1"]
			}]
			"""

		When jobs设置待售商品管理列表查询条件
			"""
			{
				"category":"分组3"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品3"},
				"category": ["分组1","分组2","分组3"]
			}]
			"""
	#查询结果为空
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"category":"分组4"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[]
			"""

@product @toSaleProduct
Scenario:8 待售商品管理列表'创建时间'查询
	#查询结果非空
		Given jobs登录系统
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"startDate":"2015-04-01 00:00",
				"endDate":"2015-04-03 00:00"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[{
				"product_info":{"name": "商品2"},
				"create_time":"2015-04-03 00:00"
			},{
				"product_info":{"name": "商品1"},
				"create_time":"2015-04-02 23:59"
			}]
			"""
	#查询结果为空
		When jobs设置待售商品管理列表查询条件
			"""
			{
				"startDate":"2015-7-10 00:00",
				"endDate":"2015-07-20 00:00"
			}
			"""
		Then jobs能获得'待售'商品列表
			"""
			[]
			"""

@product @toSaleProduct
Scenario:9 待售商品管理列表条件混合查询
	Given jobs登录系统
	When jobs设置待售商品管理列表查询条件
		"""
		{
			"name":"商品",
			"barCode":"1234562",
			"lowPrice":"0.00",
			"highPrice":"1.00",
			"lowStocks":"2",
			"highStocks":"100000",
			"lowSales":"0",
			"highSales":"1",
			"category":"分组3",
			"startDate":"2015-07-02 10:20",
			"endDate":"2015-07-20 10:20"
		}
		"""

	Then jobs能获得'待售'商品列表
		"""
		[{
			"product_info":{"name": "商品3"}
		}]
		"""
































