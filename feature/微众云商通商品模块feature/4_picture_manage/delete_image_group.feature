#author：张三香 2016.08.05

Feature: 删除图片分组
	"""
		1.删除图片分组后，则该分组中在图片分组列表中消失
		2.删除图片分组后，则该分组在添加商品上传图片弹框中的'选择图片组'下拉框中消失
		3.删除图片分组对正在使用该分组中图片的商品无任何影响
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

@product @picture
Scenario:1 删除图片分组

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
		},{
			"name": "图片分组3",
			"images": []
		}]
		"""
	When jobs删除图片分组'图片分组3'
	Then jobs能获取图片分组列表
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
		}]
		"""
	When jobs删除图片分组'图片分组1'
	Then jobs能获取图片分组列表
		"""
		[{
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}]
		"""