<template>
  <div class="article-detail">
    <ContentWrap>
      <div v-loading="loading" class="article-container">
        <div v-if="article">
          <div class="article-header">
            <h1 class="article-title">{{ article.title }}</h1>
            <div class="article-meta">
              <el-tag type="info" size="small">{{ article.sourcePlatform }}</el-tag>
              <span class="publish-date">{{ formatDate(article.publishDate) }}</span>
            </div>
          </div>
          <div class="article-body">
            <div class="content" v-html="article.content"></div>
          </div>
        </div>
        
        <el-empty v-else description="文章不存在" />
      </div>
    </ContentWrap>

    <ContentWrap v-if="article">
      <div class="comment-section">
        <div class="comment-header">
          <h3>评论区</h3>
          <div class="comment-info">
            <span class="comment-count">{{ comments.length }} 条评论</span>
            <span v-if="currentUser.nickname" class="current-user">
              当前用户：{{ currentUser.nickname }}
            </span>
          </div>
        </div>
        
        <div class="comment-form">
          <el-form @submit.prevent="submitComment">
            <el-form-item>
              <el-input
                v-model="newComment"
                type="textarea"
                :rows="4"
                :placeholder="currentUser.nickname ? '写下你的评论...' : '请先登录后发表评论'"
                maxlength="500"
                show-word-limit
                :disabled="!currentUser.nickname"
              />
            </el-form-item>
            <el-form-item>
              <el-button 
                type="primary" 
                @click="submitComment"
                :loading="commentLoading"
                :disabled="!newComment.trim() || !currentUser.nickname"
              >
                {{ currentUser.nickname ? '发表评论' : '请先登录' }}
              </el-button>
            </el-form-item>
          </el-form>
        </div>
        
        <div class="comment-list">
          <div v-for="comment in comments" :key="comment.id" class="comment-item">
            <div class="comment-avatar">
              <el-avatar :size="40">{{ getUserDisplayName(comment.userId)?.charAt(0) || 'U' }}</el-avatar>
            </div>
            <div class="comment-content">
              <div class="comment-header">
                <span class="user-name">{{ getUserDisplayName(comment.userId) || '匿名用户' }}</span>
                <span class="comment-time">{{ formatDate(comment.commentDate) }}</span>
              </div>
              <div class="comment-text">{{ comment.commentContent }}</div>
              <div class="comment-actions">
                <el-button 
                  link 
                  type="primary" 
                  size="small"
                  @click="likeComment(comment.id)"
                >
                  <Icon icon="ep:thumb" class="mr-1" />
                  {{ comment.likes || 0 }}
                </el-button>
                <el-button 
                  link 
                  type="info" 
                  size="small"
                  @click="replyToComment(comment.id)"
                >
                  回复
                </el-button>
              </div>
            </div>
          </div>
          
          <el-empty v-if="comments.length === 0" description="暂无评论，快来抢沙发吧！" />
        </div>
      </div>
    </ContentWrap>
  </div>
</template>

<script setup lang="ts">
import { ArticlesApi, ArticlesVO } from '@/api/knowledge/articles'
import { CommentsApi, CommentsVO } from '@/api/knowledge/comments'
import { formatDate } from '@/utils/formatTime'
import { useUserStore } from '@/store/modules/user'

defineOptions({ name: 'ArticleDetail' })

const route = useRoute()
const message = useMessage()
const userStore = useUserStore()

const loading = ref(true)
const article = ref<ArticlesVO | null>(null)
const comments = ref<any[]>([])
const newComment = ref('')
const commentLoading = ref(false)

const articleId = computed(() => parseInt(route.params.id as string))
const currentUser = computed(() => userStore.getUser)

const getArticleDetail = async () => {
  try {
    loading.value = true
    const data = await ArticlesApi.getArticles(articleId.value)
    article.value = data
  } catch (error) {
    message.error('获取文章详情失败')
  } finally {
    loading.value = false
  }
}

const loadComments = async () => {
  try {
    const params = {
      articleId: articleId.value,
      pageNo: 1,
      pageSize: 100
    }
    console.log('正在获取评论，参数:', params)
    const data = await CommentsApi.getCommentsPage(params)
    console.log('获取评论成功，数据:', data)
    comments.value = data.list || []
  } catch (error) {
    console.error('获取评论失败:', error)
    message.error('获取评论失败，请刷新重试')
    comments.value = []
  }
}

const submitComment = async () => {
  if (!newComment.value.trim()) {
    message.warning('请输入评论内容')
    return
  }
  
  if (!currentUser.value.nickname) {
    message.warning('请先登录')
    return
  }
  
  try {
    commentLoading.value = true
    
    const commentData = {
      commentContent: newComment.value.trim(),
      userId: currentUser.value.id,
      articleId: articleId.value,
      commentDate: new Date()
    }
    
    console.log('正在发表评论，数据:', commentData)
    await CommentsApi.createComments(commentData as CommentsVO)
    console.log('评论发表成功')
    
    newComment.value = ''
    message.success('评论发表成功')
    
    await loadComments()
  } catch (error) {
    console.error('发表评论失败:', error)
    message.error('发表评论失败，请稍后重试')
  } finally {
    commentLoading.value = false
  }
}

const likeComment = async (commentId: number) => {
  try {
    const comment = comments.value.find(c => c.id === commentId)
    if (comment) {
      comment.likes = (comment.likes || 0) + 1
      message.success('点赞成功')
    }
  } catch (error) {
    console.error('点赞失败:', error)
    message.error('点赞失败，请稍后重试')
  }
}

const getUserDisplayName = (userId: number) => {
  if (userId === currentUser.value.id) {
    return currentUser.value.nickname
  }
  return `用户${userId}`
}

const replyToComment = (commentId: number) => {
  message.info('回复功能开发中...')
}

onMounted(() => {
  getArticleDetail()
  loadComments()
})
</script>

<style scoped>
.article-container {
  min-height: auto;
}

.article-header {
  padding: 20px 0 16px 0;
  margin-bottom: 16px;
  border-bottom: 1px solid var(--el-border-color-lighter);
}

.article-title {
  font-size: 24px;
  font-weight: 600;
  color: var(--el-text-color-primary);
  margin: 0 0 12px 0;
  line-height: 1.4;
}

.article-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  color: var(--el-text-color-regular);
  font-size: 14px;
}

.publish-date {
  display: flex;
  align-items: center;
}

.article-body {
  padding: 0;
  line-height: 1.8;
}

.content {
  font-size: 16px;
  color: var(--el-text-color-primary);
  word-break: break-word;
  line-height: 1.8;
}

.content :deep(p) {
  margin-bottom: 16px;
}

.content :deep(h1),
.content :deep(h2),
.content :deep(h3),
.content :deep(h4),
.content :deep(h5),
.content :deep(h6) {
  margin: 24px 0 16px 0;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.content :deep(ul),
.content :deep(ol) {
  margin-bottom: 16px;
  padding-left: 24px;
}

.content :deep(blockquote) {
  border-left: 4px solid var(--el-color-primary);
  padding: 16px;
  margin: 16px 0;
  color: var(--el-text-color-regular);
  background: var(--el-fill-color-light);
  border-radius: 4px;
}

.comment-section {
  padding: 16px 0;
}

.comment-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--el-border-color);
}

.comment-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.comment-info {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
}

.comment-count {
  color: var(--el-text-color-regular);
  font-size: 14px;
}

.current-user {
  color: var(--el-color-primary);
  font-size: 12px;
}

.comment-form {
  margin-bottom: 24px;
}

.comment-item {
  display: flex;
  gap: 12px;
  padding: 16px 0;
  border-bottom: 1px solid var(--el-border-color-lighter);
}

.comment-item:last-child {
  border-bottom: none;
}

.comment-avatar {
  flex-shrink: 0;
}

.comment-content {
  flex: 1;
}

.comment-item .comment-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
  border: none;
  padding: 0;
}

.user-name {
  font-weight: 500;
  color: var(--el-text-color-primary);
  font-size: 14px;
}

.comment-time {
  color: var(--el-text-color-placeholder);
  font-size: 12px;
}

.comment-text {
  color: var(--el-text-color-regular);
  line-height: 1.6;
  margin-bottom: 8px;
  font-size: 14px;
}

.comment-actions {
  display: flex;
  gap: 16px;
}
</style> 