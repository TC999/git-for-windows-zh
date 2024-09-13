# 自动化生成并发布 git-for-windows 的中文语言文件

本项目旨在自动化生成`git-for-windows`的中文语言文件，并在上游仓库发布新版本时，将生成的语言文件发布到本仓库的 Releases 中。

## 功能简介

- **自动检测上游仓库的新版本**：每天定时检查`git-for-windows/git`仓库是否有新版本发布。
- **自动发布语言文件**：在检测到新版本后，自动下载源代码并生成对应版本的中文语言文件，并以 Release 的形式发布到本仓库。

## 语言文件的使用方式

生成的中文语言文件可用于为`git-for-windows`添加中文支持。按照以下步骤，您可以轻松安装和使用语言文件。

### **方法一：使用一键脚本自动安装**

为了简化安装过程，您可以使用我们提供的一键安装脚本，自动完成语言文件的下载、安装和配置。

#### **步骤一：以管理员身份运行 PowerShell**

1. 点击开始菜单，搜索“**Windows PowerShell**”。
2. 右键点击“Windows PowerShell”，选择“**以管理员身份运行**”。

#### **步骤二：执行一键安装命令**

在 PowerShell 窗口中，复制并粘贴以下命令，然后按回车键执行：

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/zkl2333/git-for-windows-zh/main/apply_git_language_pack.ps1" -OutFile "$env:TEMP\apply_git_language_pack.ps1"; PowerShell -ExecutionPolicy Bypass -File "$env:TEMP\apply_git_language_pack.ps1"; Remove-Item -Path "$env:TEMP\apply_git_language_pack.ps1" -Force
```

#### **说明**

- **自动化过程**：该命令将自动执行以下操作：

  - 从 GitHub 仓库下载最新的安装脚本`apply_git_language_pack.ps1`。
  - 运行安装脚本，自动检测您已安装的 Git 版本，下载对应的中文语言文件，并完成安装和配置。
  - 清理临时文件。

- **执行策略**：`-ExecutionPolicy Bypass`参数用于临时绕过 PowerShell 的执行策略，仅对当前命令有效，确保脚本可以顺利运行。

- **安全提示**：在运行脚本之前，建议您查看脚本内容，确保其安全可靠。您可以在浏览器中打开以下链接查看脚本源代码：

  ```
  https://github.com/zkl2333/git-for-windows-zh/blob/main/apply_git_language_pack.ps1
  ```

#### **步骤三：重启 Git Bash 并验证**

1. **重启 Git Bash**

   关闭所有打开的 Git Bash 窗口，然后重新打开。

2. **验证语言文件是否生效**

   在 Git Bash 中运行以下命令：

   ```bash
   git status
   ```

   如果输出信息为中文，说明语言文件已成功安装并配置。

### **方法二：手动安装语言文件**

#### **步骤一：下载语言文件**

1. **访问 Releases 页面**

   前往本仓库的[Releases](https://github.com/zkl2333/git-for-windows-zh/releases)页面。

2. **选择与您的`git-for-windows`相同版本**

   查找与您的`git-for-windows`相同的版本，点击进入该 Release 页面。

3. **下载语言文件**

   在“Assets”部分，下载对应版本的语言文件 ZIP 文件，例如：

   ```
   build-2.42.0.windows.1.zip
   ```

#### **步骤二：解压语言文件**

1. **解压 ZIP 文件**

   将下载的 ZIP 文件解压到一个临时目录，例如`C:\Temp\git-lang-pack`。

2. **查看解压后的文件**

   解压后，您将看到一个`mingw64`文件夹，里面包含了需要的语言文件。

#### **步骤三：安装语言文件**

1. **定位 Git 安装目录**

   通常，`git-for-windows`的默认安装目录是：

   ```
   C:\Program Files\Git
   ```

   如果您在安装时更改了路径，请根据实际情况找到您的 Git 安装目录。

2. **备份原始文件（可选）**

   为了防止意外，建议备份 Git 安装目录下的`mingw64`文件夹，或至少备份即将被替换的文件。

3. **复制语言文件**

   - 将解压后的`mingw64`文件夹复制到 Git 的安装目录中。
   - 如果系统提示存在同名文件，选择“替换目标中的文件”。
   - 这将把语言文件复制到正确的位置，覆盖原有的文件。

#### **步骤四：配置 Git 使用中文**

1. **设置环境变量**

   为了让 Git 识别中文语言文件，需要设置`LANG`环境变量。

   - **方法一：临时设置**

     在每次使用 Git Bash 时，运行以下命令：

     ```bash
     export LANG=zh_CN.UTF-8
     ```

     这种方法只在当前会话有效。

   - **方法二：永久设置**

     - **Windows 10/11**

       1. 右键点击“此电脑”或“我的电脑”，选择“属性”。
       2. 点击“高级系统设置”。
       3. 在“高级”选项卡中，点击“环境变量”。
       4. 在“用户变量”或“系统变量”中，点击“新建”。
       5. 输入以下内容：

          - **变量名**：`LANG`
          - **变量值**：`zh_CN.UTF-8`

       6. 点击“确定”保存。

     - **注意**：设置为系统变量将对所有用户生效，设置为用户变量则仅对当前用户生效。

2. **配置 Git 编码**

   在 Git Bash 中运行以下命令，配置 Git 的编码设置：

   ```bash
   git config --global core.quotepath false
   git config --global gui.encoding utf-8
   git config --global i18n.commitencoding utf-8
   git config --global i18n.logoutputencoding utf-8
   ```

#### **步骤五：验证语言文件是否生效**

1. **重启 Git Bash**

   关闭并重新打开 Git Bash，以确保环境变量和配置生效。

2. **运行 Git 命令**

   运行以下命令，查看输出是否为中文：

   ```bash
   git status
   ```

   如果输出信息为中文，说明语言文件已成功安装并配置。

### **常见问题**

- **输出仍为英文？**

  - 确认`LANG`环境变量已正确设置为`zh_CN.UTF-8`。
  - 确认语言文件已正确安装。
  - 重启 Git Bash 或重新登录系统以确保设置生效。

- **出现乱码或显示异常？**

  - 确认 Git 配置的编码为`utf-8`。
  - 运行以下命令设置编码：

    ```bash
    git config --global core.quotepath false
    git config --global gui.encoding utf-8
    git config --global i18n.commitencoding utf-8
    git config --global i18n.logoutputencoding utf-8
    ```

- **想恢复为英文界面？**

  - 删除或重命名 Git 安装目录中的`mingw64/share/locale/zh_CN`文件夹。
  - 删除或修改`LANG`环境变量，设置为`en_US.UTF-8`或直接删除。

### **注意事项**

- **版本匹配**

  - 请确保下载的语言文件版本与您安装的`git-for-windows`版本完全一致。版本不匹配可能导致无法正常显示或其他问题。

- **备份**

  - 在替换文件之前，备份原始的`mingw64`文件夹或相关文件，以便在出现问题时可以恢复。

- **更新**

  - 当`git-for-windows`发布新版本时，请重新下载并安装对应的新版本语言文件。

### **卸载语言文件**

如果您需要卸载语言文件，恢复 Git 的默认语言，按照以下步骤操作：

1. **删除语言文件**

   删除以下文件，以移除已安装的中文语言文件：

   - `C:\Program Files\Git\mingw64\share\locale\zh_CN\LC_MESSAGES\git.mo`
   - `C:\Program Files\Git\mingw64\share\git-gui\lib\msgs\zh_cn.msg`
   - `C:\Program Files\Git\mingw64\share\gitk\lib\msgs\zh_cn.msg`

   **注意**：如果您的 Git 安装目录不是默认的`C:\Program Files\Git`，请根据实际情况调整路径。

2. **删除环境变量**

   - 删除或修改`LANG`环境变量，将其值设置为`en_US.UTF-8`或直接删除。

3. **重启 Git Bash**

   - 关闭并重新打开 Git Bash，验证 Git 输出已恢复为英文。

---

通过以上步骤，您就可以在`git-for-windows`中使用中文语言文件，享受更友好的中文界面。如有任何疑问或问题，欢迎在本仓库提交 Issue，我们将尽快协助您解决。

## 贡献指南

欢迎提交 Issue 和 Pull Request 来改进本项目。在提交代码前，请确保通过了所有测试，并遵循项目的代码规范。

## 许可证

本项目采用 MIT 许可证。详情请参阅[LICENSE](LICENSE)文件。

## 致谢

- 感谢`git-for-windows/git`项目提供的源代码。
- 感谢`toyobayashi/git-zh`项目提供的语言文件编译代码。
- 感谢 GitHub Actions 社区提供的优秀工具。
