# Info
Place your modules here. 

Don't forget to add the module to Config.lua

# Structure
```
ModuleName
    |->Pre
        |->File.lua
    |->Post
        |->File.lua
    |->Replace
        |->File.lua
    |->Halt
        |->File.lua
    |->Client
        |->Client.lua
    |->Server
        |->Server.lua
    |->Predict
        |->Predict.lua
    |->Shared
        |->Shared.lua
```

The above shows every possible VM/Hook that is possible within a module.

* NS2 ModLoader Hooks
    * Pre
        * Loads the script *before* the vanilla file
    * Post
        * Loads the script *after* the vanilla file
    * Replace
        * Replaces the vanilla file with the script
    * Halt 
        * Prevents the execution of the vanilla script
* VMs
    * Client
        * Runs all scripts in this folder on the Client VM
    * Server
        * Runs all scripts in this folder on the Server VM
    * Predict
        * Runs all scripts in this folder on the Predict VM
    * Shared
        * Runs all scripts in this folder on all VMs.