# Start or Resume Work Session

Initiate a new work session or resume an existing one based on the provided parameter.

**Parameter:** $ARGUMENTS (optional - can be a WORK file, issue tracker URL, or description)

## Instructions:

### 1. Parse the Parameter

Analyze $ARGUMENTS to determine the type of input:

#### A. If parameter matches `WORK-*.org` or `work/WORK-*.org`:
- **Action**: Resume existing work
- Read the specified WORK file from ./work/ directory
- Display the Objective and current Tasks status
- Continue work on incomplete tasks
- Update the Work Log with session resume timestamp

#### B. If parameter is a URL (JIRA, GitHub Issue, Linear, etc.):
- **Action**: Create new WORK file from issue
- Use WebFetch to retrieve issue details:
  - Title/Summary
  - Description
  - Acceptance criteria
  - Related context
- Extract ticket ID from URL (e.g., PROJ-123, #456)
- Create new file: `work/WORK-[brief-description]-[ticket-id].org`
- Populate from template with:
  - Objective from issue summary
  - Context from issue description
  - Link to issue in properties
  - Initial task list based on acceptance criteria
- Ask user to review and confirm before starting

#### C. If parameter is a text description:
- **Action**: Create new WORK file from description
- Check if description matches any existing work in:
  - WORK.org active sessions
  - Existing work/*.org files
- If no match found:
  - Create new file: `work/WORK-[sanitized-description]-[timestamp].org`
  - Use description as initial Objective
  - Prompt user for:
    - More detailed objective (if needed)
    - Context and background
    - Initial task breakdown
  - Populate template with provided information

### 2. Handle No Parameter Case

If $ARGUMENTS is empty:

#### A. Check recent conversation context:
- If current conversation discusses a specific task/feature:
  - Summarize understood objective
  - Ask user to confirm: "Should I start work on [summarized task]?"
  - If confirmed, create new WORK file with:
    - Objective from conversation
    - Tasks from discussed plan (if any)
    - Context from conversation history

#### B. If no clear task in context:
- Prompt user: "What would you like to work on? Please provide:
  - A WORK file name to resume
  - An issue tracker URL
  - A description of the new task"
- Wait for user input and process according to type

### 3. Initialize Work Session

Once WORK file is identified or created:

1. **Display session info**:
   ```
   Starting work session: WORK-[description]
   Objective: [objective text]
   Tasks: [X completed / Y total]
   ```

2. **Set up tracking**:
   - Add entry to Work Log: `** <[timestamp]> Session started/resumed`
   - Ensure WORK.org has reference to this session
   - Mark first incomplete task as current focus

3. **Begin work**:
   - Read all Rules from the WORK file
   - Apply any project-specific context
   - Start working on first incomplete task
   - Use TodoWrite tool to track subtasks if complex

### 4. File Creation Details

When creating new WORK files:
- Use timestamp format: YYYYMMDD (e.g., 20250824)
- Sanitize descriptions: lowercase, hyphens for spaces, remove special chars
- Always preserve the template structure
- Set initial task: `- [ ] Check this off to confirm you've read the project and understand the rules`

### 5. Error Handling

- If WORK file not found: List available work files and ask user to choose
- If URL fetch fails: Ask user to provide objective and context manually
- If multiple matches found: Show list and ask user to specify

## Expected Behavior:

- Seamless transition into work mode with clear objective
- Proper work file creation/resumption
- Context loaded from existing work or external issues
- User confirmation when creating new work from limited info
- TodoWrite integration for complex task tracking