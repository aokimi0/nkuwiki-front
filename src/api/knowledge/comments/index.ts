import request from '@/config/axios'

// 评论信息 VO
export interface CommentsVO {
  id: number // 评论编号
  commentContent: string // 评论内容
  commentDate: Date // 评论时间
  userId: number // 评论用户ID
  articleId: number // 文章ID
}

// 评论信息 API
export const CommentsApi = {
  // 查询评论信息分页
  getCommentsPage: async (params: any) => {
    return await request.get({ url: `/knowledge/comments/page`, params })
  },

  // 查询评论信息详情
  getComments: async (id: number) => {
    return await request.get({ url: `/knowledge/comments/get?id=` + id })
  },

  // 新增评论信息
  createComments: async (data: CommentsVO) => {
    return await request.post({ url: `/knowledge/comments/create`, data })
  },

  // 修改评论信息
  updateComments: async (data: CommentsVO) => {
    return await request.put({ url: `/knowledge/comments/update`, data })
  },

  // 删除评论信息
  deleteComments: async (id: number) => {
    return await request.delete({ url: `/knowledge/comments/delete?id=` + id })
  },

  // 导出评论信息 Excel
  exportComments: async (params) => {
    return await request.download({ url: `/knowledge/comments/export-excel`, params })
  },
}