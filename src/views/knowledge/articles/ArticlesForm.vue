<template>
  <Dialog :title="dialogTitle" v-model="dialogVisible">
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="100px"
      v-loading="formLoading"
    >
      <el-form-item label="文章标题" prop="title">
        <el-input v-model="formData.title" placeholder="请输入文章标题" />
      </el-form-item>
      <el-form-item label="文章ID" prop="articleId">
        <el-input v-model="formData.articleId" placeholder="请输入文章ID" />
      </el-form-item>
      <el-form-item label="文章内容" prop="content">
        <Editor v-model="formData.content" height="150px" />
      </el-form-item>
      <el-form-item label="发布时间" prop="publishDate">
        <el-date-picker
          v-model="formData.publishDate"
          type="date"
          value-format="x"
          placeholder="选择发布时间"
        />
      </el-form-item>
      <el-form-item label="作者ID" prop="authorId">
        <el-input v-model="formData.authorId" placeholder="请输入作者ID" />
      </el-form-item>
      <el-form-item label="来源平台" prop="sourcePlatform">
        <el-input v-model="formData.sourcePlatform" placeholder="请输入来源平台" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="submitForm" type="primary" :disabled="formLoading">确 定</el-button>
      <el-button @click="dialogVisible = false">取 消</el-button>
    </template>
  </Dialog>
</template>
<script setup lang="ts">
import { ArticlesApi, ArticlesVO } from '@/api/knowledge/articles'

/** 文章信息 表单 */
defineOptions({ name: 'ArticlesForm' })

const { t } = useI18n() // 国际化
const message = useMessage() // 消息弹窗

const dialogVisible = ref(false) // 弹窗的是否展示
const dialogTitle = ref('') // 弹窗的标题
const formLoading = ref(false) // 表单的加载中：1）修改时的数据加载；2）提交的按钮禁用
const formType = ref('') // 表单的类型：create - 新增；update - 修改
const formData = ref({
  id: undefined,
  title: undefined,
  articleId: undefined,
  content: undefined,
  publishDate: undefined,
  authorId: undefined,
  sourcePlatform: undefined,
})
const formRules = reactive({
  title: [{ required: true, message: '文章标题不能为空', trigger: 'blur' }],
  articleId: [{ required: true, message: '文章ID不能为空', trigger: 'blur' }],
  content: [{ required: true, message: '文章内容不能为空', trigger: 'blur' }],
  authorId: [{ required: true, message: '作者ID不能为空', trigger: 'blur' }],
})
const formRef = ref() // 表单 Ref

/** 打开弹窗 */
const open = async (type: string, id?: number) => {
  dialogVisible.value = true
  dialogTitle.value = t('action.' + type)
  formType.value = type
  resetForm()
  // 修改时，设置数据
  if (id) {
    formLoading.value = true
    try {
      formData.value = await ArticlesApi.getArticles(id)
    } finally {
      formLoading.value = false
    }
  }
}
defineExpose({ open }) // 提供 open 方法，用于打开弹窗

/** 提交表单 */
const emit = defineEmits(['success']) // 定义 success 事件，用于操作成功后的回调
const submitForm = async () => {
  // 校验表单
  await formRef.value.validate()
  // 提交请求
  formLoading.value = true
  try {
    const data = formData.value as unknown as ArticlesVO
    if (formType.value === 'create') {
      await ArticlesApi.createArticles(data)
      message.success(t('common.createSuccess'))
    } else {
      await ArticlesApi.updateArticles(data)
      message.success(t('common.updateSuccess'))
    }
    dialogVisible.value = false
    // 发送操作成功的事件
    emit('success')
  } finally {
    formLoading.value = false
  }
}

/** 重置表单 */
const resetForm = () => {
  formData.value = {
    id: undefined,
    title: undefined,
    articleId: undefined,
    content: undefined,
    publishDate: undefined,
    authorId: undefined,
    sourcePlatform: undefined,
  }
  formRef.value?.resetFields()
}
</script>