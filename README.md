# DSH Windows 启动器 🐳

给 **Windows 用户** 用的 DeepSeek Harness（DSH）Web 一键启动 / 停止小工具。

双击 `Start-DSH.bat` → 后台静默启动 `dsh web` → 自动用浏览器打开 `http://127.0.0.1:3080`；
用完双击 `Stop-DSH.bat` → 精确按端口结束 dsh 进程，干净利落。

附带两只小虎鲸图标：**「来了老板」**（启动）和 **「臣妾告退」**（停止）。

---

## 为什么需要它

- 直接在桌面双击就能起 DSH Web，不用每次敲命令行。
- 启动器用 `Start-Process -WindowStyle Hidden` **完全脱离进程树**后台运行：你关掉启动器窗口、甚至误关浏览器，**都不会杀掉 dsh 服务**（这是踩了无数坑换来的稳定方案）。
- 停止器按端口 `3080` 精确定位 dsh 进程，不会误伤其他程序。

---

## 前置条件

1. 已安装 [Node.js](https://nodejs.org/)（建议 LTS）。
2. 已全局安装 DSH：
   ```powershell
   npm install -g @deepseek-ai/dsh
   ```
3. 默认端口 `3080` 未被占用。

---

## 使用步骤

1. 把下面 4 个文件放同一个文件夹：
   - `Start-DSH.bat`
   - `Stop-DSH.bat`
   - `start-dsh.ico`（启动图标 · 来了老板）
   - `stop-dsh.ico`（停止图标 · 臣妾告退）
2. （可选，更顺手）右键 `Start-DSH.bat` → **发送到 → 桌面快捷方式**；
   右键该快捷方式 → **属性 → 更改图标 → 浏览** 选 `start-dsh.ico`；
   `Stop-DSH.bat` 同理用 `stop-dsh.ico`。
3. 双击 **Start-DSH** 启动；用完双击 **Stop-DSH** 停止。
4. 小技巧：快捷方式可以随便改名（比如改成「来了老板」），**改名不影响原 bat 文件**。

---

## 自定义

用记事本打开 `Start-DSH.bat`，顶部两个变量按需修改：

| 变量 | 说明 | 默认 |
| --- | --- | --- |
| `WORK_DIR` | dsh 配置 / 会话存放目录 | `%USERPROFILE%\DSH-Workspace` |
| `DSH` | dsh 可执行文件路径（一般无需改，脚本会自动探测） | 自动 |

> 脚本会先 `where dsh.cmd` 探测，找不到再回退到 npm 全局默认位置；双击 `.bat` 时 PATH 可能不含 npm，所以脚本已自动把 npm 目录补进 PATH。

---

## 图标说明

启动图标用「来了老板」、停止图标用「臣妾告退」——作者自制的**小虎鲸表情**，
可随本工具自由使用。想换成自己的图，直接替换 `start-dsh.ico` / `stop-dsh.ico` 即可（多分辨率 ICO，推荐 256×256）。

---

## 免责声明

- 本仓库 **仅提供 Windows 启动 / 停止脚本与图标**，**不包含任何 DSH 插件**。
- DeepSeek Harness 及其中文 / 社区插件均为 DeepSeek 及各自作者所有，请遵守其许可证。
- 图标版权归本仓库作者所有，仅授权随本工具使用。

---

## 许可证

代码以 [MIT](LICENSE) 许可证开源；图标除外（见上「图标说明」）。
