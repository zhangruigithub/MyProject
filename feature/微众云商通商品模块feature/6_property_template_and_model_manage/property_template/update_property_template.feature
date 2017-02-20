#editor:张三香 2016.08.15
Feature: 更新属性模板
	"""
		1、更新属性模板名称
		2、在属性模板中修改属性信息（属性、描述）、添加属性信息、删除属性信息
		3、删除属性信息时，对正在使用该属性的商品没有任何影响
	"""

Background:
	Given jobs登录系统
	When jobs添加属性模板
		"""
		{
			"name": "计算机模板",
			"properties": [{
				"name": "CPU",
				"description": "CPU描述"
			}, {
				"name": "内存",
				"description": "内存描述"
			}]
		}
		"""
	When jobs添加属性模板
		"""
		{
			"name": "大米模板",
			"properties": [{
				"name": "产地",
				"description": "产地描述"
			}]
		}
		"""
	Given bill登录系统
	When bill添加属性模板
		"""
		{
			"name": "计算机模板",
			"properties": [{
				"name": "CPU",
				"description": "CPU描述"
			}, {
				"name": "内存",
				"description": "内存描述"
			}]
		}
		"""
	When bill添加属性模板
		"""
		{
			"name": "大米模板",
			"properties": [{
				"name": "产地",
				"description": "产地描述"
			}]
		}
		"""

@product @property
Scenario:1 更新属性模板
	jobs更新属性模板的名称和属性后
	1.job的属性模板更新
	2.bill的属性模板不受影响

	Given jobs登录系统
	When jobs更新属性模板'计算机模板'
		"""
		{
			"name": "计算机模板*",
			"add_properties": [{
				"name": "主板",
				"description": "主板描述"
			}],
			"update_properties": [{
				"original_name": "CPU",
				"name": "CPU*",
				"description": "CPU*描述"
			}],
			"delete_properties": [{
				"name": "内存"
			}]
		}
		"""
	Then jobs能获取属性模板列表
		"""
		[{
			"name": "计算机模板*"
		},{
			"name": "大米模板"
		}]
		"""
	And jobs能获取属性模板'计算机模板*'
		"""
		{
			"properties": [{
				"name": "CPU*",
				"description": "CPU*描述"
			},{
				"name": "主板",
				"description": "主板描述"
			}]
		}
		"""
	Given bill登录系统
	Then bill能获取属性模板列表
		"""
		[{
			"name": "计算机模板"
		},{
			"name": "大米模板"
		}]
		"""
	And bill能获取属性模板'计算机模板'
		"""
		{
			"properties": [{
				"name": "CPU",
				"description": "CPU描述"
			}, {
				"name": "内存",
				"description": "内存描述"
			}]
		}
		"""
