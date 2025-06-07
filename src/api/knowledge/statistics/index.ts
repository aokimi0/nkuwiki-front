import request from '@/config/axios'

export interface SystemStatsVO {
  visitCount: number
  articleCount: number 
  userCount: number
  todayArticles: number
  weeklyActiveUsers: number
  commentCount: number
}

export interface UserActivityVO {
  userId: number
  activity: string
  time: string
}

export const StatisticsApi = {
  getSystemStats: async (): Promise<SystemStatsVO> => {
    return await request.get({ url: '/knowledge/statistics/system' })
  },

  getRecentActivities: async (): Promise<UserActivityVO[]> => {
    return await request.get({ url: '/knowledge/statistics/activities' })
  },

  recordVisit: async () => {
    return await request.post({ url: '/knowledge/statistics/visit' })
  }
} 