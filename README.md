# oracle-jet-web-component-manager
The Oracle JET WebComponent Manager is a utility - somewhat similar to npm - that is used for quickly installing and updating JET WebComponents from GIT repositories and for live loading and refreshing at runtime.

This repo contains two sections. One for the design time JWCM - the JET WebComponent Manager - and one for the deployment and run time JET WebComponent Reloader.

Both these facilities use a configuration file as their source of truth. The default name and location for this file is jet-composites.json in the /js/jet-composites fold in your JET Application. At design time (for JWCM) you could use a different name and location.

This file specifies which JET WebComponents are part of your JET application and indicate where (in which HitHub Repo) these components are located. JET Web Components are defined by name (which will be reflected in the directory name in your JET Application under /js/jet-composites/ ), the GIT HUB source repo (and a specific component path if it deviates from src/js/jet-composites/) and possibly the live endpoint (the URL where the JET Web Component should be retrieved from):

```
[
    {
        "name": "demo-zoo",
        "github": {
            "owner": "lucasjellema",
            "repo": "jet-composite-component-showroom",
            "branch": "master"
        },
        "phase": "design",
        "documentation": "http://www.oracle.com/webfolder/technetwork/jet/jetCookbook.html?component=composite&demo=arrays"
    },
    {
        "name": "cards",
        "github": {
            "owner": "lucasjellema",
            "repo": "jet-composite-component-showroom",
            "branch": "master",
            "componentPath": "src/js/jet-composites/demo-card"
        },
        "phase": "design",
        "documentation": "https://www.oracle.com/webfolder/technetwork/jet/jetCookbook.html?component=composite&demo=basic"
    },
    {
        "name": "input-country",
        "github": {
            "owner": "lucasjellema",
            "repo": "jet-composite-component-showroom"
        },
        "phase": "run",
        "live-endpoint": "http://127.0.0.1:3100/jet-composites/input-country",
        "annotation" : "this JET WebComponent is not used from the sources bundled in the JET application but instead retrieved at runtime from the live-endpoint. If that endpoint is not accessible, the component will not load. Note: here is a way to mash up the UIs from various microservices at run time"
    }
]
```


## JWCM - the JET WebComponent Manager
The JET WebComponent Manager is used to add (and update) JET WebComponents in the src directory of your JET application. You run the tool (just like npm install) to have to have it fetch all files associated with a JET WebComponent and install them locally in the correct folder (src/js/jet-composites/<name of component>). 

To run the JET WebComponent Manager tool use jwcm.bat or jwcm.sh with two command line parameters:

* a reference to [the directory containing the] jet-composites.json as first command line parameter (default is the file jet-composites.json in the current directory or in the /src/js/jet-composites directory under the current directory)
* a reference to the root directory of the target project (default is the current work directory)
For example: 
```
./jwcm C:\oow2018\jet-composites.json C:\oow2018\jet-web-components\oow-demo
```

instead of running the bat file you can also invoke with node:

```
node jwcm.js C:\oow2018\jet-web-components\oow-demo
```

To install the JWCM:
* clone the GIT repository
* run npm install (to add Node libraries required by JWCM)
* possibly add the directory that contains jwcm.bat or jwcm.sh to the PATH environment variable 

Note:
To access private GitHub repositories, you need to provide a github token; for public repo access, no authentication is required. See https://github.com/settings/tokens for details on tokens. A token is provided to JWCM either by editing the code of jwcm.js or more elegantly by setting the environment variable GITHUB_TOKEN.


## JET WebComponent Reloader
JET WebComponent (fka JET Composite Components) can be loaded at runtime from a live endpoint (instead of static resources included in the container from the GitHub repo for the JET application) or can be refreshed from a specific GITHUB repo on demand or even through a GitHub WebHook trigger.

The JETWebComponentLoader module takes care of all that. 

Note:
To access private GitHub repositories, you need to provide a github token; for public repo access, no authentication is required. See https://github.com/settings/tokens for details on tokens. A token is provided to the JETWebComponentLoader either by editing the code of JETWebComponentLoader.js or more elegantly by setting the environment variable GITHUB_TOKEN.

The basis for the actions taken by this module is the /js/jet-composites/jet-composites.json file in your JET Application. 

All JET WebComponents in the jet-composites.json file can be reloaded from their respective GitHub repo at runtime. By making a simple HTTP request to the endpoint host:port/update/<name of JET WebComponent> the JETWebComponentLoader is instructed to refetch the sources for the JET WebComponent from its GitHub Repository. This will update the JET application while it is running.

Any JET WebComponent that has a live endpoint configured in this file - and its property phase set to "run" - will have its resources fetched at runtime from the specified live-endpoint. Any change at that live endpoint is immediately reflected in the JET WebApplication that uses the JETWebComponentLoader.

In order to have WebComponents live refreshed from a GitHub WebHook trigger, you should configure such a webhook in the GitHub Repo and have it refer to the endpoint host:port/github/push in your JET Application.

### Adding JET WebComponent Reloader to your run time application
The jet-on-node directory in this repository contains a simple Node application that can serve your JET Application from its public directory. The Node application is started simply with

```
npm start
```
It runs the /bin/www script that in turn loads the app.js module that handles all requests for JET resources. This module loads the JETWebComponentLoader module that will intercept calls to /update/<component>  and /github/push as well as requests for all JET WebComponents that have a live endpoint configured.

The steps to get going now are:
* copy the jet-on-node directory from this repo to wherever you want to locate your live JET application
* copy the outcome from ojet build to the jet-on-node/public directory
* run npm start in the jet-on-node directory (that in turn runs node /bin/www)
* the JET application will start - listening at port 3000 unless the environment variable PORT has been set
