export interface ProjectInfo {
  name: string
  icon: string
  description: string
  color: string
  url: string
  language: string
  languageIcon: string
  stars?: string
  status: 'active' | 'stable' | 'archived'
  statusText: string
  featured?: boolean
}

export const projects: ProjectInfo[] = [
  {
    name: 'nkuwiki-back',
    icon: 'mdi:server',
    description: 'nkuwiki 后端服务 - 基于 Spring Boot 构建的知识共享平台后端',
    color: '#6DB33F',
    url: 'https://github.com/aokimi0/nkuwiki-back',
    language: 'Java',
    languageIcon: 'logos:java',
    stars: '50+',
    status: 'active',
    statusText: '活跃开发',
    featured: true
  },
  {
    name: 'nkuwiki-front',
    icon: 'mdi:vuejs',
    description: 'nkuwiki 前端项目 - 基于 Vue 3 + Element Plus 的现代化管理界面',
    color: '#4FC08D',
    url: 'https://github.com/aokimi0/nkuwiki-front',
    language: 'Vue.js',
    languageIcon: 'logos:vue',
    stars: '30+',
    status: 'active',
    statusText: '活跃开发',
    featured: true
  },
  {
    name: 'NKUCS.ICU',
    icon: 'mdi:school',
    description: '南开大学计算机系课程攻略 - 提供课程资料、考试经验和学习指南',
    color: '#FF7F50',
    url: 'https://github.com/NKUCS-ICU/NKUCS.ICU',
    language: 'Markdown',
    languageIcon: 'mdi:markdown',
    stars: '500+',
    status: 'stable',
    statusText: '稳定维护',
    featured: true
  },
  {
    name: 'nkuwiki-mobile',
    icon: 'mdi:cellphone',
    description: 'nkuwiki 移动端应用 - 提供更好的移动端知识浏览体验',
    color: '#87CEEB',
    url: 'https://github.com/aokimi0/nkuwiki-mobile',
    language: 'React Native',
    languageIcon: 'logos:react',
    stars: '20+',
    status: 'active',
    statusText: '开发中'
  },
  {
    name: 'nkuwiki-docs',
    icon: 'mdi:book-open-variant',
    description: 'nkuwiki 项目文档 - 包含开发指南、API 文档和使用说明',
    color: '#9370DB',
    url: 'https://github.com/aokimi0/nkuwiki-docs',
    language: 'VitePress',
    languageIcon: 'logos:vitejs',
    stars: '15+',
    status: 'stable',
    statusText: '持续更新'
  },
  {
    name: 'nkuwiki-tools',
    icon: 'mdi:tools',
    description: 'nkuwiki 工具集 - 包含数据迁移、备份工具和开发辅助脚本',
    color: '#FFA500',
    url: 'https://github.com/aokimi0/nkuwiki-tools',
    language: 'Python',
    languageIcon: 'logos:python',
    stars: '10+',
    status: 'stable',
    statusText: '工具集'
  }
]

export const featuredProjects = projects.filter(p => p.featured)
export const allProjects = projects 