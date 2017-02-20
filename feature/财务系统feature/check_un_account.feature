#_author_:张三香 2016.05.06

Feature:创建结算单时，未结算金额的校验
	"""
		1、不选择结算对象，未结算金额为0.00
		2、选择结算对象，未结算金额为当前日期以前该结算对象所有未结算的金额总和
		3、结算单创建后，取消结算，未结算金额为当前日期以前该结算对象所有未结算的金额总和
		4、有结算单已结算完成，再次创建结算单时，未结算金额为当前日期以前该结算对象所有未结算的金额总和
	"""

Background:
	#bill为普通商家、jobs为自营平台、admin为财务系统管理者

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

Scenario:1 不选择结算对象，未结算金额的校验
	#bill创建结算单，不选择结算对象，'未结算金额'显示0.00

	Given bill登录系统
	When bill创建结算单时设置结算信息
		"""
		{
			"account_shop":"",
			"account_start_date":"",
			"account_end_date":""
		}
		"""
	Then bill获得'未结算金额'信息
		"""
		{
			"un_account":0.00
		}
		"""

Scenario:2 选择结算对象，未结算金额的校验
	#bill创建结算单，选择结算对象jobs/本店，未结算金额=当前日以前未结算的所有订单（已完成、退款完成、已取消）

	Given bill登录系统
	#结算对象-自营平台jobs
	When bill创建结算单时设置结算信息
		"""
		{
			"account_shop":"jobs",
			"account_start_date":"",
			"account_end_date":""
		}
		"""
	Then bill获得'未结算金额'信息
		"""
		{
			"un_account":198.00
		}
		"""
	#结算对象-本店
	When bill创建结算单时设置结算信息
		"""
		{
			"account_shop":"本店",
			"account_start_date":"",
			"account_end_date":""
		}
		"""
	Then bill获得'未结算金额'信息
		"""
		{
			"un_account":560.00
		}
		"""

Scenario:3 选择结算对象，创建结算单后取消结算，再次创建结算单时未结算金额的校验
	Given bill登录系统
	#结算对象-本店，结算单中只勾选了订单0001、0002
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
	When bill'取消结算'结算单'001'
	When bill创建结算单时设置结算信息
		"""
		{
			"account_shop":"本店",
			"account_start_date":"",
			"account_end_date":""
		}
		"""
	Then bill获得'未结算金额'信息
		"""
		{
			"un_account":560.00
		}
		"""

Scenario:4 选择结算对象，创建结算单使其结算完成，再次创建结算单时未结算金额的校验
	Given bill登录系统
	#结算对象-本店，结算单中只勾选了0001、0002
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
	#本店-结算单001结算完成后，再创建结算单时结算金额的校验
	When bill创建结算单时设置结算信息
		"""
		{
			"account_shop":"本店",
			"account_start_date":"",
			"account_end_date":""
		}
		"""
	Then bill获得'未结算金额'信息
		"""
		{
			"un_account":200.00
		}
		"""