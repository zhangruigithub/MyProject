#editor：王丽 2015.10.14
#editor:三香 2016.05.15

Feature: 更新图片分组
	"""
		1.更新图片分组的名称
		2.在图片分组中添加图片、删除图片（若该图片被商品使用，对商品无影响）
	"""

Background:
	Given jobs登录系统
	When jobs添加图片分组
		"""
		{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""
	When jobs添加图片分组
		"""
		{
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""
	When jobs添加图片分组
		"""
		{
			"name": "图片分组3",
			"images": []
		}
		"""
	Given bill登录系统
	When bill添加图片分组
		"""
		{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""
	When bill添加图片分组
		"""
		{
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""
	When bill添加图片分组
		"""
		{
			"name": "图片分组3",
			"images": []
		}
		"""

@product @picture
Scenario:1 更新图片分组
	jobs更新图片分组的名称和图片后
	1. job的图片分组更新
	2. bill的图片分组不受影响
	
	Given jobs登录系统
	Then jobs能获取图片分组列表
		"""
		[{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}, {
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}, {
			"name": "图片分组3",
			"images": []
		}]
		"""
	When jobs更新图片分组'图片分组1'
		"""
		{
			"name": "图片分组1*",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"path": "/standard_static/test_resource_img/mian1.jpg"
			}]
		}
		"""
	Then jobs能获取图片分组列表
		"""
		[{
			"name": "图片分组1*",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/mian1.jpg"
			}]
		}, {
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}, {
			"name": "图片分组3",
			"images": []
		}]
		"""
	And jobs能获取图片分组'图片分组1*'
		"""
		{
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/mian1.jpg"
			}]
		}
		"""
	Given bill登录系统
	Then bill能获取图片分组列表
		"""
		[{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		},{
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		},{
			"name": "图片分组3",
			"images": []
		}]
		"""

#editor：李娜 2016.09.05
@product @picture
Scenario:2 更新分组中图片
	jobs更新图片分组的图片后
	1. job的图片分组更新
	2. bill的图片分组不受影响
	
	Given jobs登录系统
	
	When jobs添加商品图片
		"""
		{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""
	Then jobs能获取图片分组列表
		"""
		[{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		},{
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		},{
			"name": "图片分组3",
			"images": []
		}]
		"""
	And jobs能获取图片分组'图片分组1'
		"""
		{
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""
	When jobs删除商品图片
		"""
		{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}]
		}
		"""
	Then jobs能获取图片分组列表
		"""
		[{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		},{
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		},{
			"name": "图片分组3",
			"images": []
		}]
		"""
	And jobs能获取图片分组'图片分组1'
		"""
		{
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""

