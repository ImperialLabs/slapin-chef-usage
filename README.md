# Chef Node Usage Plugin

This SLAPIN will list each org and how many nodes per org. It will also display the total at the end of the list.

This tool is mostly useful for enterprise customers as they are charged by the node.

<!-- TOC depthFrom:1 depthTo:6 -->

- [Chef Node Usage Plugin](#chef-node-usage-plugin)
    - [Requirements](#requirements)
    - [Install](#install)
        - [Config File](#config-file)
        - [Pull](#pull)
        - [Build](#build)
    - [Usage](#usage)

<!-- /TOC -->

## Requirements
-   Chef Pivotal Key (Required to query every Org)

## Install
Below are all the different install options

- Acquire your `pivotal.pem` from `/etc/opscode` directory
- Make sure to change out the bind setting `/path/to/pivotal.pem` in the config file section below

### Config File
You can use the default file in this repo: [Here](chef-usage.yml) or look at the options below

### Pull
- Create file below in `slapi/config/chef-usage.yml`
```yaml
plugin:
    type: container
    listen_type: passive
    data_type: all
    config:
      Image: 'slapi/slapin-chef-usage'
      HostConfig:
        Binds:
          - '/path/to/pivotal.pem:/chef-usage.pem'
```

### Build
- Clone this repo from `slapi/config/plugins` (so you create `slapi/config/plugins/chef-usage`)
    -   `git clone https://github.com/ImperialLabs/slapin-chef-usage.git chef-usage`
- Place the file below in `slapi/config/chef-usage.yml`
```yaml
plugin:
    type: container
    listen_type: passive
    data_type: all
    build: true
    config:
      Image: 'chef-usage'
      HostConfig:
        Binds:
          - '/path/to/pivotal.pem:/chef-usage.pem'
```

## Usage
From chat

`@bot chef-usage`