REM invoke with a reference to [the directory containing the] jet-composites.json as first command line parameter
REM and a reference to the root directory of the target project as a second parameter
REM
REM for example:   .\jwcm C:\oow2018\jet-web-components\2018-jet-composite-component-consumer\src\js\jet-composites\jet-composites.json C:\oow2018\jet-web-components\2018-jet-composite-component-consumer
REM for example:   .\jwcm C:\oow2018\jet-web-components\2018-jet-composite-component-consumer\src\js\jet-composites\jet-composites.json C:\oow2018\jet-web-components\oow-demo
set GITHUB_TOKEN=<your token>
node jwcm.js %1 %2