# Automated Scheduling Guide

Set up automatic execution of the Windows System Cleanup Tool using Windows Task Scheduler.

## Step-by-Step Setup

### Step 1: Open Task Scheduler
1. Press **Windows + R**
2. Type `taskschd.msc`
3. Press **Enter**

### Step 2: Create New Task
1. In the right panel, click **"Create Task"**
2. Name: `PC Auto Cleanup`

### Step 3: General Tab Settings
- ☑️ **Run whether user is logged on or not**
- ☑️ **Run with highest privileges**
- **Configure for:** Windows 10 or Windows 11

### Step 4: Triggers Tab
1. Click **"New"**
2. **Begin the task:** On a schedule
3. **Settings:** 
   - ☑️ **Daily**
   - **Recur every:** **15** days
4. **Advanced settings:**
   - ☑️ **Synchronize across time zones** (Recommended for travelers)
   - ☑️ **Enabled**

### Step 5: Actions Tab
1. Click **"New"**
2. **Action:** Start a program
3. **Program/script:** 
C:\Path\To\Your\SuperCleanup.bat

text
*(Replace with the actual path to your batch file)*
4. **Start in (optional):**
C:\Path\To\Your\

text

### Step 6: Conditions Tab
- ☐ **UNCHECK** "Start the task only if the computer is on AC power"
- ☐ **UNCHECK** "Stop if the computer switches to battery power"
- ☑️ **CHECK** "Start only if the following network connection is available: Any connection"

### Step 7: Settings Tab
- ☑️ **"Allow task to be run on demand"**
- ☑️ **"Run task as soon as possible after a scheduled start is missed"**
- ☑️ **"If the task fails, restart every:** 5 minutes"

### Step 8: Save
1. Click **OK**
2. Enter your Windows password if prompted

## Testing the Scheduled Task

1. In Task Scheduler, find your **"PC Auto Cleanup"** task
2. **Right-click → Run**
3. The command window should flash briefly

## Checking Next Run Time

- View the **"Next Run Time"** column in Task Scheduler
- Or run in Command Prompt:
```cmd
schtasks /query /tn "PC Auto Cleanup" /fo list
Notes
The task will run automatically every 15 days

If PC is off, it runs at the next startup

No user interruption during execution

Runs in background with admin privileges
