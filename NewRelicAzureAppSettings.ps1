Param(
  [string]$appName
)

azure site config add "COR_ENABLE_PROFILING=1" $appName
azure site config add "COR_PROFILER={71DA0A04-7777-4EC6-9643-7D28B46A8A41}" $appName
azure site config add "COR_PROFILER_PATH=C:\Home\site\wwwroot\newrelic\NewRelic.Profiler.dll" $appName
azure site config add "NEWRELIC_HOME=C:\Home\site\wwwroot\newrelic" $appName
