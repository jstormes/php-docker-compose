# Docker Compose PHP Server 

High speed low drag PHP using Docker.

I use this setup specifically with PhpStorm.

Development environment as code AKA Infrastructure as code

## Quick start

Make sure you have Docker and Docker Compose installed.

[Installing Docker on Windows 10](Documentation/01a_InstallingDockerOnWindows.md)

[YouTube: Installing Docker on Windows 10](https://youtu.be/lIkxbE_We1I)

[YouTube: Installing Docker on Ubuntu](https://youtu.be/EL1Ex04iUcA)

From the directory root of the project run `docker-compose up` open your browser to 
[http://localhost:8001](http://localhost:8001/).

To stop the Docker container, from the Docker CLI windows press [Control]-C.

## To change the PHP code

Edit the `docker-compose.yml` file changing the `/app` path appropriately, or replace the code in
`/app` with your code.

## NOTE: Filesystem across Windows and WSL2

You may need to put your project on the Linux side of WSL2 to get better performance and file permissions.

https://docs.microsoft.com/en-us/windows/wsl/compare-versions#performance-across-os-file-systems

## To change the PHP version

Stop the Docker containers.

Do a search and replace in the file `docker-compose.yml` for `php8` with `php5` or `php7`.

For PHP 5 you will need to switch from the xdebug_3.x.x.ini file to the xdebug_2.x.x.ini
file.

Then run `docker-compose build`.

Next, start the docker container by running `docker-compose up`.

## Composer

PHP Composer [https://getcomposer.org/](https://getcomposer.org/) is installed by default and can be run inside
the dev-server container with the command `composer`.

`docker exec -it dev-server bash`

user@45640a57cf9f:/app$ `composer (command)`

## SSH Keys

The current configuration will look for an SSH key in `~/.ssh/id_rsa`.

You will need to uncomment the `secrets:` section in the `docker-compose.yml` file to use your own SSH key,
without adding it to the repository.

## XDebug

XDebug is installed and configured separately for the command line (CLI) and web (HTTP).

### Command Line (CLI)

The XDebug configuration for the command line can be found in `./docker/php/confi.d` for each version of PHP.
You can change this XDebugs CLI behaviour by editing the `./docker/php/confi.d` file.

### Web (HTTP)

XDebug for the web with breakpoints is accomplished via the environment variables for PHP.

During dev server startup the XDebug environment variables override the CLI setup. XDebug will attempt
to open a connection back to your IDE on port 9000 for web requests.

You can edit the line `command: bash -c 'export XDEBUG_MODE=debug,develop,gcstats,profile,trace XDEBUG_CONFIG="remote_enable=on"; php -S 0.0.0.0:80 -t /app/html'`
in the `docker-compose.yml` file to change this behaviour.

### Code Profiling

Execution statistics will be dumped in `\xdebug.info`.  You can use profiling tools like
PhpStorms' Tools->Analyze XDebug Profile Snapshot.

The profile file will be called `profile.out`.

Other statistic like garbage collect `gcstats.out` and trace `trace.out.txt` can also be found
in xdebug.info.

## Testing

### Codeception

Codeception [https://codeception.com/](https://codeception.com/) is installed by default and can be run inside
the dev-server container with `codeception`.

`docker exec -it (container) bash`

user@45640a57cf9f:/app$ `codeception (command)`

## MariaDB

The `docker-compose.yml` includes a MariaDB server and PhpMyAdmin setup by default.  It is set up to allow quick 
access to the database using a browser.  

To access the PhpMyAdmin tool open [http://localhost:9082](http://localhost:9082).

To change the default database name, edit the `docker-compose.yml` file and change "database_name" to your 
default database name.

### Startup DB

A startup database can be created by placing a scrip in the `db-startup` directory.  See the 
[README.md](db-startup/README.md) file in that directory for detail.

## Redis

The `docker-compose.yml` includes a Redis cache server.

To access to Redis web tool open [http://localhost:9083](http://localhost:9083).

# Simulated Production server

The `prod-server` can be used to simulate the code in a production type environment, without the overhead
of the debugger or other libraries.  

Be sure to tell composer to install the production libraries using `composer install --no-dev` from the
development container.

The production server is available at [http://localhost:8002](http://localhost:8002).

# Performance Testing (Apache AB)

The performance-testing container is used for testing the code relative to itself.  You can use this 
tool to test different versions of PHP.  Different caching methodologies and different database select.

The idea is that using this tool you can see if your code is getting faster of slower for any given changes.  

You can keep a record of past performance tests to make a before and after comparison.

To run the sample test, open a bash shell into the `performance-testing` container.  From that change directory 
into performance-testing and run `./test1.sh`.

[https://httpd.apache.org/docs/2.4/programs/ab.html](https://httpd.apache.org/docs/2.4/programs/ab.html)


## A Common Testing scenario 

After testing and checking in the code to the dev branch, checkout the qa branch and run the same tests.  
Using this as a baseline you can see if your code has gotten faster or slower.

# MockServer

[MockServer](https://www.mock-server.com/) allows you to mock any server or service via HTTP or HTTPS, such as a REST 
or RPC service.

To open the MockServer UI http://localhost:9085/mockserver/dashboard.

Edit the files in /mockcfg to change the mock responses.

This is useful in the following scenarios:

* testing
  * easily recreate all types of responses for HTTP dependencies such as REST or RPC services to test applications easily and affectively
  * isolate the system-under-test to ensure tests run reliably and only fail when there is a genuine bug. It is important only the system-under-test is tested and not its dependencies to avoid tests failing due to irrelevant external changes such as network failure or a server being rebooted / redeployed.
  * easily set up mock responses independently for each test to ensure test data is encapsulated with each test. Avoid sharing data between tests that is difficult to manage and maintain and risks tests infecting each other
  * create test assertions that verify the requests the system-under-test has sent
* de-coupling development
  * start working against a service API before the service is available. If an API or service is not yet fully developed MockServer can mock the API allowing any team who is using the service to start work without being delayed
  * isolate development teams during the initial development phases when the APIs / services may be extremely unstable and volatile. Using MockServer allows development work to continue even when an external service fails
* isolate single service
  * during deployment and debugging it is helpful to run a single application or service or handle a sub-set of requests on on a local machine in debug mode. Using MockServer it is easy to selectively forward requests to a local process running in debug mode, all other request can be forwarded to the real services for example running in a QA or UAT environment

# Final Notes

This is just a starting point.  Use this project a template for starting or moving your project to docker.

# Known Issues with Windows 10 and WSL

10/6/2021 - If you are using the PhpStorm and your files are in the wsl os, ie `\\wsl$\...`, you will need to start 
Docker Desktop after you start PhpStorm.  If you do not, PhpStorm may hang on Indexing.  This may also apply to other
JetBrains products.  You can "Exit" Docker Desktop restart PhpStorm let it finish indexing then restart Docker Desktop 
as well to get past the PhpStorm hang.

Sometimes you will just need to purge all the images `docker system prune -a` and restart Docker.
