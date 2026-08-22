# AI-Agent-Test

## 用途

測試 ChatGPT + GitHub + Codex + Qwen3.6-27B 的本地 AI Coding Agent 工作流程。

驗證 AI Agent 能否在以下完整流程中正確執行任務：

1. **需求分析** — ChatGPT 上游提供規格
2. **版本控制** — GitHub 作為 Source of Truth
3. **本地實作** — Codex Agent 接收任務並實際執行
4. **程式碼推理** — Qwen3.6-27B (Ollama) 進行 coding reasoning
5. **工具操作** — Windows PowerShell / Python / Git / File Operations
6. **測試驗證** — pytest 單元測試全數通過
7. **Git 整合** — diff / status / commit 規範遵循

## 目前環境

| 項目 | 值 |
|---|---|
| OS | Windows 11 |
| Python | 3.13.15 |
| Ollama Model | qwen3.6:27b-q4_K_M |
| Context Window | 32768 tokens |
| Agent | Codex (Local) |
| Git | Included with Windows |
| GitHub | Wuaze0624/AI-Agent-Test |

## 工作流程

`
ChatGPT (上游規格/架構規劃)
    ↓
GitHub (版本控制 / Source of Truth)
    ↓
Codex Agent (本地實作 / 工具操作)
    ↓
Qwen3.6-27B (Ollama, coding reasoning)
    ↓
Windows Tools (PowerShell / Python / Git / File Operations)
    ↓
Testing (pytest 驗證)
    ↓
Git (diff → status → commit → push)
    ↓
GitHub (合併到 main)
`

## 測試矩陣

| 測試類別 | 狀態 | 說明 |
|---|---|---|
| 檔案操作 | ✅ | Agent 能正確建立/讀取/修改檔案 |
| 程式碼生成 | ✅ | Calculator 模組生成與測試 |
| 除錯能力 | ✅ | system_info.py bug 修復 |
| Git 工作流 | ✅ | branch / diff / status 規範遵循 |
| 工具鏈整合 | ✅ | Ollama → Python → pytest → Git 完整流程 |
| 指令遵循 | ✅ | 不修改禁止檔案、不 commit、不 push |

## 分支策略

| 分支 | 用途 |
|---|---|
| main | 穩定版本，保持可執行狀態 |
| eature/* | 新功能開發 |
| ix/* | Bug 修復 |
| efactor/* | 程式碼重構 |
| 	est/* | 測試相關變更 |

## Commit 規範

使用 Conventional Commits：

- eat: — 新功能
- ix: — Bug 修復
- efactor: — 重構
- 	est: — 測試
- docs: — 文件
- chore: — 維護
