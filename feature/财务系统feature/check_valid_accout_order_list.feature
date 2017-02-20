#_author_:张三香 2016.05.09

Feature:结算单页面可选取结算订单列表
	"""
		1、结算对象为'本店'时，结算订单显示规则：
			a.只显示有微众卡支付的'已完成'状态的订单
			b.已被结算过的订单，不显示
			c.订单在已完成状态时未提交结算单,在退款完成或取消订单后提交结算单时,该订单不显示
			d.订单在已完成状态时有提交结算单,在退款完成或取消订单后提交结算单时,该订单显示(结算金额为-xx.xx)
			e.没有经过'已完成'状态而变成'退款完成'或'已取消'的订单，该订单不显示
		2、结算对象为'商城'时，结算订单显示规则：
			a.只显示订单状态为'已完成'的订单
			b.已被结算过的订单，不显示
			c.订单在已完成状态时未提交结算单,在退款完成或取消订单后提交结算单时,该订单不显示
			d.订单在已完成状态时有提交结算单,在退款完成或取消订单后提交结算单时,该订单显示(结算金额为-xx.xx)
			e.没有经过'已完成'状态而变成'退款完成'或'已取消'的订单，该订单不显示
		3、优先显示并选中'退款完成'状态的订单，其次显示并选中'已取消'状态的，其余订单按照订单的完成时间倒序显示
	"""

Background:
	#bill为普通商家；jobs为自营平台；admin为财务系统管理者

	#普通商家bill的信息
		Given 添加bill店铺名称为'bill商家'
		Given bill登录系统
		Given bill已添加了优惠券规则
			"""
			[{
				"name": "全体券1",
				"money": 50.00,
				"start_date": "今天",
				"end_date": "10天后",
				"coupon_id_prefix": "coupon1_id_"
			},{
				"name": "全体券2",
				"money": 300.00,
				"start_date": "今天",
				"end_date": "10天后",
				"coupon_id_prefix": "coupon2_id_"
			}]
			"""
		And bill已添加支付方式
			"""
			[{
				"type": "微信支付",
				"is_active": "启用"
			}, {
				"type": "支付宝",
				"is_active": "启用"
			}, {
				"type": "货到付款",
				"is_active": "启用"
			}]
			"""
		When bill开通使用微众卡权限
		When bill添加支付方式
			"""
			[{
				"type": "微众卡支付",
				"is_active": "启用"
			}]
			"""
		Given bill已创建微众卡
			"""
			{
				"cards": [{
					"id": "0000101",
					"password": "123456",
					"status": "未使用",
					"price": 110.00
				},{
					"id": "0000102",
					"password": "223456",
					"status": "未使用",
					"price": 150.00
				},{
					"id": "0000103",
					"password": "323456",
					"status": "未使用",
					"price": 60.00
				},{
					"id": "0000104",
					"password": "423456",
					"status": "未使用",
					"price": 50.00
				}]
			}
			"""
		Given bill设定会员积分策略
			"""
			{
				"integral_each_yuan": 1,
				"use_ceiling": 100,
				"be_member_increase_count": 250
			}
			"""
		Given bill已添加商品规格
			"""
			[{
				"name": "尺寸",
				"type": "文字",
				"values": [{
					"name": "M"
				}, {
					"name": "S"
				}]
			}]
			"""
		And bill已添加商品
			"""
			[{
				"name": "bill商品1",
				"model": {
					"models": {
						"standard": {
							"price": 100.00,
							"user_code":"1111",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				},
				"postage":10.00
			},{
				"name": "bill商品2",
				"model": {
					"models": {
						"standard": {
							"price": 200.00,
							"user_code":"1112",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			},{
				"name": "bill商品3",
				"is_enable_model": "启用规格",
				"model": {
					"models": {
						"M": {
							"price": 310.00,
							"user_code":"1113",
							"weight":1.0,
							"stock_type": "有限",
							"stocks":100
						},
						"S": {
							"price": 320.00,
							"user_code":"1114",
							"weight":1.0,
							"stock_type": "无限"
						}
					}
				}
			}]
			"""

	#自营平台jobs的信息
		Given 设置jobs为自营平台账号
		Given jobs登录系统
		And jobs已添加供货商
			"""
			[{
				"name": "供货商1",
				"responsible_person": "宝宝",
				"supplier_tel": "13811223344",
				"supplier_address": "北京市海淀区泰兴大厦",
				"remark": "备注卖花生油"
			}, {
				"name": "供货商2",
				"responsible_person": "陌陌",
				"supplier_tel": "13811223344",
				"supplier_address": "北京市海淀区泰兴大厦",
				"remark": ""
			}]
			"""
		And jobs已添加支付方式
			"""
			[{
				"type": "微信支付",
				"is_active": "启用"
			}, {
				"type": "支付宝",
				"is_active": "启用"
			}, {
				"type": "货到付款",
				"is_active": "启用"
			}]
			"""
		When jobs开通使用微众卡权限
		When jobs添加支付方式
			"""
			[{
				"type": "微众卡支付",
				"is_active": "启用"
			}]
			"""
		Given jobs设定会员积分策略
			"""
			{
				"integral_each_yuan": 2,
				"use_ceiling": 50,
				"be_member_increase_count": 100
			}
			"""
		Given jobs已创建微众卡
			"""
			{
				"cards": 
				[{
					"id": "0000105",
					"password": "0105",
					"status": "未使用",
					"price": 50.00
				}]
			}
			"""
		And jobs已添加商品
			"""
			[{
				"supplier": "供货商1",
				"name": "jobs商品1",
				"price": 10.00,
				"purchase_price": 9.00,
				"weight": 1.0,
				"stock_type": "无限"
			}, {
				"supplier": "供货商2",
				"name": "jobs商品2",
				"price": 20.00,
				"purchase_price": 19.00,
				"weight": 1.0,
				"stock_type": "有限",
				"stocks": 10
				}]
			}]
			"""
		When jobs将商品池商品批量放入待售于'2016-08-02 12:30'
			"""
			[
				"bill商品2", "bill商品1"
			]
			"""
		And jobs更新商品'bill商品1'
			"""
			{
				"name": "bill商品1",
				"supplier":"bill商家",
				"purchase_price": 90.00,
				"model": {
					"models": {
						"standard": {
							"price": 100.00,
							"user_code":"1111",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			}
			"""
		And jobs更新商品'bill商品2'
			"""
			{
				"name": "bill商品2",
				"supplier":"bill商家",
				"purchase_price": 190.00,
				"model": {
					"models": {
						"standard": {
							"price": 200.00,
							"user_code":"1112",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			}
			"""
		And jobs批量上架商品
			"""
			[
				"bill商品2",
				"bill商品1"
			]
			"""

	When tom关注bill的公众号
	When tom访问bill的webapp
	When tom领取bill的优惠券
		"""
		[{
			"name": "全体券1",
			"coupon_ids": ["coupon1_id_3","coupon1_id_2","coupon1_id_1"]
		},{
			"name": "全体券2",
			"coupon_ids": ["coupon2_id_1"]
		}]
		"""
	When lily关注bill的公众号
	When tom关注jobs的公众号
	When lily关注jobs的公众号
	#订单数据
		When 微信用户批量消费bill的商品
			| order_id |    date    | payment_time | delivery_time | finish_time   | consumer |    product     | payment | pay_type  |postage*|price*|integral | product_integral |       coupon         | paid_amount* |  weizoom_card     | alipay* | wechat* | cash* |   action      | order_status* |
			|   0001   | 2016-04-01 |              |               |               |   tom    | bill商品1,1    |         |  微信支付 |   10   | 100  |   0     |        0         |                      |     110      |                   |   0     |  110    |   0   |               |    待支付     |
			|   0002   | 2016-04-02 |              |               |               |   tom    | bill商品1,1    |         |  支付宝   |   10   | 100  |   0     |        0         |                      |     110      |                   |   110   |    0    |   0   |  jobs,取消    |    已取消     |
			|   0003   | 2016-04-03 | 2016-04-03   |               |               |   tom    | bill商品1,1    |   支付  |  货到付款 |   10   | 100  |   0     |        0         |                      |     110      |                   |    0    |    0    |   110 |               |    待发货     |
			|   0004   | 2016-04-04 | 2016-04-04   | 2016-04-04    |               |   tom    | bill商品2,1    |   支付  |  货到付款 |   0    | 200  |   0     |        0         |                      |     200      |                   |    0    |    0    |   200 |  jobs,发货    |    已发货     |
			|   0005   | 2016-04-05 | 2016-04-05   | 2016-04-05    |               |   tom    | bill商品1,1    |   支付  |  支付宝   |   10   | 100  |   0     |        0         |                      |     110      |                   |   110   |    0    |   0   |  jobs,退款    |    退款中     |

			|   0006   | 2016-04-06 | 2016-04-06   | 2016-04-06    | 2016-04-06    |   tom    | bill商品2,1    |   支付  |  优惠抵扣 |   0    | 200  |   0     |        0         |全体券2,coupon2_id_1  |     0        |                   |   0     |    0    |   0   |  jobs,完成    |    已完成     |
			|   0007   | 2016-04-07 | 2016-04-07   | 2016-04-07    | 2016-04-07    |   tom    | bill商品2,1    |   支付  |  优惠抵扣 |   0    | 200  |   200   |        0         |                      |     0        |                   |   0     |    0    |   0   |  jobs,完成    |    已完成     |
			|   0008   | 2016-04-08 | 2016-04-08   | 2016-04-08    | 2016-04-08    |   tom    | bill商品1,1    |   支付  |  微信支付 |   10   | 100  |   0     |        0         |                      |     110      |                   |   0     |   110   |   0   |  jobs,完成    |    已完成     |
			|   0009   | 2016-04-09 | 2016-04-09   | 2016-04-09    | 2016-04-09    |   tom    | bill商品1,1    |   支付  |  支付宝   |   10   | 100  |   50    |        0         |                      |     60       |                   |   60    |    0    |   0   |  jobs,完成    |    已完成     |
			|   0010   | 2016-04-10 | 2016-04-10   | 2016-04-10    | 2016-04-10    |   tom    | bill商品2,1    |   支付  |  微信支付 |   0    | 200  |   0     |        0         |全体券1,coupon1_id_1  |     150      |                   |   0     |    150  |   0   |  jobs,完成    |    已完成     |

			|   0101   | 2016-05-11 | 2016-05-11   | 2016-05-11    | 2016-05-11    |   tom    | bill商品1,1    |   支付  |  优惠抵扣 |   10   | 100  |   0     |        0         |                      |     110      |  0000101,123456   |   0     |    0    |   0   |  jobs,完成    |    已完成     |
			|   0102   | 2016-05-12 | 2016-05-12   | 2016-05-12    | 2016-05-12    |   lily   | bill商品2,2    |   支付  |  优惠抵扣 |   0    | 200  |   250   |        0         |                      |     150      |  0000102,223456   |   0     |    0    |   0   |  jobs,完成    |    已完成     |
			|   0103   | 2016-05-13 | 2016-05-13   | 2016-05-13    | 2016-05-13    |   tom    | bill商品1,1    |   支付  |  优惠抵扣 |   10   | 100  |   0     |        0         |全体券1,coupon1_id_2  |     60       |  0000103,323456   |   0     |    0    |   0   |  jobs,完成    |    已完成     |
			|   0104   | 2016-05-14 | 2016-05-14   | 2016-05-14    | 2016-05-14    |   lily   | bill商品1,1    |   支付  |  微信支付 |   10   | 100  |   0     |        0         |                      |     110      |  0000104,423456   |   0     |    60   |   0   |  jobs,完成    |    已完成     |

Scenario:1 未完成的订单，可选取结算订单列表中不显示
	#0001-本店-待支付 2016.04.01
	#0002-本店-已取消 2016.04.02
	#0003-本店-待发货 2016.04.03
	#0004-本店-已发货 2016.04.04
	#0005-本店-退款中 2016.04.05

	#1001-商城-待发货
	#1002-商城-已发货

	#结算对象为'本店'，未完成的订单不显示
		Given bill登录系统
		When bill创建结算单时设置结算信息
			"""
			{
				"account_shop":"本店",
				"account_start_date":"2016.04.01 00:00:00",
				"account_end_date":"2016.05.01 00:00:00"
			}
			"""
		Then bill获得可选取结算订单列表
			"""
			[]
			"""
	#结算对象为自营平台，未完成的订单不显示
		#1001-商城-待发货
		When tom访问jobs的webapp
		When tom购买jobs的商品
			"""
			{
				"order_id":"1001",
				"pay_type":"微信支付",
				"products":[{
					"name":"bill商品1",
					"count":1
				}]
			}
			"""
		When tom使用支付方式'微信支付'进行支付订单'1001'
		#1002-商城-已发货
		When tom购买jobs的商品
			"""
			{
				"order_id":"1002",
				"pay_type":"货到付款",
				"products":[{
					"name":"bill商品2",
					"count":1
				},{
					"name":"jobs商品1",
					"count":1
				}]
			}
			"""
		Given jobs登录系统
		When jobs对订单进行发货
			"""
			{
				"order_no": "1002-bill商家",
				"logistics": "申通快递",
				"number": "1002001",
				"shipper": "jobs"
			}
			"""
		Given bill登录系统
		When bill创建结算单时设置结算信息
			"""
			{
				"account_shop":"jobs",
				"account_start_date":"2016.04.01 00:00:00",
				"account_end_date":"今天"
			}
			"""
		Then bill获得可选取结算订单列表
			"""
			[]
			"""

Scenario:2.没有使用微众卡支付的'已完成'的'本店'订单，可选取结算列表中不显示
	#0006-本店-优惠抵扣-优惠券
	#0007-本店-优惠抵扣-积分
	#0008-本店-微信支付
	#0009-本店-支付宝+积分
	#0010-本店-微信支付+优惠券

	Given bill登录系统
	When bill创建结算单时设置结算信息
		"""
		{
			"account_shop":"本店",
			"account_start_date":"2016.04.01 00:00:00",
			"account_end_date":"2016.05.01 00:00:00"
		}
		"""
	Then bill获得可选取结算订单列表
		"""
		[]
		"""

Scenario:3 没有经过'已完成'状态而变成'退款完成'或'已取消'的订单，该订单不显示在可选取的订单列表中
	#0011-本店-微信支付-待发货（发货/申请退款）->退款完成
	#0012-本店-微信支付-已发货（标记完成/修改物流/申请退款）->退款完成
	#0013-本店-优惠抵扣-待发货（发货/取消订单）->已取消
	#0014-本店-优惠抵扣-已发货（标记完成/修改物流/取消订单）->已取消
	#0015-本店-货到付款-待发货（发货/取消订单）->已取消
	#0016-本店-货到付款-已发货（标记完成/修改物流/取消订单）->已取消
	#0105-商城-微信支付-待发货（发货/申请退款）->退款完成

	Given bill登录系统
	And bill已创建微众卡
		"""
		{
			"cards": [{
				"id": "0000011",
				"password": "11",
				"status": "未使用",
				"price": 50.00
			},{
				"id": "0000012",
				"password": "12",
				"status": "未使用",
				"price": 50.00
			},{
				"id": "0000013",
				"password": "13",
				"status": "未使用",
				"price": 110.00
			},{
				"id": "0000014",
				"password": "14",
				"status": "未使用",
				"price": 100.00
			},{
				"id": "0000015",
				"password": "15",
				"status": "未使用",
				"price": 50.00
			},{
				"id": "0000016",
				"password": "16",
				"status": "未使用",
				"price": 50.00
			}]
		}
		"""
	#0011-本店-微信支付-'待发货->退款完成'
		When tom访问bill的webapp
		When tom购买bill的商品
			"""
			{
				"order_id":"0011",
				"pay_type":"微信支付",
				"products":[{
					"name":"bill商品1",
					"count":1
				}],
					"weizoom_card":[{
						"card_name":"0000011",
						"card_pass":"11"
					}]
			}
			"""
		When tom使用支付方式'微信支付'进行支付订单'0011'
		Given bill登录系统
		When bill'申请退款'订单'0011'于'2016-04-11 10:00:00'
		When bill通过财务审核'退款成功'订单'0011'于'2016-04-11 10:10:00'
	#0012-本店-微信支付-'已发货->退款完成'
		When tom访问bill的webapp
		When tom购买bill的商品
			"""
			{
				"order_id":"0012",
				"pay_type":"微信支付",
				"products":[{
					"name":"bill商品1",
					"count":1
				}],
					"weizoom_card":[{
						"card_name":"0000012",
						"card_pass":"12"
					}]
			}
			"""
		When tom使用支付方式'微信支付'进行支付订单'0012'
		Given bill登录系统
		When bill对订单进行发货
			"""
			{
				"order_no":"0012",
				"logistics":"off",
				"shipper": "",
				"delivery_time":"2016-04-12 10:00:00"
			}
			"""
		When bill'申请退款'订单'0012'于'2016-04-12 10:00:00'
		When bill通过财务审核'退款成功'订单'0012'于'2016-04-12 10:10:00'
	#0013-本店-优惠抵扣（微众卡全额）-'待发货->已取消'
		When tom访问bill的webapp
		When tom购买bill的商品
			"""
			{
				"order_id":"0013",
				"pay_type":"微信支付",
				"products":[{
					"name":"bill商品1",
					"count":1
				}],
					"weizoom_card":[{
						"card_name":"0000013",
						"card_pass":"13"
					}]
			}
			"""
		Given bill登录系统
		When bill'取消'订单'0013'于'2016-04-13 10:00:00'
	#0014-本店-优惠抵扣（微众卡+优惠券）-'已发货->已取消'
		When tom访问bill的webapp
		When tom购买bill的商品
			"""
			{
				"order_id":"0014",
				"pay_type":"微信支付",
				"products":[{
					"name":"bill商品1",
					"count":1
				}],
					"weizoom_card":[{
						"card_name":"0000014",
						"card_pass":"14"
					}],
				"coupon": "coupon1_id_3"
			}
			"""
		Given bill登录系统
		When bill对订单进行发货
			"""
			{
				"order_no": "0014",
				"logistics": "申通快递",
				"number": "0004",
				"shipper": "jobs",
				"delivery_time":"2016-04-14 10:00:00"
			}
			"""
		When bill'取消'订单'0014'于'2016-04-14 10:10:00'
	#0015-本店-货到付款-'待发货->已取消'
		When tom访问bill的webapp
		When tom购买bill的商品
			"""
			{
				"order_id":"0015",
				"pay_type":"货到付款",
				"products":[{
					"name":"bill商品1",
					"count":1
				}],
					"weizoom_card":[{
						"card_name":"0000015",
						"card_pass":"15"
					}]
			}
			"""
		Given bill登录系统
		When bill'取消'订单'0015'于'2016-04-15 10:00:00'
	#0016-本店-货到付款-'已发货->已取消'
		When tom访问bill的webapp
		When tom购买bill的商品
			"""
			{
				"order_id":"0016",
				"pay_type":"货到付款",
				"products":[{
					"name":"bill商品1",
					"count":1
				}],
					"weizoom_card":[{
						"card_name":"0000016",
						"card_pass":"16"
					}]
			}
			"""
		Given bill登录系统
		When bill对订单进行发货
			"""
			{
				"order_no": "0016",
				"logistics": "申通快递",
				"number": "0006",
				"shipper": "jobs",
				"delivery_time":"2016-04-16 10:00:00"
			}
			"""
		When bill'取消'订单'0016'于'2016-04-16 10:10:00'
	#0105-商城-微信支付-待发货（发货/申请退款）->退款完成
		When lily访问jobs的webapp
		When lily购买jobs的商品
			"""
			{
				"order_id":"0105",
				"pay_type":"微信支付",
				"products":[{
					"name":"bill商品1",
					"count":1
				},{
					"name":"jobs商品1",
					"count":1
				}],
					"weizoom_card":[{
						"card_name":"0000105",
						"card_pass":"0105"
					}]
			}
			"""
		When lily使用支付方式'微信支付'进行支付订单'0105'
		Given jobs登录系统
		When jobs'申请退款'订单'0011'于'2016-04-15 10:00:00'
		When jobs通过财务审核'退款成功'订单'0105'于'2016-04-15 10:10:00'

	#结算对象选择'本店'，校验可选取的结算订单列表
		Given bill登录系统
		When bill创建结算单时设置结算信息
			"""
			{
				"account_shop":"本店",
				"account_start_date":"2016.04.01 00:00:00",
				"account_end_date":"2016.05.01 00:00:00"
			}
			"""
		Then bill获得可选取结算订单列表
		"""
		[]
		"""
	#结算对象选择'jobs'，校验可选取的结算订单列表
		Given bill登录系统
		When bill创建结算单时设置结算信息
			"""
			{
				"account_shop":"jobs",
				"account_start_date":"2016.04.01 00:00:00",
				"account_end_date":"2016.05.01 00:00:00"
			}
			"""
		Then bill获得可选取结算订单列表
			"""
			[]
			"""

Scenario:4 订单在已完成状态时没有提交结算单,在退款完成或取消订单后提交结算单,该订单不显示在可选取的订单列表中
	#0101-本店-已完成-优惠抵扣-微众卡（bill商品1,1-110）
	#0102-本店-已完成-优惠抵扣-微众卡+积分（bill商品2,2-150+250）
	#0103-本店-已完成-优惠抵扣-微众卡+优惠券（bill商品1,1-60+50）
	#0104-本店-已完成-微信支付-微众卡+现金（bill商品1,1-50+60）
	#取消订单'0101',退款完成订单'0104'

	Given bill登录系统
	When bill'取消'订单'0101'于'2016-05-21 10:00:00'
	When bill'申请退款'订单'0104'于'2016-05-24 10:00:00'
	When bill通过财务审核'退款成功'订单'0104'于'2016-05-24 10:10:00'
	When bill创建结算单时设置结算信息
		"""
		{
			"account_shop":"本店",
			"account_start_date":"2016.05.01 00:00:00",
			"account_end_date":"2016.06.01 00:00:00"
		}
		"""
	Then bill获得可选取结算订单列表
		|order_id |price       |count   |finish_time          |order_account |status|actions |
		|0103     |100.00      |1       |2016.05.13 00:00:00  |60.00         |已完成|查看详情|
		|0102     |200.00      |2       |2016.05.12 00:00:00  |150.00        |已完成|查看详情|

Scenario:5.根据结算日期的筛选显示符合条件的订单
	0101-本店-已完成-优惠抵扣-微众卡（bill商品1,1-110）
	0102-本店-已完成-优惠抵扣-微众卡+积分（bill商品2,2-150+250）
	0103-本店-已完成-优惠抵扣-微众卡+优惠券（bill商品1,1-60+50）
	0104-本店-已完成-微信支付-微众卡+现金（bill商品1,1-50+60）


	1101-商城-已完成-微信支付-bill商品1，2
	1102-商城-已完成-优惠抵扣-bill商品1，jobs商品1
	1103-商城-已完成-货到付款-bill商品1，bill商品2，jobs商品1

	#结算对象'本店'，根据结算日期显示符合条件的结算订单
		Given bill登录系统
		When bill创建结算单时设置结算信息
			"""
			{
				"account_shop":"本店",
				"account_start_date":"2016.05.01 00:00:00",
				"account_end_date":"2016.06.01 00:00:00"
			}
			"""
		Then bill获得可选取结算订单列表
			|order_id |price       |count   |finish_time          |order_account |status|actions |
			|0104     |100.00      |1       |2016.05.14 00:00:00  |50.00         |已完成|查看详情|
			|0103     |100.00      |1       |2016.05.13 00:00:00  |60.00         |已完成|查看详情|
			|0102     |200.00      |2       |2016.05.12 00:00:00  |150.00        |已完成|查看详情|
			|0101     |100.00      |1       |2016.05.11 00:00:00  |110.00        |已完成|查看详情|

	#结算对象为'本店'，已完成的订单创建结算单后，订单进行退款完成或取消后，该订单出现在可选取的结算订单中
		Given bill登录系统
		When bill创建结算单
			"""
			{
				"account_id":"001",
				"account_shop":"本店",
				"account_start_date":"2016-05-01 00:00:00",
				"account_end_date":"2016-06-01 10:00:00",
				"order_info":
					[{
						"order_id":"0104",
						"finish_time":"2016-05-12 00:00:00",
						"order_account":50.00,
						"status":"已完成",
						"actions":["查看详情"]
					},{
						"order_id":"0101",
						"finish_time":"2016-05-11 00:00:00",
						"order_account":110.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
					"un_account":370.00,
					"shops_account":-160.00,
					"remain_un_account":210.00
			}
			"""
		#提交结算单001后，已完成的订单进行退款完成或取消订单
			When bill'取消'订单'0101'于'2016-05-15 10:00:00'
			When bill'申请退款'订单'0104'于'2016-05-15 10:00:00'
			When bill通过财务审核'退款成功'订单'0104'于'2016-05-15 10:10:00'
		#本店-结算单001-经过财务审核后'结算完成''
			Given admin登录财务系统
			When admin'核算确认'结算单'001'
			When admin'确认收票'结算单'001'
			When admin对结算单进行打款
				"""
				{
					"account_id":"001",
					"input_account":160.00
				}
				"""
			Given bill登录系统
			When bill'确认收款'结算单'001'
		#本店-结算单001结算完成后，再提交结算单时，退款完成或已取消的订单显示在可选取的结算订单列表中
			When bill创建结算单时设置结算信息
				"""
				{
					"account_shop":"本店",
					"account_start_date":"2016.05.01 00:00:00",
					"account_end_date":"2016.06.01 00:00:00"
				}
				"""
			Then bill获得可选取结算订单列表
				|order_id |price       |count   |finish_time          |order_account  |status   |actions |
				|0104     |100.00      |1       |2016.05.15 10:10:00  |-50.00         |退款完成 |查看详情|
				|0101     |100.00      |1       |2016.05.15 10:00:00  |-110.00        |已取消   |查看详情|
				|0103     |100.00      |1       |2016.05.13 00:00:00  |60.00          |已完成   |查看详情|
				|0102     |200.00      |2       |2016.05.12 00:00:00  |150.00         |已完成   |查看详情|



	#lily从自营平台jobs购买bill的商品
		When lily访问jobs的webapp
		When lily购买jobs的商品
			"""
			{
				"order_id":"1101",
				"pay_type":"微信支付",
				"products":[{
					"name":"bill商品1",
					"count":2
				}]
			}
			"""
		When lily使用支付方式'微信支付'进行支付订单'1101'
		When lily购买jobs的商品
			"""
			{
				"order_id":"1102",
				"pay_type":"货到付款",
				"products":[{
					"name":"bill商品1",
					"count":1
				},{
					"name":"bill商品2",
					"count":1
				},{
					"name":"jobs商品1",
					"count":1
				}]
			}
			"""
		When lily购买jobs的商品
			"""
			{
				"order_id":"1103",
				"pay_type":"支付宝",
				"products":[{
					"name":"bill商品1",
					"count":1
				},{
					"name":"jobs商品1",
					"count":1
				}],
					"weizoom_card":[{
						"card_name":"10000001",
						"card_pass":"123456"
					}]
			}
			"""
		Given jobs登录系统
		When jobs对订单进行发货
			"""
			{
				"order_no": "1101-bill商家",
				"logistics": "申通快递",
				"number": "1101001,
				"shipper": "jobs"
			}
			"""
		When jobs对订单进行发货
			"""
			{
				"order_no": "1102-bill商家",
				"logistics": "申通快递",
				"number": "1102001,
				"shipper": "jobs"
			}
			"""
		When jobs对订单进行发货
			"""
			{
				"order_no": "1103-bill商家",
				"logistics": "申通快递",
				"number": "1103001,
				"shipper": "jobs"
			}
			"""
		When jobs'完成'订单'1101-bill商家'于'2016-04-21 11:00:00'
		When jobs'完成'订单'1102-bill商家'于'2016-04-22 12:00:00'
		When jobs'完成'订单'1103-bill商家'于'2016-04-23 13:00:00'

	#结算对象为自营平台jobs，根据结算日期显示符合条件的结算订单
		Given bill登录系统
		When bill创建结算单时设置结算信息
			"""
			{
				"account_shop":"jobs",
				"account_start_date":"2016.04.01 00:00:00",
				"account_end_date":"2016.05.01 00:00:00"
			}
			"""
		Then bill获得可选取结算订单列表
			|order_id |price        |count   |finish_time          |order_account |status|actions |
			|1103     |99.00,199.00 |1,1     |2016.04.23 13:00:00  |298.00        |已完成|查看详情|
			|1102     |99.00        |1       |2016.04.22 12:00:00  |99.00         |已完成|查看详情|
			|1101     |99.00        |2       |2016.04.21 11:00:00  |198.00        |已完成|查看详情|

	#结算对象为自营'jobs'，已完成的订单创建结算单后，订单进行退款完成或取消后，该订单出现在可选取的结算订单中
		Given bill登录系统
		When bill创建结算单
			"""
			{
				"account_id":"002",
				"account_shop":"jobs",
				"account_start_date":"2016-04-01 00:00:00",
				"account_end_date":"2016-04-23 00:00:00",
				"order_info":
					[{
						"order_id":"1102",
						"finish_time":"2016-04-22 12:00:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					},{
						"order_id":"1101",
						"finish_time":"2016-04-21 11:00:00",
						"order_account":198.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
					"un_account":595.00,
					"shops_account":-297.00,
					"remain_un_account":298.00
			}
			"""
		#创建结算单002后，jobs取消订单1102，退款完成订单1101
			Given jobs登录系统
			When jobs'申请退款'订单'1101'于'2016-04-23 12:10:00'
			When jobs通过财务审核'退款成功'订单'1101'于'2016-04-23 12:20:00'
			When jobs'取消'订单'1102'于'2016-04-23 12:30:00'
		#自营平台jobs-结算单002-经过财务审核后'结算完成''
			Given admin登录财务系统
			When admin'核算确认'结算单'002'
			When admin'确认收票'结算单'002'
			When admin对结算单进行打款
				"""
				{
					"account_id":"002",
					"input_account":297.00
				}
				"""
			Given bill登录系统
			When bill'确认收款'结算单'002'
		#自营平台jobs-结算单002结算完成后，再提交结算单时，退款完成或已取消的订单显示在可选取的结算订单列表中
			When bill创建结算单时设置结算信息
				"""
				{
					"account_shop":"jobs",
					"account_start_date":"2016.04.23 00:00:00",
					"account_end_date":"2016.04.30 00:00:00"
				}
				"""
			Then bill获得可选取结算订单列表
				|order_id |price        |count   |finish_time          |order_account  |status  |actions |
				|1101     |99.00        |2       |2016.04.23 12:20:00  |-198.00        |退款完成|查看详情|
				|1102     |99.00        |1       |2016.04.23 12:30:00  |-99.00         |已取消  |查看详情|
				|1103     |99.00,199.00 |1,1     |2016.04.23 13:00:00  |298.00         |已完成  |查看详情|
