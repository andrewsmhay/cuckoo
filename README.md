Cuckoo Sandbox Cookbook
===============
Cuckoo Sandbox (http://www.cuckoosandbox.org/) is a completely open source solution, meaning that you can look at its internals, modify it and customize it at your will. Go on and download it to start tackling malware. This cookbook installs and configures everything required to build your own Cuckoo Sandbox malware analysis host.

Requirements
------------

#### operating system
- Ubuntu Server 12.04+

Usage
-----
#### cuckoo::default

Just include `cuckoo` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cuckoo]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:
- Andrew Hay, Director of Applied Security Research, CloudPassage, Inc.

License:

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.