XDebug will dump its logs and details into this directory.

You need to create any new server XDebug paths first to get the correct permissions. If you don't create
the path first the directory will have root only permissions and the debugger will not be able
to write to it.

After you crate the path, copy the `.gitignore` from another xdebug.info path to allow git to commit it.