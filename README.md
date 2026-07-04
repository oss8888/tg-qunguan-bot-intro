# TG 群管机器人 · 功能介绍（GitHub Pages）

静态功能介绍页，由根目录 `index.html` 提供（源文件为上级目录的 `功能介绍.html`）。

## 发布到 GitHub Pages

1. 在 [GitHub 新建仓库](https://github.com/new)（建议公开），例如：`tg-qunguan-bot-intro`，**不要**勾选「Add a README」。
2. 在本目录执行（将 `你的用户名` 和仓库名替换为实际值）：

```powershell
git remote add origin https://github.com/你的用户名/tg-qunguan-bot-intro.git
git branch -M main
git push -u origin main
```

3. 打开仓库 **Settings → Pages**：
   - **Source**：Deploy from a branch
   - **Branch**：`main`，文件夹 **`/ (root)`**
   - 保存后等待 1～3 分钟

4. 访问地址一般为：

`https://你的用户名.github.io/tg-qunguan-bot-intro/`

## 更新页面

修改上级目录的 `功能介绍.html` 后，复制并推送：

```powershell
Copy-Item -Force "..\功能介绍.html" ".\index.html"
git add index.html
git commit -m "更新功能介绍页：最近更新板块"
git push
```

或直接运行 `./publish.ps1` 自动复制并推送。
