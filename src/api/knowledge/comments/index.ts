import request from '@/config/axios'

// 评论信息 VO
export interface CommentsVO {
  id: number // 评论编号
  commentContent: string // 评论内容
  commentDate: Date // 评论时间
  userId: number // 评论用户ID
  articleId: number // 文章ID
  createTime?: Date // 创建时间
  updateTime?: Date // 更新时间
  likes?: number // 点赞数（前端计算或后端扩展）
  replyCount?: number // 回复数（前端计算或后端扩展）
  userNickname?: string // 用户昵称（关联查询）
  userAvatar?: string // 用户头像（关联查询）
  isLiked?: boolean // 当前用户是否已点赞（前端状态）
}

// 用户简化信息 VO
export interface UserSimpleVO {
  id: number
  nickname: string
  avatar?: string
}

// 点赞记录 VO（建议后端实现）
export interface CommentLikeVO {
  id?: number
  commentId: number
  userId: number
  createTime?: Date
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

  // 点赞评论（建议后端实现）
  likeComment: async (commentId: number) => {
    return await request.post({ url: `/knowledge/comments/like`, data: { commentId } })
  },

  // 取消点赞评论（建议后端实现）
  unlikeComment: async (commentId: number) => {
    return await request.delete({ url: `/knowledge/comments/unlike`, data: { commentId } })
  },

  // 获取用户简化信息
  getUserSimpleInfo: async (userId: number): Promise<UserSimpleVO> => {
    return await request.get({ url: `/system/user/get?id=` + userId })
  },

  // 获取评论的点赞状态（建议后端实现）
  getCommentLikeStatus: async (commentId: number) => {
    return await request.get({ url: `/knowledge/comments/like-status?commentId=` + commentId })
  },

  // 获取评论点赞数（建议后端实现）
  getCommentLikesCount: async (commentId: number) => {
    return await request.get({ url: `/knowledge/comments/likes-count?commentId=` + commentId })
  },
}
