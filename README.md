# Slim Slurm
A very lightweight job scheduler for personal use. It is designed to do the following:
- allow queuing up jobs
- notify when jobs complete (or fail)
- create jobs on separate git branches so I know exactly what code was used for an experiment

It is called Slim Slurm as a play on the real jobs scheduler [Slurm](https://slurm.schedmd.com/quickstart.html). Also, the name reminds me of Slim and Slam, an excellent jazz duo from the 1930s and 40s. I encourage you to listen to https://www.youtube.com/watch?v=zv6R3G3gvVA while getting set up.

## Set-Up

0. **Install dependencies.** Assuming you already have Python (and Git), just do `pip install knockknock`

1. **Configure job directory.** Set `JOBS_DIR` to be the folder you want Slim Slurm to work out of.

2. **Set up notifications.** Notifications are currently via Discord, so you'll need to set the `DISCORD_WEBHOOK_URL`. See [the Discord documentation](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) for info on how to set up the Discord side. I just have a personal server with a channel for job notifications. However, [`knockknock`](https://pypi.org/project/knockknock/) is a wonderful package with many other ways of doing notifications.

3. **Start the jobs runner.** Run `./run_jobs.bash &` to start a background process which will check your jobs folder for new files indicating jobs to be run. 

## Usage

From a git repo, run `./add_job.bash` to add a job to the queue. Watch your notifications and hope for the best! You can check `JOBS_DIR/to_run` to see what still needs to be run.

## Development

This is mostly public so I can give it to some friends/collaborators. If you somehow find this you're welcome to submit issues and PRs though!
