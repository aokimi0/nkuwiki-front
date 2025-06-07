import request from '@/config/axios'

// 文章信息 VO
export interface ArticlesVO {
  id: number // 文章编号
  title: string // 文章标题
  articleId: number // 文章ID
  content: string // 文章内容
  publishDate: Date // 发布时间
  authorId: number // 作者ID
  sourcePlatform: string // 来源平台
}

// 文章信息 API
export const ArticlesApi = {
  // 查询文章信息分页
  getArticlesPage: async (params: any) => {
    return await request.get({ url: `/knowledge/articles/page`, params })
  },

  // 查询文章信息详情
  getArticles: async (id: number) => {
    return await request.get({ url: `/knowledge/articles/get?id=` + id })
  },

  // 新增文章信息
  createArticles: async (data: ArticlesVO) => {
    return await request.post({ url: `/knowledge/articles/create`, data })
  },

  // 修改文章信息
  updateArticles: async (data: ArticlesVO) => {
    return await request.put({ url: `/knowledge/articles/update`, data })
  },

  // 删除文章信息
  deleteArticles: async (id: number) => {
    return await request.delete({ url: `/knowledge/articles/delete?id=` + id })
  },

  // 导出文章信息 Excel
  exportArticles: async (params) => {
    return await request.download({ url: `/knowledge/articles/export-excel`, params })
  },
}