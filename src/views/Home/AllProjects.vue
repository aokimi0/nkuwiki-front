<template>
  <div class="all-projects-page">
    <ContentWrap>
      <div class="page-header">
        <div class="header-content">
          <div class="title-section">
            <h1 class="page-title">
              <Icon icon="mdi:github" class="title-icon" />
              项目生态
            </h1>
            <p class="page-subtitle">
              探索 nkuwiki 知识共享平台的完整项目生态，包含前后端、移动端、文档和工具集
            </p>
          </div>
          <div class="stats-section">
            <div class="stat-card">
              <div class="stat-number">{{ allProjects.length }}</div>
              <div class="stat-label">总项目数</div>
            </div>
            <div class="stat-card">
              <div class="stat-number">{{ activeProjectsCount }}</div>
              <div class="stat-label">活跃项目</div>
            </div>
            <div class="stat-card">
              <div class="stat-number">{{ totalStars }}</div>
              <div class="stat-label">总 Stars</div>
            </div>
          </div>
        </div>
      </div>
    </ContentWrap>

    <ContentWrap class="mt-16px">
      <div class="projects-container">
        <div class="section-header">
          <h2 class="section-title">
            <Icon icon="mdi:star" class="section-icon" />
            精选项目
          </h2>
          <p class="section-desc">核心项目，构成平台的基础架构</p>
        </div>
        
        <div class="projects-grid featured-grid">
          <div
            v-for="project in featuredProjects"
            :key="project.name"
            class="project-card featured-card"
            @click="handleProjectClick(project.url)"
          >
            <div class="project-header">
              <div class="project-icon-wrapper">
                <Icon :icon="project.icon" :size="40" :style="{ color: project.color }" />
                <div class="project-status" :class="project.status">
                  {{ project.statusText }}
                </div>
              </div>
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
            
            <div class="project-content">
              <h3 class="project-name">{{ project.name }}</h3>
              <p class="project-desc">{{ project.description }}</p>
            </div>
            
            <div class="project-footer">
              <el-button type="primary" size="small" @click.stop="handleProjectClick(project.url)">
                <Icon icon="mdi:github" class="mr-4px" />
                查看源码
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </ContentWrap>

    <ContentWrap class="mt-16px">
      <div class="projects-container">
        <div class="section-header">
          <h2 class="section-title">
            <Icon icon="mdi:apps" class="section-icon" />
            全部项目
          </h2>
          <p class="section-desc">完整的项目列表，包含工具、文档和扩展项目</p>
        </div>
        
        <div class="projects-grid">
          <div
            v-for="project in allProjects"
            :key="project.name"
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
      </div>
    </ContentWrap>
  </div>
</template>

<script lang="ts" setup>
import { allProjects, featuredProjects } from './projects'

defineOptions({ name: 'AllProjects' })

const activeProjectsCount = computed(() => 
  allProjects.filter(p => p.status === 'active').length
)

const totalStars = computed(() => {
  return allProjects.reduce((total, project) => {
    if (project.stars) {
      const num = parseInt(project.stars.replace('+', ''))
      return total + num
    }
    return total
  }, 0) + '+'
})

const handleProjectClick = (url: string) => {
  window.open(url, '_blank')
}
</script>

<style lang="scss" scoped>
.all-projects-page {
  padding: 16px;
  background: var(--el-bg-color-page);
  min-height: calc(100vh - 84px);
}

.page-header {
  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 32px 0;
    
    .title-section {
      flex: 1;
      
      .page-title {
        display: flex;
        align-items: center;
        font-size: 32px;
        font-weight: bold;
        color: var(--el-text-color-primary);
        margin: 0 0 12px 0;
        
        .title-icon {
          margin-right: 12px;
          color: var(--el-color-primary);
        }
      }
      
      .page-subtitle {
        font-size: 16px;
        color: var(--el-text-color-regular);
        line-height: 1.6;
        margin: 0;
        max-width: 600px;
      }
    }
    
    .stats-section {
      display: flex;
      gap: 24px;
      
      .stat-card {
        text-align: center;
        
        .stat-number {
          font-size: 32px;
          font-weight: bold;
          color: var(--el-color-primary);
          line-height: 1;
        }
        
        .stat-label {
          font-size: 14px;
          color: var(--el-text-color-regular);
          margin-top: 8px;
        }
      }
    }
  }
}

.projects-container {
  .section-header {
    margin-bottom: 24px;
    
    .section-title {
      display: flex;
      align-items: center;
      font-size: 24px;
      font-weight: 600;
      color: var(--el-text-color-primary);
      margin: 0 0 8px 0;
      
      .section-icon {
        margin-right: 8px;
        color: var(--el-color-primary);
      }
    }
    
    .section-desc {
      font-size: 14px;
      color: var(--el-text-color-regular);
      margin: 0;
    }
  }
  
  .projects-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 20px;
    
    &.featured-grid {
      grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
      gap: 24px;
      margin-bottom: 32px;
    }
    
    .project-card {
      padding: 24px;
      border-radius: 12px;
      background: var(--el-fill-color-blank);
      border: 1px solid var(--el-border-color-light);
      cursor: pointer;
      transition: all 0.3s ease;
      position: relative;
      
      &:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 32px rgba(0, 0, 0, 0.1);
        border-color: var(--el-color-primary-light-5);
      }
      
      &.featured-card {
        background: linear-gradient(135deg, var(--el-fill-color-blank) 0%, var(--el-fill-color-lighter) 100%);
        border: 2px solid var(--el-color-primary-light-8);
        
        .project-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: 16px;
          
          .project-meta {
            display: flex;
            flex-direction: column;
            gap: 8px;
            align-items: flex-end;
          }
        }
        
        .project-content {
          margin-bottom: 20px;
          
          .project-name {
            font-size: 20px;
            font-weight: 600;
            margin: 0 0 12px 0;
          }
          
          .project-desc {
            font-size: 14px;
            line-height: 1.5;
            margin: 0;
          }
        }
        
        .project-footer {
          display: flex;
          justify-content: flex-end;
        }
      }
      
      .project-icon-wrapper {
        position: relative;
        display: flex;
        align-items: center;
        margin-bottom: 16px;
        
        .project-status {
          position: absolute;
          top: -8px;
          right: -8px;
          padding: 4px 8px;
          border-radius: 12px;
          font-size: 11px;
          font-weight: 500;
          
          &.active {
            background: var(--el-color-success-light-8);
            color: var(--el-color-success);
          }
          
          &.stable {
            background: var(--el-color-warning-light-8);
            color: var(--el-color-warning);
          }
          
          &.archived {
            background: var(--el-color-info-light-8);
            color: var(--el-color-info);
          }
        }
      }
      
      .project-info {
        .project-name {
          font-size: 18px;
          font-weight: 600;
          color: var(--el-text-color-primary);
          margin: 0 0 12px 0;
        }
        
        .project-desc {
          font-size: 13px;
          color: var(--el-text-color-regular);
          line-height: 1.4;
          margin: 0 0 16px 0;
          display: -webkit-box;
          -webkit-line-clamp: 3;
          -webkit-box-orient: vertical;
          overflow: hidden;
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

@media (max-width: 768px) {
  .all-projects-page {
    padding: 8px;
  }
  
  .page-header .header-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 24px;
    
    .stats-section {
      align-self: stretch;
      justify-content: space-around;
    }
  }
  
  .projects-grid {
    grid-template-columns: 1fr !important;
    gap: 16px !important;
    
    .project-card {
      padding: 20px;
    }
  }
}
</style> 