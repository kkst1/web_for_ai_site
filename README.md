# 十三的AI聚集站

这是一个可部署到 Netlify 的静态站点，前端直接连接 Supabase。任何访问者新增、删除、拖拽排序后，数据都会写入共享数据库，其他人刷新页面后能看到最新内容。

## 1. 创建 Supabase 项目

1. 在 Supabase 控制台创建一个新项目。
2. 打开 SQL Editor。
3. 执行 [supabase.sql](/home/kkst/web-ai/supabase.sql) 里的 SQL。

## 2. 获取公开配置

在 Supabase 项目的 `Settings -> API` 页面找到：

- `Project URL`
- `anon public` key

这两个值是给前端公开使用的，但必须配合当前仓库里的 RLS 策略一起使用。

## 3. 配置 Netlify

在 Netlify 部署这个仓库时，设置两个环境变量：

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

构建配置已经写在 [netlify.toml](/home/kkst/web-ai/netlify.toml)：

- Build command: `npm run build`
- Publish directory: `dist`

## 4. 本地预览

可以先手动生成配置再启动本地静态服务：

```bash
SUPABASE_URL=你的项目URL SUPABASE_ANON_KEY=你的匿名Key npm run build
```

生成后的页面文件在 `dist/`。

## 5. 风险说明

当前策略允许匿名访问者直接新增、删除、修改排序，适合开放式共享收录站。

如果你后面要防止恶意删除、垃圾提交，下一步应该加：

- 登录鉴权
- 提交频率限制
- 审核机制
- 仅管理员可删除
