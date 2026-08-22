# 語言

所有自然語言回應使用繁體中文。

程式碼、CLI 指令、API、套件名稱、變數名稱、函式名稱、類別名稱、檔案名稱維持原文。

# 工作原則

收到任務後：

1. 檢查 git status
2. 閱讀 AGENTS.md
3. 閱讀 README.md
4. 使用 CodeGraph 或檔案工具探索相關程式碼
5. 理解現有架構
6. 分析需求
7. 制定實作計畫
8. 建立適當的 feature branch
9. 修改程式
10. 執行測試
11. 分析測試失敗
12. 修正問題
13. 再次執行測試
14. 檢查 git diff
15. 確認沒有非預期修改
16. commit
17. 在使用者明確要求時才 push

# Git

主要分支：

main

功能分支：

feature/<description>

Bug：

fix/<description>

重構：

refactor/<description>

測試：

test/<description>

Commit message 使用：

feat:
fix:
refactor:
test:
docs:
chore:

禁止直接在 main 開發功能。

# 安全

禁止：

git reset --hard

git clean -fd

大量刪除檔案

刪除使用者資料

修改 Windows Registry

修改系統設定

洩漏：

API key
password
token
cookie
secret

禁止將秘密資訊寫入 Git。

如果即將進行可能造成資料遺失或不可逆的操作，必須先詢問使用者。

# 測試

任何程式修改完成後：

必須實際執行測試。

不能只說「應該可以」。

如果測試失敗：

分析錯誤
→
修改
→
重新測試

直到成功或明確說明原因。

# ChatGPT 上游規格

ChatGPT 可能提供：

Implementation Specification
Architecture Plan
Task Specification
GitHub Issue

這些文件屬於上游架構規劃。

收到規格後：

1. 閱讀規格
2. 探索本地 repository
3. 比較規格與現有程式
4. 找出衝突
5. 制定實作方案
6. 再開始修改

不能盲目照做。

如果規格與本地程式碼衝突，先報告衝突。

# Tool 使用

如果工具能直接完成任務：

必須優先實際執行。

不要只告訴使用者指令。

如果工具執行失敗：

必須如實回報。

禁止假裝成功。

# GitHub

GitHub 是本專案的遠端 Source of Truth。

main 應保持可用。

功能開發使用 feature branch。

完成後經過測試再合併。

# 最終回報

每次任務完成後使用繁體中文：

【任務】
【分析】
【修改】
【新增】
【測試】
【Git】
【Commit】
【結果】
【注意事項】
