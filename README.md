# dev-agent-work

A proof-of-concept org-mode based work session tracking system for development agents like Claude Code, Cursor, and other AI coding assistants.

## Overview

This project provides a structured, local filesystem approach to tracking development work sessions that maintains continuity between AI agent interactions. It uses org-mode files to create work session "memory" that allows agents to resume work while maintaining compatibility with external issue tracking systems like JIRA, GitHub Issues, or Linear.

Currently only supports Claude Code. Pull requests for other dev agents welcome.

## Purpose

I wanted a way to track work locally and do so in a way that would allow "cold" restarts or passing the work between colleagues or coworkers. Org-mode was chosen due to its advanced work tracking features and because, well, I tend to work in emacs.

## Structure

```
.
├── WORK.org                    # Central hub listing all work sessions
├── work/
│   ├── WORK-template.org      # Template for new work sessions
│   └── WORK-*.org             # Individual work session files
├── .claude/
│   └── agents/
│       ├── work-manager.md    # Sub-agent to manage the work files
│   └── commands/
│       ├── work-start.md      # Start/resume work sessions
│       └── work-summarize.md  # Summarize and update sessions
│       └── work-sync.md       # Sync WORK.org and any remote issue tracker
└── AGENTS.md                  # Instructions for AI agents
```

## Work File Format

Each `WORK-*.org` file contains:

- **Objective**: Clear 2-3 sentence goal statement
- **Context**: Project-specific background and references
- **Rules**: Guidelines that override general agent instructions
- **Tasks**: Checkbox list (`- [ ]`) tracking progress
- **Work Log**: Timestamped journal of actions and decisions

## Available Slash Commands

### `/work-start [parameter]`
Initiates or resumes a work session:
- No parameter: Prompts for work description or infers from context
- `WORK-*.org`: Resumes existing work file
- Issue URL: Creates work file from JIRA/GitHub issue
- Text description: Creates new work file with that objective

### `/work-sync [work-file]`
Synchronizes work session with issue trackers:
- Updates issue tracker with work progress (using MCP tools, CLI, or APIs)
- Syncs status between local work file and remote issue
- Updates WORK.org with current session status
- Handles authentication and provides setup guidance

### `/work-summarize [work-file]`
Updates work tracking:
- Marks completed tasks
- Adds comprehensive work log entry
- Updates WORK.org with session status
- Captures lessons learned

## Usage Workflow

1. **Start Work**: 
   ```
   /work-start "implement user authentication"
   # or
   /work-start https://github.com/org/repo/issues/123
   # or
   /work-start WORK-auth-20250824.org
   ```

2. **During Work**:
   - Agent reads work file for context
   - Updates task checkboxes as progress is made
   - Adds work log entries for significant actions
   - Commits after each completed task

3. **End Session**:
   ```
   /work-summarize
   ```

4. **Resume Later**:
   ```
   /work-start WORK-auth-20250824.org
   ```

## Integration with Issue Trackers

While work happens locally, the system maintains bidirectional awareness:
- Import objectives and context from issue URLs
- Track issue IDs in file properties
- Update tickets can be done manually with work log summaries
- Local work files provide more detail than typical ticket comments

## Installing

Use the supplied `init-project.sh` to copy files to a new project directory:

``` sh
  $ init-project.sh ~/dev/my-new-project 
```


## Status

This is a **proof of concept** exploring how structured work tracking can enhance AI-assisted development. Feedback and contributions are welcome.

## Similar Projects

- [AGENTS.md](https://agents.md) - High-level agent guidelines specification
- Various `.cursorrules` and `CLAUDE.md` patterns in the community

## License

Apache 2 - See LICENSE file for details

## Contributing

This is an experimental concept. Feel free to:
- Open issues with feedback or suggestions
- Fork and adapt for your workflow
- Share your experiences using similar approaches

