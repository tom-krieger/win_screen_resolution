# win_screen_resolution

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with win_screen_resolution](#setup)
    * [What win_screen_resolution affects](#what-win_screen_resolution-affects)
    * [Setup requirements](#setup-requirements)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference](#reference)
1. [Limitations](#limitations)
1. [Development](#development)
1. [Changelog](#changelog)
1. [Contributors](#contributors)
1. [Warranty](#warranty)

## Description

The win_screen_resolution module helps you with a class to set the screen resolution of a windows system.
Please keep in mind that this works not for remote desktop sessions.
This module adds a fact `win_screen_resolution` for the current screen resolution.

## Setup

### What win_screen_resolution affects

This module changes the screen resolution of a windows system and stores this resolution permanently.

### Setup Requirements

This modules has some dependencies to other Puppet modules on the Forge. Please have a look into the
dependencies section and make sure you have these modules installed.

This module also needs the ruby gem `Fiddle` installed into the Puppet agent. You can install this gem
yourself or leave this to this module.

## Usage

The most easiest way to use this module with its default definitions is to do the following:

```puppet
include win_screen_resolution
```

You can provide all configurations using Hiera.

```hiera
win_screen_resolution::width: 1600
win_screen_resolution::height: 1200
win_screen_resolution::install_agent_gems: true
```

The `common.yaml` file in the `data` folder contains the valid screen resolution definitions and is
an example for how to override these valid resolutions.

Another way to call the module's class:

```puppet
class { 'win_screen_resolution':
  width              => 1600,
  height             => 1200,
  install_agent_gems => true,
}
```

## Reference

See [REFERENCE.md](https://ww.github.com/tom-krieger/win_screen_resolution/main/blob/REFERENCE.md) or the `Reference`section of this module.

## Limitations

The module has been tested on Windows 2019 Server only. If you use it on other Windows systems
please let me know your results.

## Development

Contributions are welcome in any form, pull requests, and issues should be filed via GitHub.

## Changelog

See [CHANGELOG.md](https://github.com/tom-krieger/win_screen_resolution/blob/main/CHANGELOG.md)

## Contributors

The list of contributors can be found at: [https://github.com/tom-krieger/win_screen_resolution/graphs/contributors](https://github.com/tom-krieger/cis_security_hardening/graphs/contributors).

## Warranty

This Puppet module is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Apache 2.0 License for more details.
