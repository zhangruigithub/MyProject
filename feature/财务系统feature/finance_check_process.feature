#_author_:张三香 2016.05.05

Fearure:财务结算流程
	"""
		1、商家结算管理列表
			a.不同结算状态对应的操作
				|  结算状态  |      操作          |
				|商家提交结算|【取消结算】【查看】|
				|微众核算完成|【取消结算】【查看】|
				|微众已收票  |【查看】            |
				|微众已打款  |【确认收款】【查看】|
				|余款未结    |【查看】            |
				|结算完成    |【查看】            |
				|核算失败    |【重新提交】        |
			b.商家对某结算单进行【取消结算】后，该结算单会在商家的结算管理列表和财务系统的结算管理列表中消失
			c.列表字段
				序号、结算对象、结算时间、本期订单数、实际结算/结算金额、结算状态、操作



		2、财务系统-结算管理列表
			a.不同结算状态对应的操作
				|  结算状态  |      操作                  |
				|商家提交结算|【核算确认】【驳回】【查看】|
				|微众核算完成|【确认收票】【查看】        |
				|微众已收票  |【输入结算金额】【查看】    |
				|微众已打款  |【查看】                    |支付清
				|微众已打款  |【输入结算金额】【查看】    |未支付清
				|余款未结    |【输入结算金额】【查看】    |
				|结算完成    |【查看】                    |
			b.列表字段
				序号、结算对象、结算时间、本期订单数、供货商、实际结算/结算金额、结算状态、操作
	"""

Background:
	#bill为普通商家
	#jobs、nokia为自营平台
	#admin为财务系统管理者
	#bill为普通商家；jobs为自营平台；admin为财务系统管理者

	#普通商家bill的信息
		Given 添加bill店铺名称为'bill商家'
		Given bill登录系统
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
					"id": "0000001",
					"password": "123456",
					"status": "未使用",
					"price": 50.00
				},{
					"id": "0000002",
					"password": "223456",
					"status": "未使用",
					"price": 310.00
				},{
					"id": "0000003",
					"password": "323456",
					"status": "未使用",
					"price": 200.00
				},{
					"id": "0000004",
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
				"be_member_increase_count": 200
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
					"id": "1000001",
					"password": "11",
					"status": "未使用",
					"price": 110.00
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
	When tom关注jobs的公众号
	#购买bill的商品
		When tom访问bill的webap
		#0001-微信支付（bill商品1,1-微众卡50+现金60）
			When tom购买bill的商品
				"""
				{
					"order_id":"0001",
					"pay_type":"微信支付",
					"products":[{
						"name":"bill商品1",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"0000001",
							"card_pass":"123456"
						}]
				}
				"""
			When tom使用支付方式'微信支付'进行支付订单'0001'
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0001",
					"logistics":"off",
					"shipper": ""
				}
				"""
			When bill'完成'订单'0001'于'2016-04-01 10:01:00'
		#0002-优惠抵扣（bill商品1,1+bill商品2,1-微众卡310）
			When tom购买bill的商品
				"""
				{
					"order_id":"0002",
					"pay_type":"微信支付",
					"products":[{
						"name":"bill商品1",
						"count":1
					},{
						"name":"bill商品2",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"0000002",
							"card_pass":"223456"
						}]
				}
				"""
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0002",
					"logistics":"off",
					"shipper": ""
				}
				"""
			When bill'完成'订单'0002'于'2016-04-02 10:02:00'
		#0003-微信支付（bill商品2,2-微众卡200+积分200）
			When tom购买bill的商品
				"""
				{
					"order_id":"0003",
					"pay_type":"微信支付",
					"products":[{
						"name":"bill商品2",
						"count":2
					}],
						"weizoom_card":[{
							"card_name":"0000003",
							"card_pass":"323456"
						}],
					"integral":200,
					"integral_money":200.00
				}
				"""
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0003",
					"logistics":"off",
					"shipper": ""
				}
				"""
			When bill'完成'订单'0003'于'2016-04-03 10:03:00'
	#购买jobs的商品
		When tom访问jobs的webap
		#1001-货到付款（bill商品1,1-现金100）
			When tom购买jobs的商品
				"""
				{
					"order_id":"1001",
					"pay_type":"货到付款",
					"products":[{
						"name":"bill商品1",
						"count":1
					}]
				}
				"""
			Given jobs登录系统
			When jobs对订单进行发货
				"""
				{
					"order_no":"1001",
					"logistics":"off",
					"shipper": ""
				}
				"""
			When jobs'完成'订单'1001'于'2016-04-11 10:01:00'
		#1002-优惠抵扣（bill商品1,1+jobs商品1,1-微众卡110）
			When tom购买jobs的商品
				"""
				{
					"order_id":"1002",
					"pay_type":"微信支付",
					"products":[{
						"name":"bill商品1",
						"count":1
					},{
						"name":"jobs商品1",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"1000001",
							"card_pass":"11"
						}]

				}
				"""
			Given jobs登录系统
			When jobs对订单进行发货
				"""
				{
					"order_no":"1002-bill商家",
					"logistics":"off",
					"shipper": ""
				}
				"""
			When jobs'完成'订单'1002-bill商家'于'2016-04-12 10:01:00'

	#bill提交'本店-结算单001'和'jobs-结算单002'
		Given bill登录系统
		When bill创建结算单
			"""
			{
				"account_id":"001",
				"account_shop":"本店",
				"account_start_date":"2016-04-01 00:00:00",
				"account_end_date":"2016-04-10 00:00:00",
				"order_info":
					[{
						"order_id":"0002",
						"price":["100.00","200.00"],
						"count":["1","1"],
						"finish_time":"2016-04-02 10:02:00",
						"order_account":310.00,
						"status":"已完成",
						"actions":["查看详情"]
					},{
						"order_id":"0001",
						"price":["100.00"],
						"count":["1"],
						"finish_time":"2016-04-01 10:01:00",
						"order_account":50.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
					"un_account":560.00,
					"shops_account":-360.00,
					"remain_un_account":200.00
			}
			"""
		When bill创建结算单
			"""
			{
				"account_id":"002",
				"account_shop":"jobs",
				"account_start_date":"2016-04-11 00:00:00",
				"account_end_date":"2016-04-15 00:00:00",
				"order_info":
					[{
						"order_id":"1002",
						"price":["99.00"],
						"count":["1"],
						"finish_time":"2016-04-12 10:02:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					},{
						"order_id":"1001",
						"price":["99.00"],
						"count":["1"],
						"finish_time":"2016-04-11 10:01:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
					"un_account":198.00,
					"shops_account":-198.00,
					"remain_un_account":0.00
			}
			"""
		Given bill登录系统
		Then bill能获得结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":198.00,
				"status":"商家提交结算",
				"aciton":["取消结算","查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["取消结算","查看"]
			}]
			"""
		Given admin登录财务系统
		Then admin能获得财务结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":198.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			}]
			"""

Scenario:1 商家提交结算后，进行【取消结算】操作
	a.结算状态为【商家提交结算】时，商家进行【取消结算】
	b.结算状态为【微众核算完成】时，商家进行【取消结算】

	#001-本店-结算状态为【商家提交结算】时，商家进行【取消结算】
		Given bill登录系统
		When bill'取消结算'结算单'001'
		Then bill能获得结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":198.00,
				"status":"商家提交结算",
				"aciton":["取消结算","查看"]
			}]
			"""

		Given admin登录财务系统
		Then admin能获得财务结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":198.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			}]
			"""

	#02-自营平台jobs-结算状态为【微众核算完成】时，商家进行【取消结算】
		When admin'核算确认'结算单'002'
		Then admin能获得结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":198.00,
				"status":"微众核算完成",
				"aciton":["确认收票","查看"]
			}]
			"""
		Given bill登录系统
		Then bill能获得结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":198.00,
				"status":"微众核算完成",
				"aciton":["取消结算","查看"]
			}]
			"""
		When bill'取消结算'结算单'002'
		Then bill能获得结算单列表
			"""
			[]
			"""
		Given admin登录财务系统
		Then admin能获得财务结算单列表
			"""
			[]
			"""

Scenario:2 商家提交结算后，被财务驳回
	1、商家bill提交'结算单1',其结算单列表存在'结算单1'
	2、财务admin登录财务系统，其结算单列表存在'结算单1'
	3、财务对'结算单1'进行'驳回'操作，结算单列表中不显示'结算单1'
	4、商家bill登录系统，其结算单列表显示'结算单1'，且结算单状态为'核算失败'


	Given admin登录财务系统
	When admin'驳回'结算单'001'
	Then admin能获得财务结算单列表
		"""
		[{
			"id":"1",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"supplier":"bill商家",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["核算确认","驳回",查看"]
		}]
		"""
	Given bill登录系统
	Then bill能获得结算单列表
		"""
		[{
			"id":"1",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["取消结算","查看"]
		},{
			"id":"2",
			"account_id":"001",
			"account_shop":"本店",
			"start_date":"2016-04-01 00:00:00",
			"end_date":"2016-04-10 00:00:00",
			"order_num":"2",
			"real_account":0.00,
			"total_account":360.00,
			"status":"核算失败",
			"aciton":["重新提交"]
		}]
		"""

Scenario:3 财务对商家提交的结算单进行全额打款，使结算完成
	商家提交结算-微众核算完成-微众已收票-微众已打款-结算完成
	1、商家bill提交结算单1，结算单金额为360.00
	2、财务admin进行'核算确认'
	3、商家bill寄票给财务
	4、财务admin收到票后进行'确认收票'
	5、财务admin'输入结算金额：360.00'
	6、商家bill进行'确认收款'，使'结算单1'结算完成


	Given admin登录财务系统
	When admin'核算确认'结算单'001'
	When admin'确认收票'结算单'001'
	#财务-微众已收票
	Then admin能获得财务结算单列表
		"""
		[{
			"id":"1",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"supplier":"bill商家",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["核算确认","驳回",查看"]
		},{
			"id":"2",
			"account_id":"001",
			"account_shop":"本店",
			"start_date":"2016-04-01 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"supplier":"bill商家",
			"real_account":0.00,
			"total_account":360.00,
			"status":"微众已收票",
			"aciton":["输入结算金额","查看"]
		}]
		"""
	#商家-微众已收票
	Given bill登录系统
	Then bill能获得结算单列表
		"""
		[{
			"id":"1",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["取消结算","查看"]
		},{
			"id":"2",
			"account_id":"001",
			"account_shop":"本店",
			"start_date":"2016-04-01 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"real_account":0.00,
			"total_account":360.00,
			"status":"微众已收票",
			"aciton":["查看"]
		}]
		"""
	#财务-微众已打款（支付清）
	Given admin登录财务系统
	When admin对结算单进行打款
		"""
		{
			"account_id":"001",
			"input_account":360.00
		}
		"""
	Then admin能获得财务结算单列表
		"""
		[{
			"id":"1",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"supplier":"bill商家",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["核算确认","驳回",查看"]
		},{
			"id":"2",
			"account_id":"001",
			"account_shop":"本店",
			"start_date":"2016-04-01 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"supplier":"bill商家",
			"real_account":360.00,
			"total_account":360.00,
			"status":"微众已打款",
			"aciton":["查看"]
		}]
		"""
	#商家-微众已打款（支付清）
	Given bill登录系统
	Then bill能获得结算单列表
		"""
		[{
			"id":"1",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["取消结算","查看"]
		},{
			"id":"2",
			"account_id":"001",
			"account_shop":"本店",
			"start_date":"2016-04-01 00:00:00",
			"end_date":"2016-04-10 00:00:00",
			"order_num":"2",
			"real_account":360.00,
			"total_account":360.00,
			"status":"微众已打款",
			"aciton":["确认收款",查看"]
		}]
		"""
	When bill'确认收款'结算单'001'
	#商家-结算完成
	Then bill能获得结算单列表
		"""
		[{
			"id":"1",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["取消结算","查看"]
		},{
			"id":"2",
			"account_id":"001",
			"account_shop":"本店",
			"start_date":"2016-04-01 00:00:00",
			"end_date":"2016-04-10 00:00:00",
			"order_num":"2",
			"real_account":360.00,
			"total_account":360.00,
			"status":"结算完成",
			"aciton":["查看"]
		}]
		"""
	#财务-结算完成
	Given admin登录财务系统
	Then admin能获得财务结算单列表
		"""
		[{
			"id":"1",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"supplier":"bill商家",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["核算确认","驳回",查看"]
		},{
			"id":"2",
			"account_id":"001",
			"account_shop":"本店",
			"start_date":"2016-04-01 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"supplier":"bill商家",
			"real_account":360.00,
			"total_account":360.00,
			"status":"结算完成",
			"aciton":["查看"]
		}]
		"""

Scenario:4 财务对商家提交的结算单进行非全额打款，使结算完成
	商家提交结算-微众核算完成-微众已收票-微众已打款（非全额）-余款未结-微众已打款-结算完成
	1、商家bill提交结算单2，结算单金额为198.00
	2、财务admin进行'核算确认'
	3、商家bill寄票给财务
	4、财务admin收到票后进行'确认收票'
	5、财务admin'输入结算金额：100.00'
	6、商家bill进行'确认收款'，结算单2状态为'余款未结'
	7、财务admin'输入结算金额：98.00'
	8、商家bill进行'确认收款'，结算单2状态为'结算完成'

	Given admin登录财务系统
	When admin'核算确认'结算单'002'
	#财务-核算完成-查看结算单详情
		And admin获得财务结算单'002'的详情
			"""
			{
				"account_id":"002",
				"account_shop":"jobs",
				"un_account":198.00,
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"order_info":
					[{
						"order_id":"1002",
						"price":["99.00"],
						"count":["1"],
						"finish_time":"2016-04-12 10:02:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					},{
						"order_id":"1001",
						"price":["99.00"],
						"count":["1"],
						"finish_time":"2016-04-11 10:01:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
				"account_info":
					[{
						"un_account":198.00,
						"shops_account":-198.00,
						"remain_un_account":0.00
					}]
			}
			"""
	When admin'确认收票'结算单'002'
	#财务-微众已打款（未支付清）
		Given admin登录财务系统
		When admin对结算单进行打款
			"""
			{
				"account_id":"002",
				"input_account":100.00
			}
			"""
		Then admin能获得财务结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":100.00,
				"total_account":198.00,
				"status":"微众已打款",
				"aciton":["输入结算金额","查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			}]
			"""
	#商家-微众已打款（未支付清）
		Given bill登录系统
		Then bill能获得结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"real_account":100.00,
				"total_account":198.00,
				"status":"微众已打款",
				"aciton":["确认收款",查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["取消结算","查看"]
			}]
			"""
	#商家-余款未结
		When bill'确认收款'结算单'002'
		Then bill能获得结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"real_account":100.00,
				"total_account":198.00,
				"status":"余款未结",
				"aciton":["查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["取消结算","查看"]
			}]
			"""
	#财务-余款未结
		Given admin登录财务系统
		Then admin能获得财务结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":100.00,
				"total_account":198.00,
				"status":"余款未结",
				"aciton":["输入结算金额","查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			}]
			"""
	#财务-余款未结-查看结算单详情
		And admin获得财务结算单'002'的详情
				"""
				{
					"account_id":"002",
					"account_shop":"jobs",
					"un_account":198.00,
					"start_date":"2016-04-11 00:00:00",
					"end_date":"2016-04-15 00:00:00",
					"order_num":"2",
					"supplier":"bill商家",
					"order_info":
						[{
							"order_id":"1002",
							"price":["99.00"],
							"count":["1"],
							"finish_time":"2016-04-12 10:02:00",
							"order_account":99.00,
							"status":"已完成",
							"actions":["查看详情"]
						},{
							"order_id":"1001",
							"price":["99.00"],
							"count":["1"],
							"finish_time":"2016-04-11 10:01:00",
							"order_account":99.00,
							"status":"已完成",
							"actions":["查看详情"]
						}],
					"account_info":
						[{
							"shops_account":198.00,
							"shops_real_account":-100.00,
							"shops_un_account":98.00
						}]
				}
				"""
	#财务-再次打款
		When admin对结算单进行打款
			"""
			{
				"account_id":"002",
				"input_account":98.00
			}
			"""
		Then admin能获得财务结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":198.00,
				"total_account":198.00,
				"status":"微众已打款",
				"aciton":["查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			}]
			"""

		Given bill登录系统
		Then bill能获得结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"real_account":198.00,
				"total_account":198.00,
				"status":"微众已打款",
				"aciton":["确认收款","查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["取消结算","查看"]
			}]
			"""
	#商家-结算完成
		When bill'确认收款'结算单'002'
		Then bill能获得结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"real_account":198.00,
				"total_account":198.00,
				"status":"结算完成",
				"aciton":["查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["取消结算","查看"]
			}]
			"""
	#财务-结算完成
		Given admin登录财务系统
		Then admin能获得财务结算单列表
			"""
			[{
				"id":"1",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":198.00,
				"total_account":198.00,
				"status":"结算完成",
				"aciton":["查看"]
			},{
				"id":"2",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":360.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			}]
			"""
	#财务-结算完成-查看结算单详情
		And admin获得财务结算单'002'的详情
			"""
			{
				"account_id":"002",
				"account_shop":"jobs",
				"un_account":198.00,
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"order_info":
					[{
						"order_id":"1002",
						"price":["99.00"],
						"count":["1"],
						"finish_time":"2016-04-12 10:02:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					},{
						"order_id":"1001",
						"price":["99.00"],
						"count":["1"],
						"finish_time":"2016-04-11 10:01:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
				"account_info":
					[{
						"shops_account":198.00,
						"shops_real_account":-100.00,
						"shops_un_account":98.00
					},{
						"shops_real_account":-98.00,
						"shops_un_account":0.00
					}]
			}
			"""

#待修改，不确定提是怎么处理的
Scenario:5 同一结算对象，不允许提交多个未结算完成的结算单
	商家bill提交本店结算单1-未结算完成
	商家bill提交自营平台jobs结算单2-未结算完成
	商家bill提交本店结算单3-不允许提交
	商家bill使本店结算1结算完成
	商家bill再提交本店结算单3-允许提交

	Given bill登录系统
	When bill创建结算单
		"""
		{
			"account_id":"003",
			"account_shop":"本店",
			"account_start_date":"2016-04-10 00:00:00",
			"account_end_date":"2016-04-15 00:00:00",
			"order_info":
				[{
					"order_id":"003",
					"price":["200.00"],
					"count":["2"],
					"finish_time":"2016-04-03 10:03:00",
					"order_account":200.00,
					"status":"已完成",
					"actions":["查看详情"]
				}],
					"un_account":200.00,
					"this_account":-200.00,
					"remain_account":0.00
		}
		"""
	Then bill获得错误提示'xxxxxx'
	Given admin登录财务系统
	When admin'核算确认'结算单'001'
	When admin'确认收票'结算单'001'
	When admin对结算单进行打款
		"""
		{
			"account_id":"001",
			"input_account":360.00
		}
		"""
	Given bill登录系统
	When bill'确认收款'结算单'001'
	When bill创建结算单
		"""
		{
			"account_id":"003",
			"account_shop":"本店",
			"account_start_date":"2016-04-10 00:00:00",
			"account_end_date":"2016-04-15 00:00:00",
			"order_info":
				[{
					"order_id":"003",
					"price":["200.00"],
					"count":["2"],
					"finish_time":"2016-04-03 10:03:00",
					"order_account":200.00,
					"status":"已完成",
					"actions":["查看详情"]
				}],
					"un_account":200.00,
					"this_account":-200.00,
					"remain_account":0.00
		}
		"""
	Then bill能获得结算单列表
		"""
		[{
			"id":"1",
			"account_id":"003",
			"account_shop":"本店",
			"start_date":"2016-04-10 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"1",
			"real_account":0.00,
			"total_account":200.00,
			"status":"商家提交结算",
			"aciton":["取消结算","查看"]
		},{
			"id":"2",
			"account_id":"002",
			"account_shop":"jobs",
			"start_date":"2016-04-11 00:00:00",
			"end_date":"2016-04-15 00:00:00",
			"order_num":"2",
			"real_account":0.00,
			"total_account":198.00,
			"status":"商家提交结算",
			"aciton":["取消结算","查看"]
		},{
			"id":"3",
			"account_id":"001",
			"account_shop":"本店",
			"start_date":"2016-04-01 00:00:00",
			"end_date":"2016-04-10 00:00:00",
			"order_num":"2",
			"real_account":360.00,
			"total_account":360.00,
			"status":"结算完成",
			"aciton":["查看"]
		}]
		"""


