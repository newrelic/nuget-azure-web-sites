Log files will be generated in this folder.

The agent generates its own log file to keep its logging information separate from that of your application. Specify its log level here. 
Choices are from the enumeration (in any case): off, emergency, fatal, alert, critical, severe, error, warn, notice, info, debug, fine, trace, finer, verbose, finest, all.

Please note for Windows Azure Web Sites the default logging level is set to off because users typically do not have direct access to pull the logs down once the site has been deployed.