# nkuwiki 知识共享平台 - 前端

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 1. 项目定位与二次开发说明

本项目 **`nkuwiki-front`** 是 **`nkuwiki` 南开校园知识共享平台**的前端用户界面。它是在优秀的开源项目 [yudao-ui-admin-vue3](https://github.com/yudaocode/yudao-ui-admin-vue3) (基于 Vue3, Vite, Element Plus，由芋道源码团队开发，特此感谢) 的基础上进行的**二次开发**。

二次开发的核心目标是**为 `nkuwiki` 项目定义的应用场景提供直观、易用的用户交互界面**，对原前端项目进行了以下关键调整：

*   **界面定制**：根据 `nkuwiki` 的品牌和功能需求，定制了界面的整体风格、布局和主要视图。
*   **功能适配**：调整和新增了前端组件及页面逻辑，以匹配 `nkuwiki-back` 后端提供的 API 和业务流程。
*   **聚焦核心交互**：移除了原项目中与 `nkuwiki` 校园知识共享场景不直接相关的前端视图和功能模块，使前端应用更轻量、用户体验更专注。
*   **响应式设计**：确保在不同设备上的良好展示效果。

## 2. 前端界面如何支撑 nkuwiki 应用场景

`nkuwiki-front` 通过以下主要界面和功能，为 `nkuwiki` 平台的核心应用场景提供用户交互支持：

### a. 用户认证与管理界面
*   **对应场景**：用户管理。
*   **前端实现**：
    *   提供清晰的**用户注册页面** (支持邮箱、用户名、密码输入)。
    *   提供安全的**用户登录页面**。
    *   **个人中心页面**：允许用户查看和修改个人基本信息（如昵称、邮箱，未来可扩展学号/工号等），管理已发布的文章和评论。

### b. 知识内容浏览与创作界面
*   **对应场景**：知识存储、内容互动。
*   **前端实现**：
    *   **文章/资源列表页面**：展示已发布的知识条目，支持按分类、标签或关键词进行筛选和搜索。
    *   **文章/资源详情页面**：清晰展示文章内容、作者、发布时间、评论等信息。
    *   集成 **Markdown 编辑器**：提供便捷的工具供用户创建和编辑文章/课程资源，支持富文本格式。
    *   **发布与编辑界面**：引导用户完成新知识条目的创建或对现有条目的修改。

### c. 课程与资源展示界面
*   **对应场景**：资源关联、知识存储。
*   **前端实现**：
    *   **课程列表页面**：展示平台上的所有课程。
    *   **课程详情页面**：集中展示特定课程的描述信息、授课教师以及该课程下的所有相关资源（如课件、笔记、链接等）。
    *   清晰的导航，方便用户在课程和其关联资源间跳转。

### d. 互动与反馈界面
*   **对应场景**：内容互动。
*   **前端实现**：
    *   **评论区**：在文章/资源详情页下方提供评论输入框和评论列表展示，支持用户发表评论和回复他人评论。

## 3. 主要技术栈

| 技术/库                                                              | 说明                      |
|----------------------------------------------------------------------|---------------------------|
| [Vue 3](https://staging-cn.vuejs.org/)                               | 渐进式 JavaScript 框架      |
| [Vite](https://cn.vitejs.dev//)                                      | 前端构建工具                |
| [Element Plus](https://element-plus.org/zh-CN/)                      | Vue 3 UI 组件库           |
| [Vue Router](https://router.vuejs.org/)                              |官方路由管理器              |
| [Pinia](https://pinia.vuejs.org/)                                    | Vue 状态管理库            |
| [TypeScript](https://www.typescriptlang.org/docs/)                   | JavaScript 的超集        |
| [Axios](https://axios-http.com/)                                     | HTTP 请求库               |
| [UnoCSS](https://uno.antfu.me/)                                      | 原子化 CSS 引擎           |
| [Iconify](https://icon-sets.iconify.design/)                         | 图标库解决方案              |
| [wangeditor](https://www.wangeditor.com/)                            | 富文本编辑器 (Markdown)     |

## 4. 快速上手

*   **环境要求**: Node.js >= 16.18.0, pnpm >= 8.6.0 (推荐使用 pnpm)
*   **安装依赖**: `pnpm install`
*   **开发模式运行**: `pnpm dev`
*   **生产环境构建**: `pnpm build`

## 5. 开源协议

本项目基于 `yudao-ui-admin-vue3` 二次开发，其遵循 [MIT License](https://github.com/yudaocode/yudao-ui-admin-vue3/blob/master/LICENSE)。因此，`nkuwiki-front` 项目同样采用 **MIT License** 开源协议。
