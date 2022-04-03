# Win-Tautulli-autoupdater
PowerShell script to pull and install new version of Tautulli if one is available

# Initial Script Setup
You will want to modifythe following categories
  1. ```$APIKey``` will need to be the API key for your specific ```Tautulli``` application.
  2. ```$TautulliDir``` will point to where your ```Tautulli``` application resides.
  3. ```$TautulliURL``` is your specific host location, or you can just leave the default ```http://localhost:8181```.
  4. ```$UpdaterPath``` this will be the directory that the new ```Tautulli``` version downloads into.
  5. ```$Filename``` you can leave this alone if you are updating in a 64-bit version of Windows.
  6. At ```line 49``` you will want to change the logging output of your transcript.

# Run options:
  1. MANUALLY:  you can choose to run this manually whenever you notice a new version is available.
  2. SCHEDULED:  you can opt to set this is up with a time/date trigger in Task Scheduler (this is how I currently have mine - Monthly)
  3. RESPONSIVE:  you can set up a continuous monitor of the webpage to download the new version as soon as it becomes available (not recommended)

