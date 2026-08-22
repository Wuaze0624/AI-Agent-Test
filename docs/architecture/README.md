# 架構說明

## 工作流程

`
User (需求描述)
    ↓
ChatGPT Architect (高階規劃 / 規格定義)
    ↓
GitHub (版本控制 / Source of Truth)
    ↓
Codex Agent (本地實作 / 工具操作)
    ↓
Qwen3.6-27B (Ollama, coding reasoning)
    ↓
Tools
├── exec_command (PowerShell)
├── Python (實作程式碼)
├── Git (版本控制)
├── File Operations (讀取/建立/修改檔案)
└── CodeGraph (程式碼探索)
    ↓
Testing (pytest 驗證)
    ↓
Git Commit (Conventional Commits)
    ↓
GitHub (push / merge to main)
`

## 角色分工

### ChatGPT (上游)

負責高階規劃與程式架構。

提供：
- Implementation Specification
- Architecture Plan
- Task Specification
- GitHub Issue

### Codex Agent (本地實作)

負責接收任務並實際執行：
- 探索本地 repository
- 理解現有架構
- 建立/修改檔案
- 執行測試
- Git 操作

### Qwen3.6-27B (Ollama)

負責 coding reasoning。

- 模型：qwen3.6:27b-q4_K_M
- Context Window：32768 tokens
- 推理平台：Ollama (本地)

### GitHub

負責版本控制與共享專案狀態。

- 遠端 Source of Truth
- main 分支保持可用
- 功能開發使用 feature branch
- 測試通過後合併

## 環境配置

| 項目 | 值 |
|---|---|
| OS | Windows 11 |
| Python | 3.13.15 |
| Ollama Model | qwen3.6:27b-q4_K_M |
| Agent | Codex (Local) |
| Shell | PowerShell |
| Test Framework | pytest |
