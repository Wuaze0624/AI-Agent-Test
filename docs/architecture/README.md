# 架構說明

## 工作流程

`
User
↓
ChatGPT Architect
↓
GitHub
↓
Codex Agent
↓
Devstral
↓
Tools
├── exec_command
├── PowerShell
├── Python
├── Git
├── File Operations
└── CodeGraph
↓
Testing
↓
Git Commit
↓
GitHub
`

## 角色分工

### ChatGPT

負責高階規劃與程式架構。

### Codex Agent

負責本地實作與工具操作。

### Devstral

負責 coding reasoning。

### GitHub

負責版本控制與共享專案狀態。
