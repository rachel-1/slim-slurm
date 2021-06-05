#!/bin/bash

# Get the name of the current folder and check if it is a git repo.
REPO_NAME=${PWD##*/}
if [ ! -d .git ]; then
    echo "The current directory is not a git repo!"
    REPO_NAME=""
fi

# Set up folder names (use environment variable JOBS_DIR to set top-level dir).
if [ -z $JOBS_DIR ]; then
    echo "No jobs directory set! Please set the JOBS_DIR environment variable."
    exit
fi
# Note: if these names are changed, they must be updated in run_jobs.bash too.
TO_RUN="$JOBS_DIR/to_run"
RUNNING="$JOBS_DIR/running"
WORK_TREES="$JOBS_DIR/work_trees"

# Create the folders if they don't exist yet.
[ ! -d "$JOBS_DIR" ] && mkdir $JOBS_DIR
[ ! -d "$TO_RUN" ] && mkdir $TO_RUN
[ ! -d "$RUNNING" ] && mkdir $RUNNING
[ ! -d "$WORK_TREES" ] && mkdir $WORK_TREES

# Create the worktree for the current repo if needed.
if [ ! -d "$WORK_TREES/$REPO_NAME" ]; then
    git worktree add --detach "$WORK_TREES/$REPO_NAME"
fi

# Get the information for the job.
read -p "Job name (no spaces): " JOB_NAME
read -p "Command: " COMMAND

# Save the current code state.
if [ $REPO_NAME ]; then

    # Print where we're at, just for clarity.
    git status

    # Save the current branch.
    BRANCH=$(git branch --show-current)
    
    # Save our local changes (if needed).
    git stash save -- "$JOB_NAME"

    # Attempt to create a new branch, exiting if it already exists.
    git checkout -b "experiment_$JOB_NAME" --quiet || exit

    # Commit any changes.
    git stash list | grep $JOB_NAME && git stash apply --quiet && echo "Applying stashed changes to branch"
    git add -u
    git commit -m "Saving changes to run $JOB_NAME"
    
    #Save the commit SHA so we can save it to our job file.
    SHA=$(git rev-parse HEAD)

    # Go back to previous state.
    git checkout $BRANCH
    git stash list | grep $JOB_NAME && git stash pop --quiet && echo "Reapplying stashed changes"

    # Print where we're at, just for clarity.
    git status
    
else
    # If we aren't in a git repo, we put a placeholder.
    SHA=""
fi

# Save the job info to a file.
echo "repo: $REPO_NAME"$'\n' > "$TO_RUN/$JOB_NAME.job"
echo "SHA: $SHA"$'\n' >> "$TO_RUN/$JOB_NAME.job"
echo "cmd: $COMMAND"$'\n' >> "$TO_RUN/$JOB_NAME.job"

echo "$JOB_NAME successfully created in $TO_RUN!"
