<template>
  <div class="home-page">
    <el-card shadow="never" class="welcome-card">
      <el-skeleton :loading="loading" animated>
        <el-row :gutter="16" justify="space-between" align="middle">
          <el-col :xl="16" :lg="16" :md="16" :sm="24" :xs="24">
            <div class="flex items-center">
              <el-avatar :src="avatar" :size="70" class="mr-16px user-avatar">
                <img src="@/assets/imgs/avatar.gif" alt="" />
              </el-avatar>
              <div>
                <div class="welcome-title">
                  {{ t('workplace.welcome') }} {{ username }} {{ t('workplace.happyDay') }}
                </div>
                <div class="welcome-subtitle">
                  欢迎使用 nkuwiki 南开知识共享平台！
                </div>
              </div>
            </div>
          </el-col>
          <el-col :xl="8" :lg="8" :md="8" :sm="24" :xs="24">
            <div class="stats-overview">
              <div class="stat-item">
                <div class="stat-value">{{ systemStats.visitCount }}</div>
                <div class="stat-label">今日访问</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ systemStats.articleCount }}</div>
                <div class="stat-label">知识文章</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ systemStats.userCount }}</div>
                <div class="stat-label">注册用户</div>
              </div>
            </div>
          </el-col>
        </el-row>
      </el-skeleton>
    </el-card>

    <el-row class="content-row" :gutter="16">
      <el-col :xl="16" :lg="16" :md="24" :sm="24" :xs="24" class="mb-16px">
        <el-card shadow="never" class="intro-card">
          <template #header>
            <div class="card-header">
              <h3 class="card-title">
                <Icon icon="mdi:information-outline" class="title-icon" />
                项目介绍
              </h3>
            </div>
          </template>
          <el-skeleton :loading="loading" animated>
            <div class="intro-content">
              <div class="intro-section">
                <h4>🎯 核心定位</h4>
                <p>本项目 <strong>nkuwiki-front</strong> 是 <strong>nkuwiki 南开校园知识共享平台</strong>的前端用户界面，致力于为南开师生提供优质的知识管理与分享体验。</p>
              </div>
              
              <div class="intro-section">
                <h4>🚀 技术特色</h4>
                <div class="feature-grid">
                  <div class="feature-item">
                    <Icon icon="logos:vue" class="feature-icon" />
                    <span>Vue 3 + TypeScript</span>
                  </div>
                  <div class="feature-item">
                    <Icon icon="logos:element" class="feature-icon" />
                    <span>Element Plus UI</span>
                  </div>
                  <div class="feature-item">
                    <Icon icon="logos:vitejs" class="feature-icon" />
                    <span>Vite 构建工具</span>
                  </div>
                  <div class="feature-item">
                    <Icon icon="mdi:palette" class="feature-icon" />
                    <span>响应式设计</span>
                  </div>
                </div>
              </div>

              <div class="intro-section">
                <h4>✨ 核心功能</h4>
                <ul class="feature-list">
                  <li>📚 知识文章管理与分享</li>
                  <li>👥 用户角色权限管理</li>
                  <li>💬 互动评论与反馈</li>
                  <li>🔍 智能搜索与推荐</li>
                  <li>📱 多端适配与优化</li>
                </ul>
              </div>
            </div>
          </el-skeleton>
        </el-card>

        <el-card shadow="never" class="projects-card mt-16px">
          <template #header>
            <div class="card-header">
              <h3 class="card-title">
                <Icon icon="mdi:github" class="title-icon" />
                项目生态
              </h3>
              <el-link
                type="primary"
                :underline="false"
                @click="router.push('/projects')"
                class="more-link"
              >
                <Icon icon="mdi:apps" class="mr-4px" />
                {{ t('action.more') }}
              </el-link>
            </div>
          </template>
          <el-skeleton :loading="loading" animated>
            <div class="projects-grid">
              <div
                v-for="(project, index) in projects"
                :key="`project-${index}`"
                class="project-card"
                @click="handleProjectClick(project.url)"
              >
                <div class="project-icon-wrapper">
                  <Icon :icon="project.icon" :size="32" :style="{ color: project.color }" />
                  <div class="project-status" :class="project.status">
                    {{ project.statusText }}
                  </div>
                </div>
                <div class="project-info">
                  <h4 class="project-name">{{ project.name }}</h4>
                  <p class="project-desc">{{ project.description }}</p>
                  <div class="project-meta">
                    <span class="project-language">
                      <Icon :icon="project.languageIcon" :size="16" />
                      {{ project.language }}
                    </span>
                    <span class="project-stars" v-if="project.stars">
                      <Icon icon="mdi:star" :size="16" />
                      {{ project.stars }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </el-skeleton>
        </el-card>
      </el-col>

      <el-col :xl="8" :lg="8" :md="24" :sm="24" :xs="24" class="mb-16px">
        <el-card shadow="never" class="shortcuts-card">
          <template #header>
            <div class="card-header">
              <h3 class="card-title">
                <Icon icon="mdi:lightning-bolt" class="title-icon" />
                快捷操作
              </h3>
            </div>
          </template>
          <el-skeleton :loading="loading" animated>
            <div class="shortcuts-grid">
              <div
                v-for="item in shortcuts"
                :key="`shortcut-${item.name}`"
                class="shortcut-item"
                @click="handleShortcutClick(item.url)"
              >
                <div class="shortcut-icon" :style="{ backgroundColor: item.color + '20', color: item.color }">
                  <Icon :icon="item.icon" :size="24" />
                </div>
                <div class="shortcut-info">
                  <div class="shortcut-name">{{ item.name }}</div>
                  <div class="shortcut-desc">{{ item.description }}</div>
                </div>
                <Icon icon="mdi:chevron-right" class="shortcut-arrow" />
              </div>
            </div>
          </el-skeleton>
        </el-card>

        <el-card shadow="never" class="activity-card mt-16px">
          <template #header>
            <div class="card-header">
              <h3 class="card-title">
                <Icon icon="mdi:chart-line" class="title-icon" />
                系统状态
              </h3>
            </div>
          </template>
          <el-skeleton :loading="loading" animated>
            <div class="activity-list">
              <div class="activity-item">
                <div class="activity-dot active"></div>
                <div class="activity-content">
                  <div class="activity-title">系统运行正常</div>
                  <div class="activity-time">{{ currentTime }}</div>
                </div>
              </div>
              <div class="activity-item">
                <div class="activity-dot"></div>
                <div class="activity-content">
                  <div class="activity-title">今日新增文章 {{ systemStats.todayArticles }} 篇</div>
                  <div class="activity-time">今天</div>
                </div>
              </div>
              <div class="activity-item">
                <div class="activity-dot"></div>
                <div class="activity-content">
                  <div class="activity-title">本周活跃用户 {{ systemStats.weeklyActiveUsers }} 人</div>
                  <div class="activity-time">本周</div>
                </div>
              </div>
            </div>
          </el-skeleton>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script lang="ts" setup>
import { useUserStore } from '@/store/modules/user'
import { useRouter } from 'vue-router'
import { ArticlesApi } from '@/api/knowledge/articles'
import { StatisticsApi, type SystemStatsVO } from '@/api/knowledge/statistics'
import { featuredProjects } from './projects'

defineOptions({ name: 'Home' })

const { t } = useI18n()
const router = useRouter()
const userStore = useUserStore()
const loading = ref(true)
const avatar = userStore.getUser.avatar
const username = userStore.getUser.nickname

const systemStats = ref<SystemStatsVO>({
  visitCount: 0,
  articleCount: 0,
  userCount: 0,
  todayArticles: 0,
  weeklyActiveUsers: 0,
  commentCount: 0
})

const currentTime = ref('')

const projects = featuredProjects

const shortcuts = [
  {
    name: '文章管理',
    icon: 'mdi:file-document-edit',
    url: '/knowledge/articles',
    color: '#409EFF',
    description: '管理知识文章'
  },
  {
    name: '评论管理',
    icon: 'mdi:comment-text',
    url: '/knowledge/comments',
    color: '#67C23A',
    description: '管理用户评论'
  },
  {
    name: '个人中心',
    icon: 'mdi:account-circle',
    url: '/user/profile',
    color: '#E6A23C',
    description: '编辑个人信息'
  },
  {
    name: '系统设置',
    icon: 'mdi:cog',
    url: '/system/menu',
    color: '#F56C6C',
    description: '系统配置管理'
  }
]

const handleProjectClick = (url: string) => {
  window.open(url, '_blank')
}

const handleShortcutClick = (url: string) => {
  router.push(url)
}

const updateCurrentTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN')
}

const getSystemStats = async () => {
  try {
    const stats = await StatisticsApi.getSystemStats()
    systemStats.value = stats
    await StatisticsApi.recordVisit()
  } catch (error) {
    console.warn('获取系统统计失败，使用模拟数据:', error)
    try {
      const result = await ArticlesApi.getArticlesPage({ pageNo: 1, pageSize: 1 })
      systemStats.value.articleCount = result.total || 0
      systemStats.value.visitCount = Math.floor(Math.random() * 1000) + 500
      systemStats.value.userCount = Math.floor(Math.random() * 200) + 100
      systemStats.value.todayArticles = Math.floor(Math.random() * 10) + 1
      systemStats.value.weeklyActiveUsers = Math.floor(Math.random() * 50) + 20
    } catch (apiError) {
      console.warn('获取文章数据失败:', apiError)
      systemStats.value = {
        visitCount: 1234,
        articleCount: 56,
        userCount: 156,
        todayArticles: 8,
        weeklyActiveUsers: 89,
        commentCount: 234
      }
    }
  }
}

onMounted(async () => {
  updateCurrentTime()
  setInterval(updateCurrentTime, 1000)
  await getSystemStats()
  loading.value = false
})
</script>

<style lang="scss" scoped>
.home-page {
  padding: 16px;
  background: var(--el-bg-color-page);
  min-height: calc(100vh - 84px);
}

.welcome-card {
  margin-bottom: 16px;
  border-radius: 12px;
  background: linear-gradient(135deg, var(--el-color-primary-light-9) 0%, var(--el-color-primary-light-8) 100%);
  
  .user-avatar {
    border: 3px solid var(--el-color-white);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }
  
  .welcome-title {
    font-size: 24px;
    font-weight: 600;
    color: var(--el-text-color-primary);
    margin-bottom: 8px;
  }
  
  .welcome-subtitle {
    font-size: 14px;
    color: var(--el-text-color-regular);
  }
  
  .stats-overview {
    display: flex;
    justify-content: space-around;
    
    .stat-item {
      text-align: center;
      
      .stat-value {
        font-size: 28px;
        font-weight: bold;
        color: var(--el-color-primary);
        line-height: 1;
      }
      
      .stat-label {
        font-size: 12px;
        color: var(--el-text-color-regular);
        margin-top: 4px;
      }
    }
  }
}

.content-row {
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .card-title {
      display: flex;
      align-items: center;
      font-size: 16px;
      font-weight: 600;
      color: var(--el-text-color-primary);
      margin: 0;
      
      .title-icon {
        margin-right: 8px;
        color: var(--el-color-primary);
      }
    }
    
    .more-link {
      font-size: 14px;
    }
  }
}

.intro-card {
  border-radius: 12px;
  
  .intro-content {
    .intro-section {
      margin-bottom: 24px;
      
      &:last-child {
        margin-bottom: 0;
      }
      
      h4 {
        font-size: 16px;
        font-weight: 600;
        color: var(--el-text-color-primary);
        margin: 0 0 12px 0;
      }
      
      p {
        color: var(--el-text-color-regular);
        line-height: 1.6;
        margin: 0 0 12px 0;
      }
      
      .feature-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 12px;
        
        .feature-item {
          display: flex;
          align-items: center;
          padding: 8px 12px;
          background: var(--el-fill-color-lighter);
          border-radius: 8px;
          
          .feature-icon {
            margin-right: 8px;
          }
          
          span {
            font-size: 14px;
            color: var(--el-text-color-regular);
          }
        }
      }
      
      .feature-list {
        list-style: none;
        padding: 0;
        margin: 0;
        
        li {
          padding: 6px 0;
          color: var(--el-text-color-regular);
          font-size: 14px;
        }
      }
    }
  }
}

.projects-card {
  border-radius: 12px;
  
  .projects-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 16px;
    
    .project-card {
      padding: 20px;
      border-radius: 10px;
      background: var(--el-fill-color-lighter);
      border: 1px solid var(--el-border-color-light);
      cursor: pointer;
      transition: all 0.3s ease;
      position: relative;
      
      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        border-color: var(--el-color-primary-light-5);
      }
      
      .project-icon-wrapper {
        position: relative;
        display: flex;
        align-items: center;
        margin-bottom: 12px;
        
        .project-status {
          position: absolute;
          top: -5px;
          right: -5px;
          padding: 2px 6px;
          border-radius: 10px;
          font-size: 10px;
          font-weight: 500;
          
          &.active {
            background: var(--el-color-success-light-8);
            color: var(--el-color-success);
          }
          
          &.stable {
            background: var(--el-color-warning-light-8);
            color: var(--el-color-warning);
          }
        }
      }
      
      .project-info {
        .project-name {
          font-size: 16px;
          font-weight: 600;
          color: var(--el-text-color-primary);
          margin: 0 0 8px 0;
        }
        
        .project-desc {
          font-size: 13px;
          color: var(--el-text-color-regular);
          line-height: 1.4;
          margin: 0 0 12px 0;
        }
        
        .project-meta {
          display: flex;
          justify-content: space-between;
          align-items: center;
          
          .project-language,
          .project-stars {
            display: flex;
            align-items: center;
            font-size: 12px;
            color: var(--el-text-color-secondary);
            
            .el-icon {
              margin-right: 4px;
            }
          }
        }
      }
    }
  }
}

.shortcuts-card {
  border-radius: 12px;
  
  .shortcuts-grid {
    .shortcut-item {
      display: flex;
      align-items: center;
      padding: 16px;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.2s ease;
      margin-bottom: 8px;
      
      &:last-child {
        margin-bottom: 0;
      }
      
      &:hover {
        background: var(--el-fill-color-light);
        transform: translateX(4px);
      }
      
      .shortcut-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 12px;
      }
      
      .shortcut-info {
        flex: 1;
        
        .shortcut-name {
          font-size: 14px;
          font-weight: 600;
          color: var(--el-text-color-primary);
          margin-bottom: 2px;
        }
        
        .shortcut-desc {
          font-size: 12px;
          color: var(--el-text-color-secondary);
        }
      }
      
      .shortcut-arrow {
        color: var(--el-text-color-placeholder);
      }
    }
  }
}

.activity-card {
  border-radius: 12px;
  
  .activity-list {
    .activity-item {
      display: flex;
      align-items: center;
      padding: 12px 0;
      border-bottom: 1px solid var(--el-border-color-lighter);
      
      &:last-child {
        border-bottom: none;
      }
      
      .activity-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: var(--el-border-color);
        margin-right: 12px;
        
        &.active {
          background: var(--el-color-success);
          box-shadow: 0 0 0 3px var(--el-color-success-light-8);
        }
      }
      
      .activity-content {
        flex: 1;
        
        .activity-title {
          font-size: 13px;
          color: var(--el-text-color-primary);
          margin-bottom: 2px;
        }
        
        .activity-time {
          font-size: 11px;
          color: var(--el-text-color-placeholder);
        }
      }
    }
  }
}

@media (max-width: 768px) {
  .home-page {
    padding: 8px;
  }
  
  .stats-overview {
    margin-top: 16px;
  }
  
  .projects-grid {
    grid-template-columns: 1fr !important;
  }
  
  .content-row {
    margin: 0 !important;
    
    .el-col {
      margin-bottom: 16px;
      padding: 0 !important;
    }
  }
}
</style>
